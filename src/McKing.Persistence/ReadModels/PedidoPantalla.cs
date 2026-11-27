using McKing.Persistence.Enums;

namespace McKing.Persistence.ReadModels;

/// <summary>Proyección liviana de un pedido para la pantalla del cliente.</summary>
public class PedidoPantalla
{
    public long Id { get; set; }
    public int NumeroRetiro { get; set; }
    public string? NombreCliente { get; set; }
    public CanalVenta Canal { get; set; }
    public EstadoPedido Estado { get; set; }
    public DateTime FechaCreacion { get; set; }
    public DateTime FechaActualizacion { get; set; }
    /// <summary>Segundos desde que se tomó el pedido (calculado por el motor para evitar desfasajes de reloj).</summary>
    public long SegundosTranscurridos { get; set; }
}
