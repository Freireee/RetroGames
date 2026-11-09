-- =====================================================================
-- RetroGames · Aula 2 · Etapa 5 — SQL do GeneroRepository e do
-- CondicaoJogoRepository (tabelas só lidas pelo sistema)
-- =====================================================================

-- Rode com o banco do RetroGames selecionado no Workbench.

-- GeneroRepository · Listar: gêneros ordenados por nome · esperado: 10 linhas
SELECT co_seq_genero, no_genero
FROM tb_genero
ORDER BY no_genero;

-- CondicaoJogoRepository · Listar: condições de jogo
-- Esperado: 1 Novo, 2 Usado, 3 Recondicionado
SELECT co_condicao_jogo, ds_condicao_jogo
FROM tb_condicao_jogo
ORDER BY co_condicao_jogo;
