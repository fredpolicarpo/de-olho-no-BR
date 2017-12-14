DROP MATERIALIZED VIEW IF EXISTS total_partidos_ano;
CREATE MATERIALIZED VIEW total_partidos_ano
AS
  SELECT
    count(DISTINCT sigla_partido) as total,
    sigla_uf,
    ano_eleicao
  FROM legendas
  GROUP BY ano_eleicao, sigla_uf
  ORDER BY ano_eleicao, sigla_uf