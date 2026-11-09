using System.Data;
using System.Data.Common;
using RetroGames.Model.Model;
using RetroGames.Repository.Base;
using RetroGames.Repository.Interfaces;

namespace RetroGames.Repository.Repositories;

/// <summary>
/// Todo o SQL da tabela tb_plataforma. Cada método executa uma consulta numa única
/// tabela, com os valores sempre como parâmetros, e devolve os dados sem conferir regras.
/// </summary>
public class PlataformaRepository(RepositoryConfig config) : RepositoryBase(config), IPlataformaRepository
{
    public async Task<List<Plataforma>> ListarAsync()
    {
        const string sql = """
            SELECT co_seq_plataforma, no_plataforma, no_fabricante, nu_ano_lancamento
            FROM tb_plataforma
            ORDER BY no_plataforma
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        await using var leitor = await comando.ExecuteReaderAsync();

        var plataformas = new List<Plataforma>();
        while (await leitor.ReadAsync())
        {
            plataformas.Add(Mapear(leitor));
        }
        return plataformas;
    }

    public async Task<Plataforma?> BuscarPorIdAsync(int id)
    {
        const string sql = """
            SELECT co_seq_plataforma, no_plataforma, no_fabricante, nu_ano_lancamento
            FROM tb_plataforma
            WHERE co_seq_plataforma = @id
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@id", id);
        await using var leitor = await comando.ExecuteReaderAsync();

        return await leitor.ReadAsync() ? Mapear(leitor) : null;
    }

    public async Task<bool> ExisteComNomeAsync(string nome, int? idIgnorar = null)
    {
        const string sql = """
            SELECT COUNT(*)
            FROM tb_plataforma
            WHERE no_plataforma = @nome
              AND (@id_ignorar IS NULL OR co_seq_plataforma <> @id_ignorar)
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@nome", nome);
        AdicionarParametro(comando, "@id_ignorar", idIgnorar);

        var quantidade = Convert.ToInt64(await comando.ExecuteScalarAsync());
        return quantidade > 0;
    }

    public async Task<bool> PossuiJogosAsync(int id)
    {
        const string sql = """
            SELECT COUNT(*)
            FROM tb_jogo
            WHERE co_plataforma = @id
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@id", id);

        var quantidade = Convert.ToInt64(await comando.ExecuteScalarAsync());
        return quantidade > 0;
    }

    public async Task<int> InserirAsync(Plataforma plataforma)
    {
        const string sql = """
            INSERT INTO tb_plataforma (no_plataforma, no_fabricante, nu_ano_lancamento)
            VALUES (@nome, @fabricante, @ano_lancamento)
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@nome", plataforma.Nome);
        AdicionarParametro(comando, "@fabricante", plataforma.Fabricante);
        AdicionarParametro(comando, "@ano_lancamento", plataforma.AnoLancamento);

        await ExecutarGravacaoAsync(comando);
        return (int)comando.LastInsertedId;
    }

    public async Task AlterarAsync(Plataforma plataforma)
    {
        const string sql = """
            UPDATE tb_plataforma
            SET no_plataforma = @nome,
                no_fabricante = @fabricante,
                nu_ano_lancamento = @ano_lancamento
            WHERE co_seq_plataforma = @id
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@nome", plataforma.Nome);
        AdicionarParametro(comando, "@fabricante", plataforma.Fabricante);
        AdicionarParametro(comando, "@ano_lancamento", plataforma.AnoLancamento);
        AdicionarParametro(comando, "@id", plataforma.Id);

        await ExecutarGravacaoAsync(comando);
    }

    public async Task ExcluirAsync(int id)
    {
        const string sql = """
            DELETE FROM tb_plataforma
            WHERE co_seq_plataforma = @id
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@id", id);

        await ExecutarGravacaoAsync(comando);
    }

    /// <summary>Converte a linha atual do leitor num objeto Plataforma, coluna por coluna.</summary>
    private static Plataforma Mapear(DbDataReader leitor) => new()
    {
        Id = leitor.GetInt32("co_seq_plataforma"),
        Nome = leitor.GetString("no_plataforma"),
        Fabricante = leitor.GetString("no_fabricante"),
        AnoLancamento = leitor.GetInt32("nu_ano_lancamento"),
    };
}
