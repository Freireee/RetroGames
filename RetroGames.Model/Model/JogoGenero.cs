namespace RetroGames.Model.Model;

/// <summary>Vínculo entre um jogo e um gênero (relação M:N). Tabela: tb_jogo_genero.</summary>
public class JogoGenero
{
    /// <summary>co_jogo (FK para tb_jogo)</summary>
    public int IdJogo { get; set; }

    /// <summary>co_genero (FK para tb_genero)</summary>
    public int IdGenero { get; set; }
}
