-- VOTOS
CREATE TABLE IF NOT EXISTS votos (
	id                BIGSERIAL PRIMARY KEY,
	data_geracao      DATE,

	codigo_cargo      INT,
	descricao_cargo   TEXT,

	ano_eleicao       INT,
	num_turno         INT,
	descricao_eleicao TEXT,

	numero_candidato  NUMERIC,
	sigla_ue          TEXT,

	codigo_macro      INT,
	nome_macro        TEXT,

	uf                TEXT,
	nome_uf           TEXT,

	codigo_meso       INT,
	nome_meso         TEXT,

	codigo_micro      NUMERIC,
	nome_micro        TEXT,

	cod_mun_tse       INT,
	cod_mun_ibge      INT,
	nome_municipio    TEXT,

	num_zona          INT,

	qtde_votos        NUMERIC
);
CREATE INDEX votos_cod_cargo_ano_idx
	ON votos (codigo_cargo, ano_eleicao);