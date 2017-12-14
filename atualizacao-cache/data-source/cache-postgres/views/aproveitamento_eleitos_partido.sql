DROP MATERIALIZED VIEW IF EXISTS aproveitamento_partidos;
CREATE MATERIALIZED VIEW aproveitamento_partidos
AS
  WITH total_candidatos_partido AS (
      SELECT
        sigla_partido,
        ano_eleicao,
        count(*) :: NUMERIC AS total_partido
      FROM candidatos
      GROUP BY sigla_partido, ano_eleicao
  ), total_eleitos_por_partido AS (
      SELECT
        sigla_partido,
        ano_eleicao,
        count(*) :: NUMERIC AS total_eleito_partido
      FROM candidatos
      WHERE desc_sit_tot_turno IN ('ELEITO', 'ELEITO POR QP', 'ELEITO POR MÉDIA')
      GROUP BY sigla_partido, ano_eleicao)
  SELECT
    total_candidatos_partido.ano_eleicao,
    total_candidatos_partido.sigla_partido,
    total_partido,
    total_eleito_partido
  FROM total_eleitos_por_partido
    INNER JOIN total_candidatos_partido
      ON total_candidatos_partido.sigla_partido = total_eleitos_por_partido.sigla_partido
         AND total_candidatos_partido.ano_eleicao = total_eleitos_por_partido.ano_eleicao