using Dapper;
using McKing.Persistence.Connection;
using McKing.Persistence.Entities;
using McKing.Persistence.Enums;
using McKing.Persistence.ReadModels;

namespace McKing.Persistence.Repositories;

public sealed class PedidoRepository(IDbConnectionFactory connectionFactory) : IPedidoRepository
{
    private const string ColumnasPedido = """
        p.id, p.numero_retiro, p.fecha_operativa, p.canal, p.tipo_consumo, p.estado,
        p.nombre_cliente, p.total, p.fecha_creacion, p.fecha_actualizacion
        """;

    private const string SelectItems = """
        SELECT pi.id, pi.pedido_id, pi.producto_id, pr.nombre AS producto_nombre, pr.estacion,
               pi.cantidad, pi.precio_unitario, pi.subtotal, pi.observaciones
        FROM pedido_items pi
        INNER JOIN productos pr ON pr.id = pi.producto_id
        """;

    private const string SelectPantalla = """
        SELECT p.id, p.numero_retiro, p.nombre_cliente, p.canal, p.estado, p.fecha_creacion, p.fecha_actualizacion,
               TIMESTAMPDIFF(SECOND, p.fecha_creacion, NOW()) AS segundos_transcurridos
        FROM pedidos p
        """;

    public (long Id, int NumeroRetiro) Crear(Pedido pedido, IReadOnlyList<PedidoItem> items)
    {
        // El numerador por día se incrementa de forma atómica: el primer pedido del día recibe el 101.
        const string sqlNumero = """
            INSERT INTO secuencias_retiro (fecha_operativa, ultimo_numero)
            VALUES (CURDATE(), LAST_INSERT_ID(101))
            ON DUPLICATE KEY UPDATE ultimo_numero = LAST_INSERT_ID(ultimo_numero + 1);
            SELECT LAST_INSERT_ID();
            """;

        const string sqlPedido = """
            INSERT INTO pedidos (numero_retiro, fecha_operativa, canal, tipo_consumo, estado, nombre_cliente, total, fecha_creacion, fecha_actualizacion)
            VALUES (@NumeroRetiro, CURDATE(), @Canal, @TipoConsumo, @Estado, @NombreCliente, @Total, NOW(), NOW());
            SELECT LAST_INSERT_ID();
            """;

        const string sqlItem = """
            INSERT INTO pedido_items (pedido_id, producto_id, cantidad, precio_unitario, subtotal, observaciones)
            VALUES (@PedidoId, @ProductoId, @Cantidad, @PrecioUnitario, @Subtotal, @Observaciones);
            """;

        using var cn = connectionFactory.CreateOpenConnection();
        using var tx = cn.BeginTransaction();

        var numeroRetiro = cn.ExecuteScalar<int>(sqlNumero, transaction: tx);

        var pedidoId = cn.ExecuteScalar<long>(sqlPedido, new
        {
            NumeroRetiro = numeroRetiro,
            Canal = pedido.Canal.ToString(),
            TipoConsumo = pedido.TipoConsumo.ToString(),
            Estado = EstadoPedido.PendientePago.ToString(),
            pedido.NombreCliente,
            pedido.Total
        }, tx);

        cn.Execute(sqlItem, items.Select(i => new
        {
            PedidoId = pedidoId,
            i.ProductoId,
            i.Cantidad,
            i.PrecioUnitario,
            i.Subtotal,
            i.Observaciones
        }), tx);

        cn.Execute(HistorialSql.Insertar, new
        {
            PedidoId = pedidoId,
            EstadoAnterior = (string?)null,
            EstadoNuevo = EstadoPedido.PendientePago.ToString()
        }, tx);

        tx.Commit();
        return (pedidoId, numeroRetiro);
    }

    public Pedido? ObtenerPorId(long id)
    {
        const string sql = $"SELECT {ColumnasPedido} FROM pedidos p WHERE p.id = @Id;";

        using var cn = connectionFactory.CreateOpenConnection();
        return cn.QuerySingleOrDefault<Pedido>(sql, new { Id = id });
    }

    public PedidoDetalle? ObtenerDetalle(long id)
    {
        const string sql = $"""
            SELECT {ColumnasPedido} FROM pedidos p WHERE p.id = @Id;
            {SelectItems} WHERE pi.pedido_id = @Id ORDER BY pi.id;
            SELECT id, pedido_id, medio_pago, monto, monto_recibido, vuelto, fecha_pago FROM pagos WHERE pedido_id = @Id;
            SELECT id, pedido_id, estado_anterior, estado_nuevo, fecha FROM historial_estados_pedido WHERE pedido_id = @Id ORDER BY fecha, id;
            """;

        using var cn = connectionFactory.CreateOpenConnection();
        using var grid = cn.QueryMultiple(sql, new { Id = id });

        var pedido = grid.ReadSingleOrDefault<Pedido>();
        if (pedido is null) return null;

        return new PedidoDetalle
        {
            Pedido = pedido,
            Items = grid.Read<PedidoItem>().AsList(),
            Pago = grid.ReadSingleOrDefault<Pago>(),
            Historial = grid.Read<HistorialEstado>().AsList()
        };
    }

    public IReadOnlyList<Pedido> ListarDelDia(EstadoPedido? estado)
    {
        const string sql = $"""
            SELECT {ColumnasPedido}
            FROM pedidos p
            WHERE p.fecha_operativa = CURDATE() AND (@Estado IS NULL OR p.estado = @Estado)
            ORDER BY p.numero_retiro;
            """;

        using var cn = connectionFactory.CreateOpenConnection();
        return cn.Query<Pedido>(sql, new { Estado = estado?.ToString() }).AsList();
    }

    public IReadOnlyList<PedidoDetalle> ObtenerColaCocina()
    {
        const string sqlPedidos = $"""
            SELECT {ColumnasPedido}
            FROM pedidos p
            INNER JOIN pagos pg ON pg.pedido_id = p.id
            WHERE p.fecha_operativa = CURDATE() AND p.estado IN ('Confirmado', 'EnPreparacion')
            ORDER BY pg.fecha_pago, p.id;
            """;

        const string sqlItems = $"{SelectItems} WHERE pi.pedido_id IN @Ids ORDER BY pi.pedido_id, pi.id;";

        using var cn = connectionFactory.CreateOpenConnection();
        var pedidos = cn.Query<Pedido>(sqlPedidos).AsList();
        if (pedidos.Count == 0) return [];

        var items = cn.Query<PedidoItem>(sqlItems, new { Ids = pedidos.Select(p => p.Id).ToArray() })
            .ToLookup(i => i.PedidoId);

        return pedidos
            .Select(p => new PedidoDetalle { Pedido = p, Items = items[p.Id].ToList() })
            .ToList();
    }

    public IReadOnlyList<PedidoPantalla> ObtenerPantalla()
    {
        const string sql = $"""
            {SelectPantalla}
            WHERE p.fecha_operativa = CURDATE() AND p.estado IN ('Confirmado', 'EnPreparacion', 'Listo')
            ORDER BY p.fecha_actualizacion, p.numero_retiro;
            """;

        using var cn = connectionFactory.CreateOpenConnection();
        return cn.Query<PedidoPantalla>(sql).AsList();
    }

    public PedidoPantalla? ObtenerPorNumeroRetiro(int numeroRetiro)
    {
        const string sql = $"""
            {SelectPantalla}
            WHERE p.fecha_operativa = CURDATE() AND p.numero_retiro = @NumeroRetiro;
            """;

        using var cn = connectionFactory.CreateOpenConnection();
        return cn.QuerySingleOrDefault<PedidoPantalla>(sql, new { NumeroRetiro = numeroRetiro });
    }

    public bool CambiarEstado(long id, EstadoPedido estadoActual, EstadoPedido estadoNuevo)
    {
        const string sqlUpdate = """
            UPDATE pedidos
            SET estado = @EstadoNuevo, fecha_actualizacion = NOW()
            WHERE id = @Id AND estado = @EstadoActual;
            """;

        var parametros = new
        {
            Id = id,
            PedidoId = id,
            EstadoActual = estadoActual.ToString(),
            EstadoAnterior = estadoActual.ToString(),
            EstadoNuevo = estadoNuevo.ToString()
        };

        using var cn = connectionFactory.CreateOpenConnection();
        using var tx = cn.BeginTransaction();

        if (cn.Execute(sqlUpdate, parametros, tx) == 0)
        {
            tx.Rollback();
            return false;
        }

        cn.Execute(HistorialSql.Insertar, parametros, tx);
        tx.Commit();
        return true;
    }
}
