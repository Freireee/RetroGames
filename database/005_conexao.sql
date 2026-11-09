-- =====================================================================
-- RetroGames · Aula 2 · Etapa 2 — Dados para montar a connection string
-- No Workbench, com o banco do RetroGames selecionado, execute e anote:
-- =====================================================================

SELECT @@hostname     AS servidor,
       @@port         AS porta,
       CURRENT_USER() AS usuario,
       DATABASE()     AS banco;

-- Como montar a connection string a partir do resultado:
--   servidor → localhost, se o MySQL está na sua máquina
--              (no laboratório, o servidor Turing: 192.168.1.254)
--   porta    → o valor de "porta" (normalmente 3306)
--   usuário  → só a parte antes do @ (ex.: root@localhost → root)
--   banco    → o valor de "banco" (retrogames na sua máquina;
--              db + matrícula no laboratório)
--   senha    → a mesma que você usa para entrar no Workbench
--
-- Na sua máquina, o resultado fica assim:
--   server=localhost;port=3306;database=retrogames;user=root;password=SUA_SENHA
--
-- Ela vai no arquivo .env, na raiz do repositório (fora do Git):
--   ConnectionStrings__Default="server=localhost;port=3306;database=retrogames;user=root;password=SUA_SENHA"
