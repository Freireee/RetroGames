namespace RetroGames.Model.Model;

/// <summary>Perfil de acesso de um usuário. Tabela: tb_perfil.</summary>
public class Perfil
{
    /// <summary>co_perfil (chave fixa; ver PerfilIds)</summary>
    public int Id { get; set; }

    /// <summary>ds_perfil</summary>
    public string Descricao { get; set; } = string.Empty;
}
