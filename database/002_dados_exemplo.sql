-- =====================================================================
-- RetroGames · Aula 1 · Etapa 4 — Dados de exemplo
-- Execute logo depois de 001_criar_tabelas.sql, num banco recém-criado.
--
-- Usuários NÃO são inseridos aqui: o administrador será criado pela API,
-- na aula de autenticação.
-- =====================================================================

-- Rode com o banco do RetroGames selecionado no Workbench.

-- ---------------------------------------------------------------------
-- Tabelas de tipo (chaves fixas = constantes CondicaoJogoIds e PerfilIds)
-- ---------------------------------------------------------------------

INSERT INTO tb_condicao_jogo (co_condicao_jogo, ds_condicao_jogo) VALUES
    (1, 'Novo'),
    (2, 'Usado'),
    (3, 'Recondicionado');

INSERT INTO tb_perfil (co_perfil, ds_perfil) VALUES
    (1, 'Administrador'),
    (2, 'Cliente');

-- ---------------------------------------------------------------------
-- Plataformas (o Neo Geo fica sem jogos de propósito: ele deve aparecer
-- com 0 na contagem de jogos por plataforma)
-- ---------------------------------------------------------------------

INSERT INTO tb_plataforma (no_plataforma, no_fabricante, nu_ano_lancamento) VALUES
    ('Atari 2600',                    'Atari',    1977),
    ('Nintendo Entertainment System', 'Nintendo', 1985),
    ('Master System',                 'Sega',     1986),
    ('Mega Drive',                    'Sega',     1988),
    ('Game Boy',                      'Nintendo', 1989),
    ('Super Nintendo',                'Nintendo', 1990),
    ('Neo Geo',                       'SNK',      1990),
    ('PlayStation',                   'Sony',     1994),
    ('Nintendo 64',                   'Nintendo', 1996);

-- ---------------------------------------------------------------------
-- Gêneros
-- ---------------------------------------------------------------------

INSERT INTO tb_genero (no_genero) VALUES
    ('Ação'),
    ('Aventura'),
    ('Corrida'),
    ('Esporte'),
    ('Estratégia'),
    ('Luta'),
    ('Plataforma'),
    ('Puzzle'),
    ('RPG'),
    ('Tiro');

-- ---------------------------------------------------------------------
-- Jogos
-- Condição: 1 = Novo, 2 = Usado, 3 = Recondicionado
-- E.T. the Extra-Terrestrial está inativo e Chrono Trigger está sem estoque.
-- ---------------------------------------------------------------------

SET @atari  = (SELECT co_seq_plataforma FROM tb_plataforma WHERE no_plataforma = 'Atari 2600');
SET @nes    = (SELECT co_seq_plataforma FROM tb_plataforma WHERE no_plataforma = 'Nintendo Entertainment System');
SET @master = (SELECT co_seq_plataforma FROM tb_plataforma WHERE no_plataforma = 'Master System');
SET @mega   = (SELECT co_seq_plataforma FROM tb_plataforma WHERE no_plataforma = 'Mega Drive');
SET @gb     = (SELECT co_seq_plataforma FROM tb_plataforma WHERE no_plataforma = 'Game Boy');
SET @snes   = (SELECT co_seq_plataforma FROM tb_plataforma WHERE no_plataforma = 'Super Nintendo');
SET @ps1    = (SELECT co_seq_plataforma FROM tb_plataforma WHERE no_plataforma = 'PlayStation');
SET @n64    = (SELECT co_seq_plataforma FROM tb_plataforma WHERE no_plataforma = 'Nintendo 64');

INSERT INTO tb_jogo
    (no_jogo, ds_jogo, co_plataforma, co_condicao_jogo, nu_ano_lancamento, vl_preco, qt_estoque, st_ativo, dt_cadastro)
VALUES
    ('Pitfall!', 'Pitfall Harry atravessa a selva desviando de crocodilos, cobras e areia movediça.', @atari, 2, 1982, 89.90, 4, TRUE, UTC_TIMESTAMP()),
    ('River Raid', 'Pilote um caça sobre um rio, destrua os inimigos e não deixe o combustível acabar.', @atari, 2, 1982, 79.90, 5, TRUE, UTC_TIMESTAMP()),
    ('E.T. the Extra-Terrestrial', 'Ajude o E.T. a encontrar as peças do telefone para voltar para casa.', @atari, 2, 1982, 59.90, 2, FALSE, UTC_TIMESTAMP()),
    ('Super Mario Bros.', 'Mario atravessa o Reino do Cogumelo para resgatar a princesa Peach.', @nes, 2, 1985, 199.90, 6, TRUE, UTC_TIMESTAMP()),
    ('The Legend of Zelda', 'Link explora Hyrule em busca dos fragmentos da Triforce da Sabedoria.', @nes, 2, 1986, 229.90, 3, TRUE, UTC_TIMESTAMP()),
    ('Mega Man 2', NULL, @nes, 3, 1988, 179.90, 4, TRUE, UTC_TIMESTAMP()),
    ('Super Mario Bros. 3', 'Mario e Luigi enfrentam os Koopalings em oito mundos temáticos.', @nes, 2, 1988, 249.90, 3, TRUE, UTC_TIMESTAMP()),
    ('Alex Kidd in Miracle World', 'Alex Kidd salva o reino de Radaxian com socos e partidas de jokenpô.', @master, 2, 1986, 119.90, 5, TRUE, UTC_TIMESTAMP()),
    ('Wonder Boy III: The Dragon''s Trap', NULL, @master, 3, 1989, 149.90, 2, TRUE, UTC_TIMESTAMP()),
    ('Sonic the Hedgehog', 'Sonic corre em alta velocidade para impedir os planos do Dr. Robotnik.', @mega, 2, 1991, 129.90, 8, TRUE, UTC_TIMESTAMP()),
    ('Streets of Rage 2', 'Axel, Blaze, Max e Skate enfrentam o sindicato do crime pelas ruas da cidade.', @mega, 3, 1992, 189.90, 2, TRUE, UTC_TIMESTAMP()),
    ('Mortal Kombat', NULL, @mega, 2, 1993, 159.90, 3, TRUE, UTC_TIMESTAMP()),
    ('Herzog Zwei', 'Estratégia em tempo real: comande as tropas e conquiste as bases inimigas.', @mega, 2, 1989, 139.90, 1, TRUE, UTC_TIMESTAMP()),
    ('Tetris', 'Encaixe as peças que caem e complete linhas para marcar pontos.', @gb, 2, 1989, 89.90, 10, TRUE, UTC_TIMESTAMP()),
    ('Pokémon Red', 'Capture, treine e batalhe com Pokémon para se tornar o campeão da Liga.', @gb, 2, 1996, 299.90, 2, TRUE, UTC_TIMESTAMP()),
    ('Super Mario World', 'Mario e Yoshi exploram a Dinosaur Land para derrotar Bowser.', @snes, 2, 1990, 259.90, 6, TRUE, UTC_TIMESTAMP()),
    ('Super Castlevania IV', NULL, @snes, 2, 1991, 279.90, 2, TRUE, UTC_TIMESTAMP()),
    ('The Legend of Zelda: A Link to the Past', 'Link viaja entre o Mundo da Luz e o Mundo das Trevas para deter Agahnim.', @snes, 3, 1991, 299.90, 2, TRUE, UTC_TIMESTAMP()),
    ('Street Fighter II', 'O clássico de luta com Ryu, Ken, Chun-Li e lutadores do mundo todo.', @snes, 2, 1992, 149.90, 7, TRUE, UTC_TIMESTAMP()),
    ('Super Mario Kart', 'Corridas de kart com Mario e seus amigos, com itens e modo batalha.', @snes, 1, 1992, 499.90, 1, TRUE, UTC_TIMESTAMP()),
    ('Super Metroid', 'Samus Aran explora o planeta Zebes para recuperar o último Metroid.', @snes, 2, 1994, 349.90, 1, TRUE, UTC_TIMESTAMP()),
    ('Donkey Kong Country', NULL, @snes, 3, 1994, 219.90, 3, TRUE, UTC_TIMESTAMP()),
    ('Chrono Trigger', 'Uma viagem no tempo para impedir que Lavos destrua o mundo.', @snes, 2, 1995, 899.90, 0, TRUE, UTC_TIMESTAMP()),
    ('International Superstar Soccer Deluxe', 'Futebol com seleções do mundo todo, clássico das locadoras.', @snes, 2, 1995, 129.90, 4, TRUE, UTC_TIMESTAMP()),
    ('Crash Bandicoot', 'Crash enfrenta o Dr. Neo Cortex nas ilhas Wumpa.', @ps1, 2, 1996, 149.90, 5, TRUE, UTC_TIMESTAMP()),
    ('Final Fantasy VII', 'Cloud e o grupo AVALANCHE enfrentam a Shinra e Sephiroth.', @ps1, 2, 1997, 249.90, 4, TRUE, UTC_TIMESTAMP()),
    ('Gran Turismo', NULL, @ps1, 2, 1997, 99.90, 6, TRUE, UTC_TIMESTAMP()),
    ('Metal Gear Solid', 'Solid Snake se infiltra em Shadow Moses para impedir um ataque nuclear.', @ps1, 2, 1998, 219.90, 3, TRUE, UTC_TIMESTAMP()),
    ('Super Mario 64', 'Mario explora o castelo da princesa Peach num mundo totalmente 3D.', @n64, 2, 1996, 329.90, 4, TRUE, UTC_TIMESTAMP()),
    ('Mario Kart 64', NULL, @n64, 2, 1996, 289.90, 5, TRUE, UTC_TIMESTAMP()),
    ('GoldenEye 007', 'Como James Bond, cumpra missões de espionagem baseadas no filme.', @n64, 2, 1997, 199.90, 2, TRUE, UTC_TIMESTAMP()),
    ('The Legend of Zelda: Ocarina of Time', 'Link viaja no tempo para impedir que Ganondorf domine Hyrule.', @n64, 1, 1998, 599.90, 1, TRUE, UTC_TIMESTAMP());

-- ---------------------------------------------------------------------
-- Gêneros de cada jogo (1 a 3 por jogo), ligados pelo nome
-- ---------------------------------------------------------------------

INSERT INTO tb_jogo_genero (co_jogo, co_genero)
SELECT j.co_seq_jogo, g.co_seq_genero
FROM (
              SELECT 'Pitfall!' AS no_jogo, 'Aventura' AS no_genero
    UNION ALL SELECT 'Pitfall!', 'Plataforma'
    UNION ALL SELECT 'River Raid', 'Tiro'
    UNION ALL SELECT 'E.T. the Extra-Terrestrial', 'Aventura'
    UNION ALL SELECT 'Super Mario Bros.', 'Plataforma'
    UNION ALL SELECT 'The Legend of Zelda', 'Ação'
    UNION ALL SELECT 'The Legend of Zelda', 'Aventura'
    UNION ALL SELECT 'Mega Man 2', 'Ação'
    UNION ALL SELECT 'Mega Man 2', 'Plataforma'
    UNION ALL SELECT 'Super Mario Bros. 3', 'Plataforma'
    UNION ALL SELECT 'Alex Kidd in Miracle World', 'Aventura'
    UNION ALL SELECT 'Alex Kidd in Miracle World', 'Plataforma'
    UNION ALL SELECT 'Wonder Boy III: The Dragon''s Trap', 'Ação'
    UNION ALL SELECT 'Wonder Boy III: The Dragon''s Trap', 'Aventura'
    UNION ALL SELECT 'Wonder Boy III: The Dragon''s Trap', 'Plataforma'
    UNION ALL SELECT 'Sonic the Hedgehog', 'Plataforma'
    UNION ALL SELECT 'Streets of Rage 2', 'Ação'
    UNION ALL SELECT 'Streets of Rage 2', 'Luta'
    UNION ALL SELECT 'Mortal Kombat', 'Luta'
    UNION ALL SELECT 'Herzog Zwei', 'Estratégia'
    UNION ALL SELECT 'Herzog Zwei', 'Ação'
    UNION ALL SELECT 'Tetris', 'Puzzle'
    UNION ALL SELECT 'Pokémon Red', 'RPG'
    UNION ALL SELECT 'Super Mario World', 'Plataforma'
    UNION ALL SELECT 'Super Castlevania IV', 'Ação'
    UNION ALL SELECT 'Super Castlevania IV', 'Plataforma'
    UNION ALL SELECT 'The Legend of Zelda: A Link to the Past', 'Ação'
    UNION ALL SELECT 'The Legend of Zelda: A Link to the Past', 'Aventura'
    UNION ALL SELECT 'Street Fighter II', 'Luta'
    UNION ALL SELECT 'Super Mario Kart', 'Corrida'
    UNION ALL SELECT 'Super Metroid', 'Ação'
    UNION ALL SELECT 'Super Metroid', 'Aventura'
    UNION ALL SELECT 'Donkey Kong Country', 'Plataforma'
    UNION ALL SELECT 'Chrono Trigger', 'RPG'
    UNION ALL SELECT 'International Superstar Soccer Deluxe', 'Esporte'
    UNION ALL SELECT 'Crash Bandicoot', 'Plataforma'
    UNION ALL SELECT 'Final Fantasy VII', 'RPG'
    UNION ALL SELECT 'Gran Turismo', 'Corrida'
    UNION ALL SELECT 'Gran Turismo', 'Esporte'
    UNION ALL SELECT 'Metal Gear Solid', 'Ação'
    UNION ALL SELECT 'Metal Gear Solid', 'Aventura'
    UNION ALL SELECT 'Super Mario 64', 'Aventura'
    UNION ALL SELECT 'Super Mario 64', 'Plataforma'
    UNION ALL SELECT 'Mario Kart 64', 'Corrida'
    UNION ALL SELECT 'GoldenEye 007', 'Ação'
    UNION ALL SELECT 'GoldenEye 007', 'Tiro'
    UNION ALL SELECT 'The Legend of Zelda: Ocarina of Time', 'Ação'
    UNION ALL SELECT 'The Legend of Zelda: Ocarina of Time', 'Aventura'
    UNION ALL SELECT 'The Legend of Zelda: Ocarina of Time', 'RPG'
) AS v
INNER JOIN tb_jogo   AS j ON j.no_jogo   = v.no_jogo
INNER JOIN tb_genero AS g ON g.no_genero = v.no_genero;

-- ---------------------------------------------------------------------
-- Conferência (Etapa 4)
-- ---------------------------------------------------------------------

-- Pelo menos 6 plataformas, 8 gêneros e 20 jogos; nenhum usuário
SELECT 'plataformas' AS tabela, COUNT(*) AS total FROM tb_plataforma
UNION ALL SELECT 'gêneros', COUNT(*) FROM tb_genero
UNION ALL SELECT 'jogos', COUNT(*) FROM tb_jogo
UNION ALL SELECT 'vínculos jogo-gênero', COUNT(*) FROM tb_jogo_genero
UNION ALL SELECT 'usuários', COUNT(*) FROM tb_usuario;

-- Jogos sem gênero: deve voltar vazio
SELECT j.co_seq_jogo, j.no_jogo
FROM tb_jogo AS j
LEFT JOIN tb_jogo_genero AS jg ON jg.co_jogo = j.co_seq_jogo
WHERE jg.co_jogo IS NULL;

-- Jogos com mais de 3 gêneros: deve voltar vazio
SELECT co_jogo, COUNT(*) AS qt_generos
FROM tb_jogo_genero
GROUP BY co_jogo
HAVING COUNT(*) > 3;

-- Jogo inativo e jogo sem estoque
SELECT co_seq_jogo, no_jogo, st_ativo, qt_estoque
FROM tb_jogo
WHERE st_ativo = FALSE OR qt_estoque = 0;
