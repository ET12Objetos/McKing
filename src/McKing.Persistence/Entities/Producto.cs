using McKing.Persistence.Enums;

namespace McKing.Persistence.Entities;

public class Producto
{
    public int Id { get; set; }
    public int CategoriaId { get; set; }
    public string CategoriaNombre { get; set; } = string.Empty;
    public string Nombre { get; set; } = string.Empty;
    public string? Descripcion { get; set; }
    public decimal Precio { get; set; }
    public bool EsCombo { get; set; }
    public bool Disponible { get; set; }
    public EstacionCocina Estacion { get; set; }
    public int TiempoPreparacionMin { get; set; }
}
