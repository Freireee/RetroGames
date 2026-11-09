namespace RetroGames.Model.Model;

/// <summary>Condição de um jogo à venda. Tabela: tb_condicao_jogo.</summary>
public class CondicaoJogo
{
    /// <summary>co_condicao_jogo (chave fixa; ver CondicaoJogoIds)</summary>
    public int Id { get; set; }

    /// <summary>ds_condicao_jogo</summary>
    public string Descricao { get; set; } = string.Empty;
}
