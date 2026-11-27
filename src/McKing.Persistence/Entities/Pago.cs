using McKing.Persistence.Enums;

namespace McKing.Persistence.Entities;

public class Pago
{
    public long Id { get; set; }
    public long PedidoId { get; set; }
    public MedioPago MedioPago { get; set; }
    public decimal Monto { get; set; }
    public decimal MontoRecibido { get; set; }
    public decimal Vuelto { get; set; }
    public DateTime FechaPago { get; set; }
}
