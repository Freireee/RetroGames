using System.Data;
using System.Data.Common;
using MySqlConnector;
using RetroGames.Model.Model;
using RetroGames.Repository.Base;
using RetroGames.Repository.Interfaces;
using RetroGames.Repository.Modelos;

namespace RetroGames.Repository.Repositories;

/// <summary>
/// Todo o SQL da tabela tb_jogo. A listagem filtra e pagina no próprio SQL e devolve
/// também o total. Nenhuma consulta usa JOIN: os gêneros vêm do JogoGeneroRepository
/// e quem combina jogo, plataforma e gêneros é o Service.
/// </summary>
public class JogoRepository(RepositoryConfig config) : RepositoryBase(config), IJogoRepository
{
    public async Task<ResultadoPaginado<Jogo>> ListarAsync(JogoFiltro filtro)
    {
        // O WHERE tem só nomes de colunas e de parâmetros; os valores entram como parâmetros.
        var where = MontarWhere(filtro);

        await using var conexao = await CriarConexaoAsync();

        // 1) Total encontrado, com o mesmo filtro da página
        await using var comandoTotal = CriarComando(conexao, $"""
            SELECT COUNT(*)
            FROM tb_jogo
            {where}
            """);
        AdicionarParametrosDoFiltro(comandoTotal, filtro);
        var total = Convert.ToInt32(await comandoTotal.ExecuteScalarAsync());

        // 2) Jogos da página pedida
        await using var comandoPagina = CriarComando(conexao, $"""
            SELECT co_seq_jogo, no_jogo, ds_jogo, co_plataforma, co_condicao_jogo,
                   nu_ano_lancamento, vl_preco, qt_estoque, st_ativo, dt_cadastro
            FROM tb_jogo
            {where}
            ORDER BY no_jogo, co_seq_jogo
            LIMIT @limite OFFSET @deslocamento
            """);
        AdicionarParametrosDoFiltro(comandoPagina, filtro);
        AdicionarParametro(comandoPagina, "@limite", filtro.ItensPorPagina);
        AdicionarParametro(comandoPagina, "@deslocamento", (filtro.Pagina - 1) * filtro.ItensPorPagina);
        await using var leitor = await comandoPagina.ExecuteReaderAsync();

        var jogos = new List<Jogo>();
        while (await leitor.ReadAsync())
        {
            jogos.Add(Mapear(leitor));
        }

        return new ResultadoPaginado<Jogo> { Itens = jogos, Total = total };
    }

    public async Task<Jogo?> BuscarPorIdAsync(int id)
    {
        const string sql = """
            SELECT co_seq_jogo, no_jogo, ds_jogo, co_plataforma, co_condicao_jogo,
                   nu_ano_lancamento, vl_preco, qt_estoque, st_ativo, dt_cadastro
            FROM tb_jogo
            WHERE co_seq_jogo = @id
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@id", id);
        await using var leitor = await comando.ExecuteReaderAsync();

        return await leitor.ReadAsync() ? Mapear(leitor) : null;
    }

    public async Task<int> InserirAsync(Jogo jogo)
    {
        const string sql = """
            INSERT INTO tb_jogo (no_jogo, ds_jogo, co_plataforma, co_condicao_jogo, nu_ano_lancamento,
                                 vl_preco, qt_estoque, st_ativo, dt_cadastro)
            VALUES (@nome, @descricao, @id_plataforma, @id_condicao_jogo, @ano_lancamento,
                    @preco, @estoque, @ativo, @data_cadastro)
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@nome", jogo.Nome);
        AdicionarParametro(comando, "@descricao", jogo.Descricao);
        AdicionarParametro(comando, "@id_plataforma", jogo.IdPlataforma);
        AdicionarParametro(comando, "@id_condicao_jogo", jogo.IdCondicaoJogo);
        AdicionarParametro(comando, "@ano_lancamento", jogo.AnoLancamento);
        AdicionarParametro(comando, "@preco", jogo.Preco);
        AdicionarParametro(comando, "@estoque", jogo.Estoque);
        AdicionarParametro(comando, "@ativo", jogo.Ativo);
        AdicionarParametro(comando, "@data_cadastro", jogo.DataCadastro);

        await ExecutarGravacaoAsync(comando);
        return (int)comando.LastInsertedId;
    }

    public async Task AlterarAsync(Jogo jogo)
    {
        const string sql = """
            UPDATE tb_jogo
            SET no_jogo = @nome,
                ds_jogo = @descricao,
                co_plataforma = @id_plataforma,
                co_condicao_jogo = @id_condicao_jogo,
                nu_ano_lancamento = @ano_lancamento,
                vl_preco = @preco,
                qt_estoque = @estoque,
                st_ativo = @ativo
            WHERE co_seq_jogo = @id
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@nome", jogo.Nome);
        AdicionarParametro(comando, "@descricao", jogo.Descricao);
        AdicionarParametro(comando, "@id_plataforma", jogo.IdPlataforma);
        AdicionarParametro(comando, "@id_condicao_jogo", jogo.IdCondicaoJogo);
        AdicionarParametro(comando, "@ano_lancamento", jogo.AnoLancamento);
        AdicionarParametro(comando, "@preco", jogo.Preco);
        AdicionarParametro(comando, "@estoque", jogo.Estoque);
        AdicionarParametro(comando, "@ativo", jogo.Ativo);
        AdicionarParametro(comando, "@id", jogo.Id);

        await ExecutarGravacaoAsync(comando);
    }

    public async Task DesativarAsync(int id)
    {
        const string sql = """
            UPDATE tb_jogo
            SET st_ativo = FALSE
            WHERE co_seq_jogo = @id
            """;

        await using var conexao = await CriarConexaoAsync();
        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@id", id);

        await ExecutarGravacaoAsync(comando);
    }

    /// <summary>
    /// Monta o WHERE só com os filtros informados. O texto gerado tem apenas colunas e
    /// nomes de parâmetros (@nome, @id_plataforma, @id0, @id1...), nunca valores.
    /// </summary>
    private static string MontarWhere(JogoFiltro filtro)
    {
        var condicoes = new List<string>();

        if (!filtro.IncluirInativos)
        {
            condicoes.Add("st_ativo = TRUE");
        }

        if (!string.IsNullOrWhiteSpace(filtro.Nome))
        {
            condicoes.Add("no_jogo LIKE CONCAT('%', @nome, '%')");
        }

        if (filtro.IdPlataforma is not null)
        {
            condicoes.Add("co_plataforma = @id_plataforma");
        }

        if (filtro.Ids is not null)
        {
            // Lista informada, mas vazia: nenhum jogo atende ao filtro.
            var parametros = filtro.Ids.Select((_, indice) => $"@id{indice}");
            condicoes.Add(filtro.Ids.Count == 0
                ? "FALSE"
                : $"co_seq_jogo IN ({string.Join(", ", parametros)})");
        }

        return condicoes.Count == 0 ? string.Empty : "WHERE " + string.Join(" AND ", condicoes);
    }

    /// <summary>Adiciona os valores dos filtros informados, com os mesmos nomes usados em <see cref="MontarWhere"/>.</summary>
    private static void AdicionarParametrosDoFiltro(MySqlCommand comando, JogoFiltro filtro)
    {
        if (!string.IsNullOrWhiteSpace(filtro.Nome))
        {
            AdicionarParametro(comando, "@nome", filtro.Nome.Trim());
        }

        if (filtro.IdPlataforma is not null)
        {
            AdicionarParametro(comando, "@id_plataforma", filtro.IdPlataforma);
        }

        if (filtro.Ids is not null)
        {
            for (var indice = 0; indice < filtro.Ids.Count; indice++)
            {
                AdicionarParametro(comando, $"@id{indice}", filtro.Ids[indice]);
            }
        }
    }

    /// <summary>Converte a linha atual do leitor num objeto Jogo, coluna por coluna.</summary>
    private static Jogo Mapear(DbDataReader leitor) => new()
    {
        Id = leitor.GetInt32("co_seq_jogo"),
        Nome = leitor.GetString("no_jogo"),
        Descricao = leitor.IsDBNull("ds_jogo") ? null : leitor.GetString("ds_jogo"),
        IdPlataforma = leitor.GetInt32("co_plataforma"),
        IdCondicaoJogo = leitor.GetInt32("co_condicao_jogo"),
        AnoLancamento = leitor.GetInt32("nu_ano_lancamento"),
        Preco = leitor.GetDecimal("vl_preco"),
        Estoque = leitor.GetInt32("qt_estoque"),
        Ativo = leitor.GetBoolean("st_ativo"),
        // dt_ guarda data e hora em UTC
        DataCadastro = DateTime.SpecifyKind(leitor.GetDateTime("dt_cadastro"), DateTimeKind.Utc),
    };
}
