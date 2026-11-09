namespace RetroGames.Repository.Base;

/// <summary>
/// Exceção própria do Repository: lançada quando o MySQL recusa um valor repetido
/// numa coluna UNIQUE (erro 1062). Quem decide o que isso significa para o negócio
/// (por exemplo, nome de plataforma duplicado) é o Service.
/// </summary>
public class RegistroDuplicadoException(string mensagem, Exception? excecaoInterna = null)
    : Exception(mensagem, excecaoInterna);
