namespace RetroGames.Repository.Interfaces;

/// <summary>
/// Conjunto de repositórios: um único objeto que dá acesso a todos eles.
/// O Service recebe só o IRepositorySet no construtor e usa, por exemplo,
/// <c>repositorio.Plataforma.ListarAsync()</c>. Nos testes, basta simular esta interface.
/// </summary>
public interface IRepositorySet
{
    IPlataformaRepository Plataforma { get; }

    IJogoRepository Jogo { get; }

    IJogoGeneroRepository JogoGenero { get; }

    IGeneroRepository Genero { get; }

    ICondicaoJogoRepository CondicaoJogo { get; }
}
