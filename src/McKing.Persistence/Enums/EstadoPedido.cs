namespace McKing.Persistence.Enums;

/// <summary>Estados por los que pasa un pedido desde que se toma hasta que se entrega.</summary>
public enum EstadoPedido
{
    PendientePago,
    Confirmado,
    EnPreparacion,
    Listo,
    Entregado,
    Cancelado
}
