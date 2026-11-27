using System.Data;

namespace McKing.Persistence.Connection;

public interface IDbConnectionFactory
{
    IDbConnection CreateOpenConnection();
}
