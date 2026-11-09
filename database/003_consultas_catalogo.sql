-- =====================================================================
-- RetroGames · Aula 1 · Etapa 5 — Consultas do catálogo
-- Rode depois de 001_criar_tabelas.sql e 002_dados_exemplo.sql.
-- O resultado esperado com os dados de exemplo está anotado em cada consulta.
-- =====================================================================

-- Rode com o banco do RetroGames selecionado no Workbench.

-- ---------------------------------------------------------------------
-- 1. Catálogo: jogos ativos com o nome da plataforma e a descrição da
--    condição, ordenados por nome
--    Esperado: 31 jogos (o E.T. está inativo e não aparece)
-- ---------------------------------------------------------------------
SELECT j.co_seq_jogo,
       j.no_jogo,
       p.no_plataforma,
       c.ds_condicao_jogo,
       j.nu_ano_lancamento,
       j.vl_preco,
       j.qt_estoque
FROM tb_jogo AS j
INNER JOIN tb_plataforma    AS p ON p.co_seq_plataforma = j.co_plataforma
INNER JOIN tb_condicao_jogo AS c ON c.co_condicao_jogo  = j.co_condicao_jogo
WHERE j.st_ativo = TRUE
ORDER BY j.no_jogo;

-- ---------------------------------------------------------------------
-- 2. Gêneros de um jogo informado
--    Esperado para Ocarina of Time: Ação, Aventura e RPG
-- ---------------------------------------------------------------------
SET @co_jogo = (SELECT co_seq_jogo FROM tb_jogo WHERE no_jogo = 'The Legend of Zelda: Ocarina of Time');

SELECT g.co_seq_genero,
       g.no_genero
FROM tb_jogo_genero AS jg
INNER JOIN tb_genero AS g ON g.co_seq_genero = jg.co_genero
WHERE jg.co_jogo = @co_jogo
ORDER BY g.no_genero;

-- ---------------------------------------------------------------------
-- 3. Jogos de um gênero informado
--    Esperado para RPG: Chrono Trigger, Final Fantasy VII, Pokémon Red e
--    The Legend of Zelda: Ocarina of Time
-- ---------------------------------------------------------------------
SET @co_genero = (SELECT co_seq_genero FROM tb_genero WHERE no_genero = 'RPG');

SELECT j.co_seq_jogo,
       j.no_jogo
FROM tb_jogo_genero AS jg
INNER JOIN tb_jogo AS j ON j.co_seq_jogo = jg.co_jogo
WHERE jg.co_genero = @co_genero
ORDER BY j.no_jogo;

-- ---------------------------------------------------------------------
-- 4. Quantidade de jogos por plataforma, incluindo as plataformas sem jogos
--    LEFT JOIN mantém a plataforma mesmo sem jogo; COUNT(coluna) ignora
--    o NULL e conta 0.
--    Esperado: Neo Geo aparece com 0
-- ---------------------------------------------------------------------
SELECT p.co_seq_plataforma,
       p.no_plataforma,
       COUNT(j.co_seq_jogo) AS qt_jogos
FROM tb_plataforma AS p
LEFT JOIN tb_jogo AS j ON j.co_plataforma = p.co_seq_plataforma
GROUP BY p.co_seq_plataforma, p.no_plataforma
ORDER BY p.no_plataforma;

-- ---------------------------------------------------------------------
-- 5. Busca por parte do nome do jogo, com 5 itens por página
--    OFFSET = (página - 1) * 5
--    Esperado para 'Super': total 8; página 1 com 5 jogos; página 2 com 3
-- ---------------------------------------------------------------------
SET @busca = 'Super';

-- Total encontrado
SELECT COUNT(*) AS total
FROM tb_jogo
WHERE no_jogo LIKE CONCAT('%', @busca, '%');

-- Página 1
SELECT co_seq_jogo, no_jogo
FROM tb_jogo
WHERE no_jogo LIKE CONCAT('%', @busca, '%')
ORDER BY no_jogo, co_seq_jogo
LIMIT 5 OFFSET 0;

-- Página 2
SELECT co_seq_jogo, no_jogo
FROM tb_jogo
WHERE no_jogo LIKE CONCAT('%', @busca, '%')
ORDER BY no_jogo, co_seq_jogo
LIMIT 5 OFFSET 5;
