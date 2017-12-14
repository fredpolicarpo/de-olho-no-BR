-- CANDIDATOS
CREATE TABLE IF NOT EXISTS candidatos (
	id                             BIGSERIAL PRIMARY KEY,
	data_geracao                   DATE,
	ano_eleicao                    NUMERIC,
	num_turno                      NUMERIC,
	descricao_eleicao              TEXT,
	sigla_uf                       TEXT,
  sigla_ue                       TEXT,
	descricao_ue                   TEXT,
	descricao_cargo                TEXT,
	codigo_cargo                   NUMERIC,
	nome_candidato                 TEXT,
	numero_candidato               NUMERIC,
	cpf_candidato                  NUMERIC,
	nome_urna_candidato            TEXT,
	cod_situacao_candidatura       NUMERIC,
	des_situacao_candidatura       TEXT,
	numero_partido                 NUMERIC,
	sigla_partido                  TEXT,
	nome_partido                   TEXT,
	codigo_legenda                 TEXT,
	sigla_legenda                  TEXT,
	composicao_legenda             TEXT,
	nome_coligacao                 TEXT,
	codigo_ocupacao                NUMERIC,
	descricao_ocupacao             TEXT,
	data_nascimento                DATE,
	num_titulo_eleitoral_candidato TEXT,
	idade_data_eleicao             NUMERIC, 
	codigo_sexo                    NUMERIC,
	descricao_sexo                 TEXT,
	cod_grau_instrucao             NUMERIC,  
	descricao_grau_instrucao       TEXT,
	codigo_estado_civil            NUMERIC,
	descricao_estado_civil         TEXT,
	codigo_nacionalidade           NUMERIC,
	descricao_nacionalidade        TEXT,
	sigla_uf_nascimento            TEXT,
	codigo_municipio_nascimento    NUMERIC,
	nome_municipio_nascimento      TEXT,
	despesa_max_campanha           NUMERIC,
	cod_sit_tot_turno              NUMERIC,
	desc_sit_tot_turno             TEXT
);

CREATE INDEX candidatos_cod_cargo_ano_idx
	ON candidatos (codigo_cargo, ano_eleicao);