using System.Data;
using System.Data.Common;
using RetroGames.Model.Model;
using RetroGames.Repository.Base;
using RetroGames.Repository.Interfaces;

namespace RetroGames.Repository.Repositories;

/// <summary>Todo o SQL da tabela tb_genero.</summary>
public class GeneroRepository(RepositoryConfig config) : RepositoryBase(config), IGeneroRepository
{
    public async Task<List<Genero>> ListarAsync()
    {
        const string sql = """
            SELECT co_seq_genero, no_genero
            FROM tb_genero
            ORDER BY no_genero
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        await using var leitor = await comando.ExecuteReaderAsync();

        var generos = new List<Genero>();
        while (await leitor.ReadAsync())
        {
            generos.Add(Mapear(leitor));
        }
        return generos;
    }

    /// <summary>Converte a linha atual do leitor num objeto Genero, coluna por coluna.</summary>
    private static Genero Mapear(DbDataReader leitor) => new()
    {
        Id = leitor.GetInt32("co_seq_genero"),
        Nome = leitor.GetString("no_genero"),
    };
}
