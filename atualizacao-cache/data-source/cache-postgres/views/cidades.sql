DROP MATERIALIZED VIEW IF EXISTS cidades;
CREATE MATERIALIZED VIEW cidades
AS SELECT DISTINCT
     sigla_uf,
     sigla_ue,
     max(descricao_ue) AS descricao_ue
   FROM candidatos
   GROUP BY sigla_uf, sigla_ue