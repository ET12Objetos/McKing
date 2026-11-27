using System.Data;
using MySqlConnector;

namespace McKing.Persistence.Connection;

public sealed class MySqlConnectionFactory(string connectionString) : IDbConnectionFactory
{
    public IDbConnection CreateOpenConnection()
    {
        var connection = new MySqlConnection(connectionString);
        connection.Open();
        return connection;
    }
}
