using McKing.Persistence.Entities;
using McKing.Persistence.Enums;
using McKing.Persistence.ReadModels;

namespace McKing.Persistence.Repositories;

public interface IPedidoRepository
{
    /// <summary>
    /// Registra un pedido nuevo en estado <see cref="EstadoPedido.PendientePago"/>, le asigna el próximo
    /// número de retiro del día y deja el primer registro en el historial. Todo en una única transacción.
    /// </summary>
    (long Id, int NumeroRetiro) Crear(Pedido pedido, IReadOnlyList<PedidoItem> items);

    Pedido? ObtenerPorId(long id);

    PedidoDetalle? ObtenerDetalle(long id);

    IReadOnlyList<Pedido> ListarDelDia(EstadoPedido? estado);

    /// <summary>Pedidos pagados que la cocina tiene que preparar, en orden de llegada (FIFO por fecha de pago).</summary>
    IReadOnlyList<PedidoDetalle> ObtenerColaCocina();

    /// <summary>Pedidos del día que se muestran en la pantalla del cliente (confirmados, en preparación y listos).</summary>
    IReadOnlyList<PedidoPantalla> ObtenerPantalla();

    PedidoPantalla? ObtenerPorNumeroRetiro(int numeroRetiro);

    /// <summary>
    /// Cambia el estado solo si el pedido sigue en <paramref name="estadoActual"/> (concurrencia optimista)
    /// y registra el cambio en el historial. Devuelve false si otro proceso ya lo modificó.
    /// </summary>
    bool CambiarEstado(long id, EstadoPedido estadoActual, EstadoPedido estadoNuevo);
}
