using McKing.Persistence.Entities;

namespace McKing.Persistence.ReadModels;

/// <summary>Pedido con todas sus partes: items, pago e historial de estados.</summary>
public class PedidoDetalle
{
    public required Pedido Pedido { get; init; }
    public IReadOnlyList<PedidoItem> Items { get; init; } = [];
    public Pago? Pago { get; init; }
    public IReadOnlyList<HistorialEstado> Historial { get; init; } = [];
}
