DROP MATERIALIZED VIEW IF EXISTS porcent_eleitos_partido;
CREATE MATERIALIZED VIEW porcent_eleitos_partido
AS
  WITH total_eleitos AS (
      SELECT
        ano_eleicao,
        count(*) :: NUMERIC AS total
      FROM candidatos
      WHERE desc_sit_tot_turno IN ('ELEITO', 'ELEITO POR QP', 'ELEITO POR MÉDIA')
      GROUP BY ano_eleicao
  ), total_eleitos_por_partido AS (
      SELECT
        sigla_partido,
        ano_eleicao,
        count(*) :: NUMERIC AS total_partido
      FROM candidatos
      WHERE desc_sit_tot_turno IN ('ELEITO', 'ELEITO POR QP', 'ELEITO POR MÉDIA')
      GROUP BY sigla_partido, ano_eleicao)
  SELECT
    total_eleitos.ano_eleicao,
    total_eleitos_por_partido.sigla_partido,
    total_eleitos_por_partido.total_partido,
    round((total_eleitos_por_partido.total_partido / total_eleitos.total) * 100, 4) AS porcentagem
  FROM total_eleitos_por_partido
    INNER JOIN total_eleitos
      ON total_eleitos.ano_eleicao = total_eleitos_por_partido.ano_eleicao
  ORDER BY porcentagem DESC