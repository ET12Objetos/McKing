using McKing.Persistence.Enums;

namespace McKing.Persistence.Entities;

public class Pedido
{
    public long Id { get; set; }
    public int NumeroRetiro { get; set; }
    public DateTime FechaOperativa { get; set; }
    public CanalVenta Canal { get; set; }
    public TipoConsumo TipoConsumo { get; set; }
    public EstadoPedido Estado { get; set; }
    public string? NombreCliente { get; set; }
    public decimal Total { get; set; }
    public DateTime FechaCreacion { get; set; }
    public DateTime FechaActualizacion { get; set; }
}
