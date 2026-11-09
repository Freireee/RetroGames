-- =====================================================================
-- RetroGames · Aula 2 · Etapa 4 — SQL do JogoRepository e do JogoGeneroRepository
-- Cada SQL foi executado aqui, com valores reais, antes de ir para o código.
-- As variáveis @... fazem o papel dos parâmetros do C#. Nenhuma consulta
-- usa JOIN: quem junta jogo, plataforma e gêneros é o Service.
--
-- Observação: no Workbench, LIMIT/OFFSET não aceitam variáveis, então os
-- testes usam números. No C#, o SQL usa LIMIT @limite OFFSET @deslocamento,
-- com OFFSET = (página - 1) * itens por página.
-- =====================================================================

-- Rode com o banco do RetroGames selecionado no Workbench.

-- =====================================================================
-- JogoRepository · Listar (total + página, com o MESMO filtro)
-- O C# só inclui no WHERE os filtros informados. Por padrão, só ativos.
-- =====================================================================

-- Sem filtro (só ativos) · página 1 de 5 itens · esperado: total 31
SELECT COUNT(*)
FROM tb_jogo
WHERE st_ativo = TRUE;

SELECT co_seq_jogo, no_jogo, ds_jogo, co_plataforma, co_condicao_jogo,
       nu_ano_lancamento, vl_preco, qt_estoque, st_ativo, dt_cadastro
FROM tb_jogo
WHERE st_ativo = TRUE
ORDER BY no_jogo, co_seq_jogo
LIMIT 5 OFFSET 0;

-- Sem filtro · segunda página (OFFSET 5)
SELECT co_seq_jogo, no_jogo, ds_jogo, co_plataforma, co_condicao_jogo,
       nu_ano_lancamento, vl_preco, qt_estoque, st_ativo, dt_cadastro
FROM tb_jogo
WHERE st_ativo = TRUE
ORDER BY no_jogo, co_seq_jogo
LIMIT 5 OFFSET 5;

-- Filtro por parte do nome · esperado: total 6 para 'Mario'; 2ª página com 1
SET @nome = 'Mario';

SELECT COUNT(*)
FROM tb_jogo
WHERE st_ativo = TRUE AND no_jogo LIKE CONCAT('%', @nome, '%');

SELECT co_seq_jogo, no_jogo, ds_jogo, co_plataforma, co_condicao_jogo,
       nu_ano_lancamento, vl_preco, qt_estoque, st_ativo, dt_cadastro
FROM tb_jogo
WHERE st_ativo = TRUE AND no_jogo LIKE CONCAT('%', @nome, '%')
ORDER BY no_jogo, co_seq_jogo
LIMIT 5 OFFSET 5;

-- Filtro por plataforma · esperado: total 9 para o Super Nintendo
SET @id_plataforma = (SELECT co_seq_plataforma FROM tb_plataforma WHERE no_plataforma = 'Super Nintendo');

SELECT COUNT(*)
FROM tb_jogo
WHERE st_ativo = TRUE AND co_plataforma = @id_plataforma;

SELECT co_seq_jogo, no_jogo, ds_jogo, co_plataforma, co_condicao_jogo,
       nu_ano_lancamento, vl_preco, qt_estoque, st_ativo, dt_cadastro
FROM tb_jogo
WHERE st_ativo = TRUE AND co_plataforma = @id_plataforma
ORDER BY no_jogo, co_seq_jogo
LIMIT 5 OFFSET 0;

-- Filtro por lista de ids (um parâmetro por id: @id0, @id1, ...)
-- Esperado: os 3 jogos informados
SET @id0 = 4, @id1 = 16, @id2 = 29;

SELECT COUNT(*)
FROM tb_jogo
WHERE st_ativo = TRUE AND co_seq_jogo IN (@id0, @id1, @id2);

SELECT co_seq_jogo, no_jogo, ds_jogo, co_plataforma, co_condicao_jogo,
       nu_ano_lancamento, vl_preco, qt_estoque, st_ativo, dt_cadastro
FROM tb_jogo
WHERE st_ativo = TRUE AND co_seq_jogo IN (@id0, @id1, @id2)
ORDER BY no_jogo, co_seq_jogo
LIMIT 5 OFFSET 0;

-- Todos os filtros juntos · esperado: Super Mario Kart e Super Mario World
SELECT co_seq_jogo, no_jogo, ds_jogo, co_plataforma, co_condicao_jogo,
       nu_ano_lancamento, vl_preco, qt_estoque, st_ativo, dt_cadastro
FROM tb_jogo
WHERE st_ativo = TRUE
  AND no_jogo LIKE CONCAT('%', @nome, '%')
  AND co_plataforma = @id_plataforma
ORDER BY no_jogo, co_seq_jogo
LIMIT 5 OFFSET 0;

-- Incluindo inativos (sem a condição de st_ativo) · esperado: total 32
SELECT COUNT(*)
FROM tb_jogo;

-- =====================================================================
-- JogoRepository · Buscar por id (sem linha → o Repository devolve null)
-- =====================================================================
SET @id = 23;

SELECT co_seq_jogo, no_jogo, ds_jogo, co_plataforma, co_condicao_jogo,
       nu_ano_lancamento, vl_preco, qt_estoque, st_ativo, dt_cadastro
FROM tb_jogo
WHERE co_seq_jogo = @id;

-- =====================================================================
-- JogoRepository · Inserir, Alterar e Desativar (jogo de teste)
-- =====================================================================
SET @nome = 'TESTE Repository';
SET @descricao = NULL;
SET @id_condicao_jogo = 2;
SET @ano_lancamento = 1993;
SET @preco = 99.90;
SET @estoque = 3;
SET @ativo = TRUE;
SET @data_cadastro = UTC_TIMESTAMP();

INSERT INTO tb_jogo (no_jogo, ds_jogo, co_plataforma, co_condicao_jogo, nu_ano_lancamento,
                     vl_preco, qt_estoque, st_ativo, dt_cadastro)
VALUES (@nome, @descricao, @id_plataforma, @id_condicao_jogo, @ano_lancamento,
        @preco, @estoque, @ativo, @data_cadastro);

SET @id = LAST_INSERT_ID();   -- no C#: comando.LastInsertedId

-- Alterar: atualiza os dados do jogo
SET @preco = 89.90;
SET @descricao = 'Jogo criado pelo teste do Repository.';

UPDATE tb_jogo
SET no_jogo = @nome,
    ds_jogo = @descricao,
    co_plataforma = @id_plataforma,
    co_condicao_jogo = @id_condicao_jogo,
    nu_ano_lancamento = @ano_lancamento,
    vl_preco = @preco,
    qt_estoque = @estoque,
    st_ativo = @ativo
WHERE co_seq_jogo = @id;

-- Desativar: jogo nunca é apagado, só marcado como inativo
UPDATE tb_jogo
SET st_ativo = FALSE
WHERE co_seq_jogo = @id;

SELECT co_seq_jogo, no_jogo, vl_preco, st_ativo FROM tb_jogo WHERE co_seq_jogo = @id;

-- =====================================================================
-- JogoGeneroRepository
-- =====================================================================

-- Listar todos os vínculos · esperado: 49 linhas
SELECT co_jogo, co_genero
FROM tb_jogo_genero
ORDER BY co_jogo, co_genero;

-- Listar por jogos: os vínculos de uma lista de jogos, numa única consulta
SET @id0 = 32, @id1 = 9;

SELECT co_jogo, co_genero
FROM tb_jogo_genero
WHERE co_jogo IN (@id0, @id1)
ORDER BY co_jogo, co_genero;

-- Inserir: grava os vínculos de um jogo com os seus gêneros (uma linha por gênero)
SET @id_jogo = @id;
SET @id_genero0 = (SELECT co_seq_genero FROM tb_genero WHERE no_genero = 'Ação');
SET @id_genero1 = (SELECT co_seq_genero FROM tb_genero WHERE no_genero = 'Aventura');

INSERT INTO tb_jogo_genero (co_jogo, co_genero)
VALUES (@id_jogo, @id_genero0),
       (@id_jogo, @id_genero1);

SELECT co_jogo, co_genero FROM tb_jogo_genero WHERE co_jogo = @id_jogo;

-- Remover por jogo: apaga os vínculos do jogo, para regravá-los na alteração
DELETE FROM tb_jogo_genero
WHERE co_jogo = @id_jogo;

-- ---------------------------------------------------------------------
-- Limpeza do teste (não é método do Repository: jogo nunca é apagado
-- pelo sistema; aqui só removemos o jogo criado por este script)
-- ---------------------------------------------------------------------
DELETE FROM tb_jogo
WHERE co_seq_jogo = @id;

SELECT COUNT(*) AS jogos_de_teste FROM tb_jogo WHERE no_jogo LIKE 'TESTE%';
