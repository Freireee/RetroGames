-- =====================================================================
-- RetroGames · Aula 1 · Etapa 3 — Criação das tabelas
-- Estrutura conforme o modelo relacional da especificação (Espec. 4.1 a 4.3).
-- Banco: MySQL 8 · execute no MySQL Workbench (Ctrl+Shift+Enter)
--
-- ANTES DE RODAR, selecione o banco do RetroGames no Workbench
-- (duplo clique no schema, ou "Default Schema" da conexão):
--   • Na sua máquina: crie o banco uma vez e selecione-o:
--       CREATE DATABASE retrogames CHARACTER SET utf8mb4;
--   • No laboratório (servidor Turing): use o seu banco db + matrícula
--     (ex.: db2099108001); lá não é possível criar outro banco.
--
-- Para recriar tudo, apague as tabelas (ou o banco, na sua máquina) e
-- rode o script de novo. Ordem: 001_criar_tabelas.sql → 002_dados_exemplo.sql
--
-- Convenção de nomes (Espec. 4.1):
--   tb_  tabela                     co_seq_  chave primária gerada pelo banco
--   co_  chave de tabela de tipo    no_ / ds_  nome / descrição
--        ou chave estrangeira       nu_ / qt_ / vl_  número / quantidade / valor
--   dt_  data e hora em UTC         st_  booleano (situação)
--
-- O banco garante só a estrutura (chaves, tipos, NOT NULL e UNIQUE).
-- Regras de negócio ficam no Service: sem CHECK, triggers, functions
-- ou ações referenciais (ON DELETE/ON UPDATE).
-- =====================================================================

-- =====================================================================
-- Catálogo e Administração (aulas)
-- =====================================================================

-- Tabelas de tipo: só ID e descrição. Chave fixa, sem AUTO_INCREMENT.

CREATE TABLE tb_condicao_jogo (
    co_condicao_jogo  INT          NOT NULL,
    ds_condicao_jogo  VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_condicao_jogo PRIMARY KEY (co_condicao_jogo),
    CONSTRAINT uk_condicao_jogo_ds_condicao_jogo UNIQUE (ds_condicao_jogo)
) ENGINE = InnoDB;

CREATE TABLE tb_perfil (
    co_perfil  INT          NOT NULL,
    ds_perfil  VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_perfil PRIMARY KEY (co_perfil),
    CONSTRAINT uk_perfil_ds_perfil UNIQUE (ds_perfil)
) ENGINE = InnoDB;

-- Cadastros

CREATE TABLE tb_plataforma (
    co_seq_plataforma  INT          NOT NULL AUTO_INCREMENT,
    no_plataforma      VARCHAR(80)  NOT NULL,
    no_fabricante      VARCHAR(80)  NOT NULL,
    nu_ano_lancamento  INT          NOT NULL,
    CONSTRAINT pk_plataforma PRIMARY KEY (co_seq_plataforma),
    CONSTRAINT uk_plataforma_no_plataforma UNIQUE (no_plataforma)
) ENGINE = InnoDB;

CREATE TABLE tb_genero (
    co_seq_genero  INT          NOT NULL AUTO_INCREMENT,
    no_genero      VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_genero PRIMARY KEY (co_seq_genero),
    CONSTRAINT uk_genero_no_genero UNIQUE (no_genero)
) ENGINE = InnoDB;

CREATE TABLE tb_jogo (
    co_seq_jogo        INT            NOT NULL AUTO_INCREMENT,
    no_jogo            VARCHAR(150)   NOT NULL,
    ds_jogo            VARCHAR(1000)  NULL,
    nu_ano_lancamento  INT            NOT NULL,
    vl_preco           DECIMAL(10,2)  NOT NULL,
    qt_estoque         INT            NOT NULL,
    st_ativo           BOOLEAN        NOT NULL DEFAULT TRUE,
    dt_cadastro        DATETIME       NOT NULL,
    co_plataforma      INT            NOT NULL,
    co_condicao_jogo   INT            NOT NULL,
    CONSTRAINT pk_jogo PRIMARY KEY (co_seq_jogo),
    CONSTRAINT fk_jogo_plataforma FOREIGN KEY (co_plataforma)
        REFERENCES tb_plataforma (co_seq_plataforma),
    CONSTRAINT fk_jogo_condicao_jogo FOREIGN KEY (co_condicao_jogo)
        REFERENCES tb_condicao_jogo (co_condicao_jogo),
    INDEX ix_jogo_no_jogo (no_jogo)
) ENGINE = InnoDB;

-- Associativa N:N entre jogo e gênero: chave primária composta e duas FKs
CREATE TABLE tb_jogo_genero (
    co_jogo    INT  NOT NULL,
    co_genero  INT  NOT NULL,
    CONSTRAINT pk_jogo_genero PRIMARY KEY (co_jogo, co_genero),
    CONSTRAINT fk_jogo_genero_jogo FOREIGN KEY (co_jogo)
        REFERENCES tb_jogo (co_seq_jogo),
    CONSTRAINT fk_jogo_genero_genero FOREIGN KEY (co_genero)
        REFERENCES tb_genero (co_seq_genero)
) ENGINE = InnoDB;

CREATE TABLE tb_usuario (
    co_seq_usuario  INT           NOT NULL AUTO_INCREMENT,
    no_usuario      VARCHAR(100)  NOT NULL,
    ds_email        VARCHAR(256)  NOT NULL,
    ds_senha_hash   VARCHAR(500)  NOT NULL,
    st_ativo        BOOLEAN       NOT NULL DEFAULT TRUE,
    dt_cadastro     DATETIME      NOT NULL,
    co_perfil       INT           NOT NULL,
    CONSTRAINT pk_usuario PRIMARY KEY (co_seq_usuario),
    CONSTRAINT uk_usuario_ds_email UNIQUE (ds_email),
    CONSTRAINT fk_usuario_perfil FOREIGN KEY (co_perfil)
        REFERENCES tb_perfil (co_perfil)
) ENGINE = InnoDB;

-- =====================================================================
-- Compras (tarefa)
-- Tabelas do modelo usadas na tarefa de compras; os dados delas entram
-- junto com a tarefa.
-- =====================================================================

-- Tabela de tipo: chave fixa, sem AUTO_INCREMENT
CREATE TABLE tb_situacao_pedido (
    co_situacao_pedido  INT          NOT NULL,
    ds_situacao_pedido  VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_situacao_pedido PRIMARY KEY (co_situacao_pedido),
    CONSTRAINT uk_situacao_pedido_ds_situacao_pedido UNIQUE (ds_situacao_pedido)
) ENGINE = InnoDB;

CREATE TABLE tb_pedido (
    co_seq_pedido       INT            NOT NULL AUTO_INCREMENT,
    dt_pedido           DATETIME       NOT NULL,
    vl_total            DECIMAL(10,2)  NOT NULL,
    co_usuario          INT            NOT NULL,
    co_situacao_pedido  INT            NOT NULL,
    CONSTRAINT pk_pedido PRIMARY KEY (co_seq_pedido),
    CONSTRAINT fk_pedido_usuario FOREIGN KEY (co_usuario)
        REFERENCES tb_usuario (co_seq_usuario),
    CONSTRAINT fk_pedido_situacao_pedido FOREIGN KEY (co_situacao_pedido)
        REFERENCES tb_situacao_pedido (co_situacao_pedido)
) ENGINE = InnoDB;

-- Um jogo aparece no máximo uma vez em cada pedido: UNIQUE (co_pedido, co_jogo)
CREATE TABLE tb_item_pedido (
    co_seq_item_pedido  INT            NOT NULL AUTO_INCREMENT,
    qt_item             INT            NOT NULL,
    vl_unitario         DECIMAL(10,2)  NOT NULL,
    co_pedido           INT            NOT NULL,
    co_jogo             INT            NOT NULL,
    CONSTRAINT pk_item_pedido PRIMARY KEY (co_seq_item_pedido),
    CONSTRAINT uk_item_pedido_pedido_jogo UNIQUE (co_pedido, co_jogo),
    CONSTRAINT fk_item_pedido_pedido FOREIGN KEY (co_pedido)
        REFERENCES tb_pedido (co_seq_pedido),
    CONSTRAINT fk_item_pedido_jogo FOREIGN KEY (co_jogo)
        REFERENCES tb_jogo (co_seq_jogo)
) ENGINE = InnoDB;

-- =====================================================================
-- Conferência
-- =====================================================================
SHOW TABLES;
DESCRIBE tb_jogo;
