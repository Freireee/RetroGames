using RetroGames.Model.Model;

namespace RetroGames.Repository.Interfaces;

/// <summary>Acesso a dados da tabela tb_condicao_jogo (somente leitura).</summary>
public interface ICondicaoJogoRepository
{
    /// <summary>As condições de jogo (Novo, Usado, Recondicionado), pela chave.</summary>
    Task<List<CondicaoJogo>> ListarAsync();
}
