using MySqlConnector;

namespace RetroGames.Repository.Base;

/// <summary>
/// Base de todos os repositórios. Reúne o que todo Repository faz: abrir a conexão,
/// criar o comando, passar valores como parâmetros e executar gravações.
/// Não tem SQL de nenhuma tabela.
/// </summary>
/// <remarks>
/// Quem chama deve usar <c>await using</c> na conexão, no comando e no leitor,
/// para que sejam fechados mesmo em caso de erro.
/// </remarks>
public abstract class RepositoryBase(RepositoryConfig config)
{
    /// <summary>Abre uma conexão com o banco usando a connection string da <see cref="RepositoryConfig"/>.</summary>
    protected async Task<MySqlConnection> CriarConexaoAsync()
    {
        var conexao = new MySqlConnection(config.ConnectionString);
        try
        {
            await conexao.OpenAsync();
            return conexao;
        }
        catch
        {
            await conexao.DisposeAsync();
            throw;
        }
    }

    /// <summary>Cria um comando com o texto SQL informado.</summary>
    protected static MySqlCommand CriarComando(MySqlConnection conexao, string sql)
    {
        var comando = conexao.CreateCommand();
        comando.CommandText = sql;
        return comando;
    }

    /// <summary>
    /// Adiciona um parâmetro ao comando (ex.: "@id", 5). O valor nunca é concatenado
    /// no SQL: é isso que impede SQL injection. <c>null</c> vira NULL no banco.
    /// </summary>
    protected static void AdicionarParametro(MySqlCommand comando, string nome, object? valor)
    {
        comando.Parameters.AddWithValue(nome, valor ?? DBNull.Value);
    }

    /// <summary>
    /// Executa uma gravação (INSERT ou UPDATE; também usada no DELETE) e devolve o número
    /// de linhas afetadas. O erro 1062 do MySQL (valor repetido numa coluna UNIQUE) é
    /// convertido aqui, num único lugar, em <see cref="RegistroDuplicadoException"/>.
    /// </summary>
    protected static async Task<int> ExecutarGravacaoAsync(MySqlCommand comando)
    {
        try
        {
            return await comando.ExecuteNonQueryAsync();
        }
        catch (MySqlException ex) when (ex.ErrorCode == MySqlErrorCode.DuplicateKeyEntry)
        {
            throw new RegistroDuplicadoException(
                "Já existe um registro com este valor numa coluna que não admite repetição.", ex);
        }
    }
}
