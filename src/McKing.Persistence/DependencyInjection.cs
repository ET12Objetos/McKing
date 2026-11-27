using Dapper;
using McKing.Persistence.Connection;
using McKing.Persistence.Repositories;
using Microsoft.Extensions.DependencyInjection;

namespace McKing.Persistence;

public static class DependencyInjection
{
    public static IServiceCollection AddPersistence(this IServiceCollection services, string connectionString)
    {
        // Mapea columnas snake_case (numero_retiro) a propiedades PascalCase (NumeroRetiro).
        DefaultTypeMap.MatchNamesWithUnderscores = true;

        services.AddSingleton<IDbConnectionFactory>(new MySqlConnectionFactory(connectionString));
        services.AddScoped<IProductoRepository, ProductoRepository>();
        services.AddScoped<IPedidoRepository, PedidoRepository>();
        services.AddScoped<IPagoRepository, PagoRepository>();
        return services;
    }
}
