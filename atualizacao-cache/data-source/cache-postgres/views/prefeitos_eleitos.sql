DROP MATERIALIZED VIEW IF EXISTS prefeitos_eleitos;
CREATE MATERIALIZED VIEW IF NOT EXISTS prefeitos_eleitos
AS
  WITH eleitos AS (
      SELECT
        ano_eleicao,
        codigo_cargo :: NUMERIC,
        numero_candidato,
        sigla_partido,
        sigla_uf,
        sigla_ue,
        max(descricao_ue)    AS descricao_ue,
        max(descricao_cargo) AS descricao_cargo,
        max(nome_candidato)  AS nome_candidato,
        max(num_turno)       AS num_turno
      FROM
        candidatos
      WHERE desc_sit_tot_turno IN ('ELEITO', 'ELEITO POR QP', 'ELEITO POR MÉDIA')
            AND codigo_cargo :: NUMERIC = 11
      GROUP BY
        ano_eleicao, codigo_cargo, numero_candidato, sigla_partido, sigla_uf, sigla_ue, descricao_ue
  ), votos AS (
      SELECT
        codigo_cargo,
        ano_eleicao,
        num_turno,
        numero_candidato,
        sum(qtde_votos) qtde_votos
      FROM votos
      WHERE codigo_cargo = 11
      GROUP BY
        codigo_cargo,
        ano_eleicao,
        num_turno,
        numero_candidato
  )
  SELECT
    eleitos.*,
    votos.qtde_votos
  FROM eleitos
    JOIN votos ON
                 votos.ano_eleicao = eleitos.ano_eleicao
                 AND votos.num_turno = eleitos.num_turno
                 AND votos.numero_candidato = eleitos.numero_candidato
  ORDER BY eleitos.descricao_cargo,
    eleitos.ano_eleicao;