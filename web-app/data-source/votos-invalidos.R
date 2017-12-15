source("data-source/db-connector.R")
source("data-source/utils.R")

votos_invalidos = function(con) {
  query = 'SELECT
  ano_eleicao,
  round((sum(brancos) / sum(comparecimeto)) * 100, 2) AS brancos,
  round((sum(nulos) / sum(comparecimeto)) * 100, 2)   AS nulos,
  round((sum(abstencoes) / sum(aptos)) * 100, 2)      AS abstencoes
FROM resumo_votos_ano
GROUP BY ano_eleicao'
  
  dados_votos = lerDados(con,query) %>%
    gather("tipo","total", brancos, nulos, abstencoes) %>%
    add_tipo_eleicao() 
  
  return(dados_votos)
}

votos_brancos_ano = function(con) {
  
  query = 'SELECT
              ano_eleicao,
              round(((sum(brancos) / sum(comparecimeto)) * 100), 2) as total
           FROM resumo_votos_ano
           GROUP BY ano_eleicao
           ORDER BY ano_eleicao'
  
  dados_votos = lerDados(con,query) %>% add_tipo_eleicao()
  
  return(dados_votos)
}

votos_brancos_uf = function(con, ano) {
  
  query = glue('SELECT
  uf as UF,
  round(((sum(brancos) / sum(comparecimeto)) * 100), 2) AS total
FROM resumo_votos_ano
WHERE ano_eleicao = {ano} GROUP BY uf ORDER BY uf')

  dados_votos = lerDados(con,query)
  
  return(dados_votos)
}

votos_nulos_ano = function(con) {
  
  query = 'SELECT
              ano_eleicao,
              round(((sum(nulos) / sum(comparecimeto)) * 100), 2) as total
           FROM resumo_votos_ano
           GROUP BY ano_eleicao
           ORDER BY ano_eleicao'
  
  dados_votos = lerDados(con,query) %>% add_tipo_eleicao()
  
  return(dados_votos)
}

votos_nulos_uf = function(con, ano) {
  
  query = glue('SELECT
  uf as UF,
  round(((sum(nulos) / sum(comparecimeto)) * 100), 2) AS total
FROM resumo_votos_ano
WHERE ano_eleicao = {ano} GROUP BY uf ORDER BY uf')
  
  dados_votos = lerDados(con,query)
  
  return(dados_votos)
}

votos_abstencoes_ano = function(con) {
  
  query = 'SELECT
              ano_eleicao,
              round(((sum(abstencoes) / sum(aptos)) * 100), 2) as total
           FROM resumo_votos_ano
           GROUP BY ano_eleicao
           ORDER BY ano_eleicao'
  
  dados_votos = lerDados(con,query) %>% add_tipo_eleicao()
  
  return(dados_votos)
}

votos_abstencoes_uf = function(con, ano) {
  
  query = glue('SELECT
  uf as UF,
  round(((sum(abstencoes) / sum(comparecimeto)) * 100), 2) AS total
FROM resumo_votos_ano
WHERE ano_eleicao = {ano} GROUP BY uf ORDER BY uf')
  
  dados_votos = lerDados(con,query) 
  
  return(dados_votos)
}

votos_invalidos_uf = function(con, ano) {
  
  query = glue('SELECT
  uf as UF,
  round(((sum(abstencoes + brancos + nulos + anulados) / sum(aptos)) * 100), 2) AS total
FROM resumo_votos_ano
WHERE ano_eleicao = {ano} GROUP BY uf ORDER BY uf')
  
  dados_votos = lerDados(con,query)
  
  return(dados_votos)
}