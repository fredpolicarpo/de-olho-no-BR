DROP MATERIALIZED VIEW IF EXISTS total_coligacoes_ano;
CREATE MATERIALIZED VIEW total_coligacoes_ano
AS
  SELECT
    count(DISTINCT sequencial_coligacao) as total,
    sigla_uf,
    ano_eleicao
  FROM legendas
  WHERE tipo_legenda = 'COLIGACAO'
  GROUP BY sigla_uf, ano_eleicao
  ORDER BY sigla_uf, ano_eleicao