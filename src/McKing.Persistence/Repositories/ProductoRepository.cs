using Dapper;
using McKing.Persistence.Connection;
using McKing.Persistence.Entities;

namespace McKing.Persistence.Repositories;

public sealed class ProductoRepository(IDbConnectionFactory connectionFactory) : IProductoRepository
{
    private const string SelectProductos = """
        SELECT p.id, p.categoria_id, c.nombre AS categoria_nombre, p.nombre, p.descripcion, p.precio,
               p.es_combo, p.disponible, p.estacion, p.tiempo_preparacion_min
        FROM productos p
        INNER JOIN categorias c ON c.id = p.categoria_id
        """;

    public IReadOnlyList<Categoria> ObtenerCategorias()
    {
        const string sql = "SELECT id, nombre, descripcion, orden FROM categorias ORDER BY orden, nombre;";

        using var cn = connectionFactory.CreateOpenConnection();
        return cn.Query<Categoria>(sql).AsList();
    }

    public IReadOnlyList<Producto> ObtenerProductos(int? categoriaId, bool incluirNoDisponibles)
    {
        const string sql = SelectProductos + """

            WHERE (@CategoriaId IS NULL OR p.categoria_id = @CategoriaId)
              AND (@IncluirNoDisponibles = 1 OR p.disponible = 1)
            ORDER BY c.orden, p.nombre;
            """;

        using var cn = connectionFactory.CreateOpenConnection();
        return cn.Query<Producto>(sql, new { CategoriaId = categoriaId, IncluirNoDisponibles = incluirNoDisponibles }).AsList();
    }

    public Producto? ObtenerPorId(int id)
    {
        const string sql = SelectProductos + "\nWHERE p.id = @Id;";

        using var cn = connectionFactory.CreateOpenConnection();
        return cn.QuerySingleOrDefault<Producto>(sql, new { Id = id });
    }

    public IReadOnlyList<Producto> ObtenerPorIds(IEnumerable<int> ids)
    {
        var lista = ids.Distinct().ToArray();
        if (lista.Length == 0) return [];

        const string sql = SelectProductos + "\nWHERE p.id IN @Ids;";

        using var cn = connectionFactory.CreateOpenConnection();
        return cn.Query<Producto>(sql, new { Ids = lista }).AsList();
    }

    public IReadOnlyList<ComboComponente> ObtenerComponentes(IEnumerable<int> comboIds)
    {
        var lista = comboIds.Distinct().ToArray();
        if (lista.Length == 0) return [];

        const string sql = """
            SELECT cc.combo_id, cc.producto_id, p.nombre AS producto_nombre, cc.cantidad
            FROM combo_componentes cc
            INNER JOIN productos p ON p.id = cc.producto_id
            WHERE cc.combo_id IN @Ids
            ORDER BY cc.combo_id, p.categoria_id, p.nombre;
            """;

        using var cn = connectionFactory.CreateOpenConnection();
        return cn.Query<ComboComponente>(sql, new { Ids = lista }).AsList();
    }

    public bool CambiarDisponibilidad(int id, bool disponible)
    {
        const string sql = "UPDATE productos SET disponible = @Disponible WHERE id = @Id;";

        using var cn = connectionFactory.CreateOpenConnection();
        return cn.Execute(sql, new { Id = id, Disponible = disponible }) > 0;
    }
}
