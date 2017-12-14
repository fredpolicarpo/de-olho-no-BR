DROP MATERIALIZED VIEW IF EXISTS grau_instrucao_eleitos;
CREATE MATERIALIZED VIEW grau_instrucao_eleitos
AS SELECT
     count(*)                      AS total,
     ano_eleicao,
     codigo_cargo,
     sigla_uf,
     cod_grau_instrucao,
     max(descricao_grau_instrucao) AS grau_instrucao
   FROM
     candidatos
   WHERE desc_sit_tot_turno IN ('ELEITO', 'ELEITO POR QP', 'ELEITO POR MÉDIA') AND sigla_uf != 'BR'
   GROUP BY ano_eleicao, codigo_cargo, sigla_uf, cod_grau_instrucao
   ORDER BY ano_eleicao, codigo_cargo, sigla_uf