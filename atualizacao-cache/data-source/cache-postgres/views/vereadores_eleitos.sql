DROP MATERIALIZED VIEW IF EXISTS vereadores_eleitos;
CREATE MATERIALIZED VIEW IF NOT EXISTS vereadores_eleitos
AS
  WITH eleitos AS (
      SELECT
        ano_eleicao,
        codigo_cargo :: TEXT,
        sigla_uf,
        sigla_partido,
        sigla_ue,
        numero_candidato,
        max(descricao_ue)    AS descricao_ue,
        max(descricao_cargo) AS descricao_cargo,
        max(nome_candidato)  AS nome_candidato
      FROM
        candidatos
      WHERE desc_sit_tot_turno IN ('ELEITO', 'ELEITO POR QP', 'ELEITO POR MÉDIA')
            AND codigo_cargo :: INTEGER = 13
      GROUP BY
        ano_eleicao, sigla_uf, descricao_ue, sigla_partido, codigo_cargo, numero_candidato, sigla_ue
      ORDER BY descricao_cargo
  ), votos_ AS (
      SELECT
        codigo_cargo,
        ano_eleicao,
        uf,
        numero_candidato,
        sum(qtde_votos) qtde_votos
      FROM votos
      WHERE codigo_cargo = 13
      GROUP BY
        codigo_cargo,
        ano_eleicao,
        uf,
        numero_candidato
  ), eleitos_votos AS (
      SELECT
        eleitos.*,
        votos.qtde_votos
      FROM eleitos
        JOIN votos_ AS votos ON
                               votos.ano_eleicao = eleitos.ano_eleicao
                               AND votos.uf = eleitos.sigla_uf
                               AND votos.numero_candidato = eleitos.numero_candidato
  ), eleitos_mais_e_menos_votados AS (
      SELECT
        codigo_cargo,
        ano_eleicao,
        sigla_uf,
        max(qtde_votos) AS mais_votado,
        min(qtde_votos) AS menos_votado
      FROM eleitos_votos
      GROUP BY codigo_cargo,
        ano_eleicao,
        sigla_uf
  ) SELECT eleitos_votos.*
    FROM eleitos_votos
      JOIN eleitos_mais_e_menos_votados ON
                                          eleitos_mais_e_menos_votados.codigo_cargo = eleitos_votos.codigo_cargo
                                          AND eleitos_mais_e_menos_votados.codigo_cargo = eleitos_votos.codigo_cargo
                                          AND eleitos_mais_e_menos_votados.ano_eleicao = eleitos_votos.ano_eleicao
                                          AND eleitos_mais_e_menos_votados.sigla_uf = eleitos_votos.sigla_uf
    WHERE
      eleitos_votos.qtde_votos IN (eleitos_mais_e_menos_votados.mais_votado, eleitos_mais_e_menos_votados.menos_votado)
    ORDER BY eleitos_votos.sigla_uf,
      eleitos_votos.qtde_votos;
