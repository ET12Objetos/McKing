using System.Text.Json.Serialization;
using McKing.Persistence;

var builder = WebApplication.CreateBuilder(args);

var connectionString = builder.Configuration.GetConnectionString("McKing")
    ?? throw new InvalidOperationException("Falta la cadena de conexión 'ConnectionStrings:McKing'.");

builder.Services.AddPersistence(connectionString);

// Minimal API: los enums viajan como texto en JSON ("EnPreparacion" en lugar de 2).
builder.Services.ConfigureHttpJsonOptions(o => o.SerializerOptions.Converters.Add(new JsonStringEnumConverter()));

builder.Services.AddOpenApi();

var app = builder.Build();

app.MapOpenApi();
app.UseSwaggerUI(options =>
{
    options.SwaggerEndpoint("/openapi/v1.json", "McKing API v1");
    options.DocumentTitle = "McKing API";
});

app.MapGet("/", () => Results.Redirect("/swagger")).ExcludeFromDescription();

// TODO: mapear los grupos de endpoints (ver README, sección 9). Ejemplo:
// app.MapMenuEndpoints();
// app.MapPedidosEndpoints();
// app.MapCocinaEndpoints();
// app.MapPantallaEndpoints();

app.Run();
