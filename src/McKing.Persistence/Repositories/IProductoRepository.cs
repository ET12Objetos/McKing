using McKing.Persistence.Entities;

namespace McKing.Persistence.Repositories;

public interface IProductoRepository
{
    IReadOnlyList<Categoria> ObtenerCategorias();
    IReadOnlyList<Producto> ObtenerProductos(int? categoriaId, bool incluirNoDisponibles);
    Producto? ObtenerPorId(int id);
    IReadOnlyList<Producto> ObtenerPorIds(IEnumerable<int> ids);
    IReadOnlyList<ComboComponente> ObtenerComponentes(IEnumerable<int> comboIds);
    bool CambiarDisponibilidad(int id, bool disponible);
}
