using Dapper;
using McKing.Persistence.Connection;
using McKing.Persistence.Entities;
using McKing.Persistence.Enums;

namespace McKing.Persistence.Repositories;

public sealed class PagoRepository(IDbConnectionFactory connectionFactory) : IPagoRepository
{
    public bool Registrar(Pago pago)
    {
        const string sqlConfirmar = """
            UPDATE pedidos
            SET estado = @EstadoNuevo, fecha_actualizacion = NOW()
            WHERE id = @PedidoId AND estado = @EstadoAnterior;
            """;

        const string sqlPago = """
            INSERT INTO pagos (pedido_id, medio_pago, monto, monto_recibido, vuelto, fecha_pago)
            VALUES (@PedidoId, @MedioPago, @Monto, @MontoRecibido, @Vuelto, NOW());
            """;

        var transicion = new
        {
            pago.PedidoId,
            EstadoAnterior = EstadoPedido.PendientePago.ToString(),
            EstadoNuevo = EstadoPedido.Confirmado.ToString()
        };

        using var cn = connectionFactory.CreateOpenConnection();
        using var tx = cn.BeginTransaction();

        if (cn.Execute(sqlConfirmar, transicion, tx) == 0)
        {
            tx.Rollback();
            return false;
        }

        cn.Execute(sqlPago, new
        {
            pago.PedidoId,
            MedioPago = pago.MedioPago.ToString(),
            pago.Monto,
            pago.MontoRecibido,
            pago.Vuelto
        }, tx);

        cn.Execute(HistorialSql.Insertar, transicion, tx);
        tx.Commit();
        return true;
    }
}
