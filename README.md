# RetroGames

Loja de jogos de consoles retrô — projeto integrador do curso **Desenvolvimento Web Full Stack com IA**.

Monolito em camadas, em um monorepo: front-end React (SPA), API ASP.NET Core e banco MySQL.

| Parte | Tecnologia |
| --- | --- |
| Back-end | .NET 10, ASP.NET Core Web API (controllers), ADO.NET com MySqlConnector |
| Banco | MySQL 8 |
| Front-end | React 19 + Vite, Bootstrap 5, React Router, Axios |
| Testes | xUnit v3 + Moq |

## Estrutura do repositório

```
RetroGames/
├── database/                     queries SQL do banco
├── RetroGames.Model/             entidades e constantes
├── RetroGames.Repository/        acesso a dados com ADO.NET
├── RetroGames.Services/          regras de negócio e ServiceModels
├── RetroGames.WebApi.ApiModels/  DTOs, envelope e ResponseCodes
├── RetroGames.WebApi/            controllers, validators e configuração
├── RetroGames.WebApi.UnitTests/  testes unitários
├── retrogames.web/               front-end React (Vite)
├── RetroGames.sln
├── AGENTS.md                     regras do projeto para o assistente de IA
└── .gitignore
```
