using System.Data;
using System.Data.Common;
using RetroGames.Model.Model;
using RetroGames.Repository.Base;
using RetroGames.Repository.Interfaces;

namespace RetroGames.Repository.Repositories;

/// <summary>Todo o SQL da tabela tb_condicao_jogo.</summary>
public class CondicaoJogoRepository(RepositoryConfig config) : RepositoryBase(config), ICondicaoJogoRepository
{
    public async Task<List<CondicaoJogo>> ListarAsync()
    {
        const string sql = """
            SELECT co_condicao_jogo, ds_condicao_jogo
            FROM tb_condicao_jogo
            ORDER BY co_condicao_jogo
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        await using var leitor = await comando.ExecuteReaderAsync();

        var condicoes = new List<CondicaoJogo>();
        while (await leitor.ReadAsync())
        {
            condicoes.Add(Mapear(leitor));
        }
        return condicoes;
    }

    /// <summary>Converte a linha atual do leitor num objeto CondicaoJogo, coluna por coluna.</summary>
    private static CondicaoJogo Mapear(DbDataReader leitor) => new()
    {
        Id = leitor.GetInt32("co_condicao_jogo"),
        Descricao = leitor.GetString("ds_condicao_jogo"),
    };
}
