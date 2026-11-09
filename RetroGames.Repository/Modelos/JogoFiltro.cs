namespace RetroGames.Repository.Modelos;

/// <summary>
/// Filtros e paginação da listagem de jogos. Cada filtro é opcional e só vale
/// quando é informado; a paginação é feita no SQL (LIMIT e OFFSET).
/// </summary>
public class JogoFiltro
{
    /// <summary>Parte do nome do jogo (busca com LIKE).</summary>
    public string? Nome { get; set; }

    /// <summary>Só os jogos desta plataforma.</summary>
    public int? IdPlataforma { get; set; }

    /// <summary>
    /// Só os jogos com estes ids (por exemplo, os jogos de um gênero, vindos do
    /// JogoGeneroRepository). Lista informada e vazia: nenhum jogo.
    /// </summary>
    public List<int>? Ids { get; set; }

    /// <summary>Inclui os jogos inativos. Por padrão, a listagem traz só os ativos.</summary>
    public bool IncluirInativos { get; set; }

    /// <summary>Página desejada, começando em 1.</summary>
    public int Pagina { get; set; } = 1;

    /// <summary>Quantidade de jogos por página.</summary>
    public int ItensPorPagina { get; set; } = 10;
}
