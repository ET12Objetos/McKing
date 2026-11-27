namespace McKing.Persistence.Entities;

public class ComboComponente
{
    public int ComboId { get; set; }
    public int ProductoId { get; set; }
    public string ProductoNombre { get; set; } = string.Empty;
    public int Cantidad { get; set; }
}
