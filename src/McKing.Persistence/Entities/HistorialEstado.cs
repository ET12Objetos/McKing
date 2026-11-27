using McKing.Persistence.Enums;

namespace McKing.Persistence.Entities;

public class HistorialEstado
{
    public long Id { get; set; }
    public long PedidoId { get; set; }
    public EstadoPedido? EstadoAnterior { get; set; }
    public EstadoPedido EstadoNuevo { get; set; }
    public DateTime Fecha { get; set; }
}
