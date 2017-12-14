DROP MATERIALIZED VIEW IF EXISTS porcent_executivos_truno;
CREATE MATERIALIZED VIEW porcent_executivos_truno
AS
  WITH total_eleitos_executivo AS (
      SELECT
        ano_eleicao,
        count(*) :: NUMERIC AS total
      FROM candidatos
      WHERE codigo_cargo IN (1, 3, 11)
            AND desc_sit_tot_turno IN ('ELEITO', 'ELEITO POR QP', 'ELEITO POR MÉDIA')
      GROUP BY ano_eleicao
  ), total_eleitos_executivo_por_turno AS (
      SELECT
        ano_eleicao,
        num_turno,
        count(*) :: NUMERIC AS total_turno
      FROM candidatos
      WHERE codigo_cargo IN (1, 3, 11)
            AND desc_sit_tot_turno IN ('ELEITO', 'ELEITO POR QP', 'ELEITO POR MÉDIA')
      GROUP BY ano_eleicao, num_turno)
  SELECT
    total_eleitos_executivo.ano_eleicao,
    num_turno,
    total,
    total_turno
  FROM total_eleitos_executivo
    INNER JOIN total_eleitos_executivo_por_turno
      ON total_eleitos_executivo_por_turno.ano_eleicao = total_eleitos_executivo.ano_eleicao