using McKing.Persistence.Enums;

namespace McKing.Persistence.Entities;

public class PedidoItem
{
    public long Id { get; set; }
    public long PedidoId { get; set; }
    public int ProductoId { get; set; }
    public string ProductoNombre { get; set; } = string.Empty;
    public int Cantidad { get; set; }
    public decimal PrecioUnitario { get; set; }
    public decimal Subtotal { get; set; }
    public string? Observaciones { get; set; }
    /// <summary>Estación de cocina del producto (solo lectura, viene del JOIN con productos).</summary>
    public EstacionCocina Estacion { get; set; }
}
