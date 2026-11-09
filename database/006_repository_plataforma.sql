-- =====================================================================
-- RetroGames · Aula 2 · Etapa 3 — SQL do PlataformaRepository
-- Cada SQL foi executado aqui, com valores reais, antes de ir para o código.
-- As variáveis @... fazem o papel dos parâmetros do C#: o texto do SQL é
-- o mesmo do PlataformaRepository. Uma tabela por consulta, sem JOIN e
-- sem subconsulta (os SET de preparação não fazem parte do Repository).
-- =====================================================================

-- Rode com o banco do RetroGames selecionado no Workbench.

-- Listar: todas as plataformas, ordenadas por nome
SELECT co_seq_plataforma, no_plataforma, no_fabricante, nu_ano_lancamento
FROM tb_plataforma
ORDER BY no_plataforma;

-- Buscar por id
-- Esperado: Super Nintendo. Com um id inexistente (ex.: 9999), nenhuma
-- linha: o Repository devolve null.
SET @id = (SELECT co_seq_plataforma FROM tb_plataforma WHERE no_plataforma = 'Super Nintendo');

SELECT co_seq_plataforma, no_plataforma, no_fabricante, nu_ano_lancamento
FROM tb_plataforma
WHERE co_seq_plataforma = @id;

-- Existe com nome (o id a ignorar é opcional: na alteração, a própria
-- plataforma não conta como repetida)
-- Esperado: 1 com @id_ignorar = NULL; 0 ignorando a própria plataforma.
SET @nome = 'Super Nintendo';
SET @id_ignorar = NULL;

SELECT COUNT(*)
FROM tb_plataforma
WHERE no_plataforma = @nome
  AND (@id_ignorar IS NULL OR co_seq_plataforma <> @id_ignorar);

SET @id_ignorar = @id;

SELECT COUNT(*)
FROM tb_plataforma
WHERE no_plataforma = @nome
  AND (@id_ignorar IS NULL OR co_seq_plataforma <> @id_ignorar);

-- Possui jogos (consulta tb_jogo)
-- Esperado: 9 para o Super Nintendo; 0 para o Neo Geo.
SELECT COUNT(*)
FROM tb_jogo
WHERE co_plataforma = @id;

-- Inserir (o id gerado é o LAST_INSERT_ID; no C#, comando.LastInsertedId)
SET @nome = 'Sega Saturn';
SET @fabricante = 'Sega';
SET @ano_lancamento = 1994;

INSERT INTO tb_plataforma (no_plataforma, no_fabricante, nu_ano_lancamento)
VALUES (@nome, @fabricante, @ano_lancamento);

SET @id = LAST_INSERT_ID();
SELECT @id AS id_gerado;

-- Alterar: nome, fabricante e ano
SET @fabricante = 'Sega Enterprises';

UPDATE tb_plataforma
SET no_plataforma = @nome,
    no_fabricante = @fabricante,
    nu_ano_lancamento = @ano_lancamento
WHERE co_seq_plataforma = @id;

-- Excluir pelo id (remove também a plataforma de teste)
DELETE FROM tb_plataforma
WHERE co_seq_plataforma = @id;

-- Conferência: a plataforma de teste não existe mais (deve voltar 0)
SELECT COUNT(*) AS plataformas_de_teste FROM tb_plataforma WHERE no_plataforma = 'Sega Saturn';
