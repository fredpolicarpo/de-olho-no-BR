DROP MATERIALIZED VIEW IF EXISTS governadores_eleitos;
CREATE MATERIALIZED VIEW IF NOT EXISTS governadores_eleitos
AS
  WITH eleitos AS (
      SELECT
        ano_eleicao,
        codigo_cargo :: NUMERIC,
        sigla_uf,
        numero_candidato,
        sigla_partido,
        max(descricao_cargo) AS descricao_cargo,
        max(nome_candidato)  AS nome_candidato,
        max(num_turno)       AS num_turno
      FROM
        candidatos
      WHERE desc_sit_tot_turno IN ('ELEITO', 'ELEITO POR QP', 'ELEITO POR MÉDIA')
            AND codigo_cargo :: NUMERIC = 3
      GROUP BY
        ano_eleicao, sigla_uf, codigo_cargo, numero_candidato, sigla_partido
      ORDER BY descricao_cargo
  ), votos AS (
      SELECT
        codigo_cargo,
        ano_eleicao,
        uf,
        num_turno,
        numero_candidato,
        sum(qtde_votos) qtde_votos
      FROM votos
      WHERE codigo_cargo = 3
      GROUP BY
        codigo_cargo,
        ano_eleicao,
        uf,
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
                 AND votos.uf = eleitos.sigla_uf
                 AND votos.numero_candidato = eleitos.numero_candidato;