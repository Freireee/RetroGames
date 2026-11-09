using RetroGames.Model.Model;

namespace RetroGames.Repository.Interfaces;

/// <summary>Acesso a dados da tabela tb_genero (somente leitura).</summary>
public interface IGeneroRepository
{
    /// <summary>Os gêneros, ordenados por nome.</summary>
    Task<List<Genero>> ListarAsync();
}
