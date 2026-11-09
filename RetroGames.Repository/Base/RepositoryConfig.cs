namespace RetroGames.Repository.Base;

/// <summary>
/// Guarda a connection string do banco. Só isso: o valor vem do arquivo .env,
/// lido pela API na aula 4, e chega aos repositórios por esta classe.
/// </summary>
public class RepositoryConfig
{
    /// <summary>Ex.: server=localhost;port=3306;database=retrogames;user=root;password=SUA_SENHA</summary>
    public string ConnectionString { get; set; } = string.Empty;
}
