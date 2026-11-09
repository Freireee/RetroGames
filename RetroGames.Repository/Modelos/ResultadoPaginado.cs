namespace RetroGames.Repository.Modelos;

/// <summary>Os itens de uma página e o total encontrado com o mesmo filtro.</summary>
public class ResultadoPaginado<T>
{
    /// <summary>Itens da página pedida.</summary>
    public List<T> Itens { get; set; } = [];

    /// <summary>Total de registros que atendem ao filtro (todas as páginas).</summary>
    public int Total { get; set; }
}
