DROP MATERIALIZED VIEW IF EXISTS eleitos_genero;
CREATE MATERIALIZED VIEW eleitos_genero
AS SELECT
     count(*) AS total,
     ano_eleicao,
     codigo_cargo,
     sigla_uf,
     sigla_partido,
     max(descricao_ue),
     descricao_sexo
   FROM
     candidatos
   WHERE desc_sit_tot_turno IN ('ELEITO', 'ELEITO POR QP', 'ELEITO POR MÉDIA')
   GROUP BY ano_eleicao, codigo_cargo, sigla_uf, sigla_partido, descricao_sexo