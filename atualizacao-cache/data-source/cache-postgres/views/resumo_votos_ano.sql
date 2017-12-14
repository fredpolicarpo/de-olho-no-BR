DROP MATERIALIZED VIEW IF EXISTS resumo_votos_ano;
CREATE MATERIALIZED VIEW resumo_votos_ano
AS
  SELECT
    ano_eleicao,
    codigo_cargo,
    uf,
    max(descricao_cargo)           AS descricao_cargo,
    sum(qt_votos_brancos)          AS brancos,
    sum(qt_votos_nulos)            AS nulos,
    sum(qtd_abstencoes)            AS abstencoes,
    sum(qt_votos_anulados_apu_sep) AS anulados,
    sum(qt_votos_legenda)          AS legenda,
    sum(qtd_aptos)                 AS aptos,
    sum(qtd_comparecimento)        AS comparecimeto
  FROM consolidacao_eleicao
  GROUP BY ano_eleicao, codigo_cargo, uf
  ORDER BY ano_eleicao, codigo_cargo, uf