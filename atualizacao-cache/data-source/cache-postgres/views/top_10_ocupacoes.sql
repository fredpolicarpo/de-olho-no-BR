DROP MATERIALIZED VIEW IF EXISTS top_10_ocupacoes;
CREATE MATERIALIZED VIEW top_10_ocupacoes
AS
  WITH candidatos_eleitos_distintos
  AS (SELECT DISTINCT ON (cpf_candidato) *
      FROM candidatos
      WHERE desc_sit_tot_turno IN ('ELEITO', 'ELEITO POR QP', 'ELEITO POR MÉDIA')
  ) SELECT
      ano_eleicao,
      max(descricao_ocupacao) AS ocupacao,
      count(*)                AS total
    FROM candidatos_eleitos_distintos
    WHERE codigo_ocupacao NOT IN (278, 201, 999, 0, 275)
    GROUP BY codigo_ocupacao, ano_eleicao
    ORDER BY total DESC