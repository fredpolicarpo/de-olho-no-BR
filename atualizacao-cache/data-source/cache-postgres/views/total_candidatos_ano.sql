DROP MATERIALIZED VIEW IF EXISTS total_candidatos_ano;
CREATE MATERIALIZED VIEW total_candidatos_ano
AS
  SELECT
    count(*)             AS total,
    codigo_cargo,
    max(descricao_cargo) AS cargo,
    ano_eleicao
  FROM candidatos
  WHERE num_turno = 1
  GROUP BY codigo_cargo, ano_eleicao
  ORDER BY codigo_cargo, ano_eleicao