namespace McKing.Persistence.Repositories;

/// <summary>Sentencias compartidas entre repositorios para mantener la auditoría de estados.</summary>
internal static class HistorialSql
{
    public const string Insertar = """
        INSERT INTO historial_estados_pedido (pedido_id, estado_anterior, estado_nuevo, fecha)
        VALUES (@PedidoId, @EstadoAnterior, @EstadoNuevo, NOW());
        """;
}
