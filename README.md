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

## Como rodar localmente

1. **Banco** — no MySQL Workbench, selecione o banco do RetroGames (na sua máquina, crie-o uma vez com
   `CREATE DATABASE retrogames;`; no laboratório, use o seu banco `db` + matrícula) e execute as queries
   da pasta `database/` na ordem: `001_criar_tabelas.sql` e depois `002_dados_exemplo.sql`.
   Os demais arquivos são consultas e testes: `003_consultas_catalogo.sql`, `004_testes_integridade.sql`
   (rode um teste por vez) e os SQL de cada Repository.
2. **Connection string** — na raiz, copie `.env.example` para `.env` e troque `SUA_SENHA` pela sua senha
   do MySQL. O `.env` está no `.gitignore` e nunca vai para o GitHub. Para conferir servidor, porta e
   usuário, rode `database/005_conexao.sql`.
3. **Back-end** — `dotnet build` na raiz compila a solução.
4. **Front-end** — `cd retrogames.web && npm install && npm run dev` abre em http://localhost:5173.
