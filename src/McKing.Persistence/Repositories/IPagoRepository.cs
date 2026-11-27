using McKing.Persistence.Entities;

namespace McKing.Persistence.Repositories;

public interface IPagoRepository
{
    /// <summary>
    /// Registra el pago y confirma el pedido (PendientePago → Confirmado) en una misma transacción.
    /// Devuelve false si el pedido ya no estaba pendiente de pago.
    /// </summary>
    bool Registrar(Pago pago);
}
