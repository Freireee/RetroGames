using RetroGames.Model.Model;
using RetroGames.Repository.Modelos;

namespace RetroGames.Repository.Interfaces;

/// <summary>Acesso a dados da tabela tb_jogo.</summary>
public interface IJogoRepository
{
    /// <summary>
    /// Os jogos de uma página e o total encontrado, com filtro opcional por parte do nome,
    /// plataforma e lista de ids. Inativos só quando <see cref="JogoFiltro.IncluirInativos"/>.
    /// </summary>
    Task<ResultadoPaginado<Jogo>> ListarAsync(JogoFiltro filtro);

    /// <summary>O jogo com o id informado, ou <c>null</c> se não existir.</summary>
    Task<Jogo?> BuscarPorIdAsync(int id);

    /// <summary>Grava um novo jogo e devolve o id gerado pelo banco.</summary>
    Task<int> InserirAsync(Jogo jogo);

    /// <summary>Atualiza os dados do jogo.</summary>
    Task AlterarAsync(Jogo jogo);

    /// <summary>Marca o jogo como inativo (st_ativo). Jogo nunca é apagado.</summary>
    Task DesativarAsync(int id);
}
