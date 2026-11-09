using System.Data;
using System.Data.Common;
using RetroGames.Model.Model;
using RetroGames.Repository.Base;
using RetroGames.Repository.Interfaces;

namespace RetroGames.Repository.Repositories;

/// <summary>Todo o SQL da tabela tb_jogo_genero.</summary>
public class JogoGeneroRepository(RepositoryConfig config) : RepositoryBase(config), IJogoGeneroRepository
{
    public async Task<List<JogoGenero>> ListarTodosAsync()
    {
        const string sql = """
            SELECT co_jogo, co_genero
            FROM tb_jogo_genero
            ORDER BY co_jogo, co_genero
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        await using var leitor = await comando.ExecuteReaderAsync();

        var vinculos = new List<JogoGenero>();
        while (await leitor.ReadAsync())
        {
            vinculos.Add(Mapear(leitor));
        }
        return vinculos;
    }

    public async Task<List<JogoGenero>> ListarPorJogosAsync(List<int> idsJogos)
    {
        if (idsJogos.Count == 0)
        {
            return [];
        }

        // Um parâmetro por jogo (@id0, @id1...): todos os vínculos numa única consulta.
        var parametros = idsJogos.Select((_, indice) => $"@id{indice}");
        var sql = $"""
            SELECT co_jogo, co_genero
            FROM tb_jogo_genero
            WHERE co_jogo IN ({string.Join(", ", parametros)})
            ORDER BY co_jogo, co_genero
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        for (var indice = 0; indice < idsJogos.Count; indice++)
        {
            AdicionarParametro(comando, $"@id{indice}", idsJogos[indice]);
        }
        await using var leitor = await comando.ExecuteReaderAsync();

        var vinculos = new List<JogoGenero>();
        while (await leitor.ReadAsync())
        {
            vinculos.Add(Mapear(leitor));
        }
        return vinculos;
    }

    public async Task InserirAsync(int idJogo, List<int> idsGeneros)
    {
        if (idsGeneros.Count == 0)
        {
            return;
        }

        // Uma linha por gênero: (@id_jogo, @id_genero0), (@id_jogo, @id_genero1)...
        var linhas = idsGeneros.Select((_, indice) => $"(@id_jogo, @id_genero{indice})");
        var sql = $"""
            INSERT INTO tb_jogo_genero (co_jogo, co_genero)
            VALUES {string.Join(", ", linhas)}
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@id_jogo", idJogo);
        for (var indice = 0; indice < idsGeneros.Count; indice++)
        {
            AdicionarParametro(comando, $"@id_genero{indice}", idsGeneros[indice]);
        }

        await ExecutarGravacaoAsync(comando);
    }

    public async Task RemoverPorJogoAsync(int idJogo)
    {
        const string sql = """
            DELETE FROM tb_jogo_genero
            WHERE co_jogo = @id_jogo
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@id_jogo", idJogo);

        await ExecutarGravacaoAsync(comando);
    }

    /// <summary>Converte a linha atual do leitor num objeto JogoGenero, coluna por coluna.</summary>
    private static JogoGenero Mapear(DbDataReader leitor) => new()
    {
        IdJogo = leitor.GetInt32("co_jogo"),
        IdGenero = leitor.GetInt32("co_genero"),
    };
}
