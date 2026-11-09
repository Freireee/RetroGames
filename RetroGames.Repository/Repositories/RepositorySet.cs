using RetroGames.Repository.Base;
using RetroGames.Repository.Interfaces;

namespace RetroGames.Repository.Repositories;

/// <summary>
/// Reúne os cinco repositórios num só objeto, todos com a mesma <see cref="RepositoryConfig"/>.
/// Tabela nova no sistema: cria-se o Repository dela e o conjunto ganha uma propriedade.
/// </summary>
public class RepositorySet(RepositoryConfig config) : IRepositorySet
{
    public IPlataformaRepository Plataforma { get; } = new PlataformaRepository(config);

    public IJogoRepository Jogo { get; } = new JogoRepository(config);

    public IJogoGeneroRepository JogoGenero { get; } = new JogoGeneroRepository(config);

    public IGeneroRepository Genero { get; } = new GeneroRepository(config);

    public ICondicaoJogoRepository CondicaoJogo { get; } = new CondicaoJogoRepository(config);
}
