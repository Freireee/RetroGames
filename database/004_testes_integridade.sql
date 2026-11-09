-- =====================================================================
-- RetroGames · Aula 1 · Etapa 5 — Testes de integridade
--
-- Rode UM TESTE POR VEZ no Workbench (cursor no comando + Ctrl+Enter):
-- os testes 1 a 4 DEVEM dar erro, e o Workbench para o script no
-- primeiro erro se você rodar tudo de uma vez.
-- Rode antes o bloco "Preparação", que guarda o id de uma plataforma.
-- =====================================================================

-- Rode com o banco do RetroGames selecionado no Workbench.

-- Preparação: uma plataforma que já possui jogos
SET @co_plataforma = (SELECT co_seq_plataforma FROM tb_plataforma WHERE no_plataforma = 'Super Nintendo');

-- ---------------------------------------------------------------------
-- Teste 1 — Inserir jogo com co_plataforma inexistente
-- Esperado:  Erro 1452 (chave estrangeira)
-- Resultado: Error Code: 1452. Cannot add or update a child row: a foreign
--            key constraint fails (`retrogames`.`tb_jogo`, CONSTRAINT
--            `fk_jogo_plataforma` FOREIGN KEY (`co_plataforma`) REFERENCES
--            `tb_plataforma` (`co_seq_plataforma`))  → OK
-- ---------------------------------------------------------------------
INSERT INTO tb_jogo (no_jogo, co_plataforma, co_condicao_jogo, nu_ano_lancamento, vl_preco, qt_estoque, dt_cadastro)
VALUES ('TESTE plataforma inexistente', 99999, 2, 1990, 100.00, 1, UTC_TIMESTAMP());

-- ---------------------------------------------------------------------
-- Teste 2 — Inserir plataforma com nome já cadastrado
-- Esperado:  Erro 1062 (UNIQUE)
-- Resultado: Error Code: 1062. Duplicate entry 'Super Nintendo' for key
--            'tb_plataforma.uk_plataforma_no_plataforma'  → OK
-- ---------------------------------------------------------------------
INSERT INTO tb_plataforma (no_plataforma, no_fabricante, nu_ano_lancamento)
VALUES ('Super Nintendo', 'Nintendo', 1990);

-- ---------------------------------------------------------------------
-- Teste 3 — Excluir plataforma que possui jogos
-- Esperado:  Erro 1451 (chave estrangeira)
-- Resultado: Error Code: 1451. Cannot delete or update a parent row: a
--            foreign key constraint fails (`retrogames`.`tb_jogo`,
--            CONSTRAINT `fk_jogo_plataforma` FOREIGN KEY (`co_plataforma`)
--            REFERENCES `tb_plataforma` (`co_seq_plataforma`))  → OK
-- ---------------------------------------------------------------------
DELETE FROM tb_plataforma
WHERE co_seq_plataforma = @co_plataforma;

-- ---------------------------------------------------------------------
-- Teste 4 — Inserir jogo com no_jogo nulo
-- Esperado:  Erro 1048 (NOT NULL)
-- Resultado: Error Code: 1048. Column 'no_jogo' cannot be null  → OK
-- ---------------------------------------------------------------------
INSERT INTO tb_jogo (no_jogo, co_plataforma, co_condicao_jogo, nu_ano_lancamento, vl_preco, qt_estoque, dt_cadastro)
VALUES (NULL, @co_plataforma, 2, 1990, 100.00, 1, UTC_TIMESTAMP());

-- ---------------------------------------------------------------------
-- Teste 5 — Inserir jogo com vl_preco igual a 0
-- Esperado:  Aceito. O banco garante só a estrutura; a regra
--            "preço maior que zero" fica no Service (RN06).
-- Resultado: 1 row(s) affected  → OK (o banco aceitou)
-- ---------------------------------------------------------------------
INSERT INTO tb_jogo (no_jogo, co_plataforma, co_condicao_jogo, nu_ano_lancamento, vl_preco, qt_estoque, dt_cadastro)
VALUES ('TESTE preço zero', @co_plataforma, 2, 1990, 0.00, 1, UTC_TIMESTAMP());

-- Guarda o id gerado, para a limpeza abaixo (rode logo depois do teste 5)
SET @co_jogo_teste = LAST_INSERT_ID();

-- ---------------------------------------------------------------------
-- Limpeza: remove os dados inseridos pelos testes
-- (só o teste 5 gravou dados; a exclusão usa a chave primária, o que
-- funciona também com o "safe update mode" do Workbench)
-- ---------------------------------------------------------------------
DELETE FROM tb_jogo
WHERE co_seq_jogo = @co_jogo_teste;

-- Conferência: deve voltar 0 jogos de teste e o total de 32 jogos
SELECT COUNT(*) AS jogos_de_teste FROM tb_jogo WHERE no_jogo LIKE 'TESTE%';
SELECT COUNT(*) AS total_de_jogos FROM tb_jogo;
