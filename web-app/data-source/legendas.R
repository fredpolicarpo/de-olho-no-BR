source("data-source/db-connector.R")
library(dplyr)

total_partidos_ano_estado = function(con, ano) {
  sql = paste0("select * from total_partidos_ano where sigla_uf != 'BR' AND ano_eleicao = ", ano)
  
  dados = lerDados(con, sql)
  
  return(dados)
}

total_coligacoes_ano_estado = function(con, ano) {
  sql = paste0("select * from total_coligacoes_ano where sigla_uf != 'BR' AND ano_eleicao = ", ano)
  
  dados = lerDados(con, sql)
  
  return(dados)
}

total_partidos_ano = function(con) {
  dados = lerDados(con,"select sum(total) as total, ano_eleicao from total_partidos_ano group by ano_eleicao order by ano_eleicao")  %>%
            add_tipo_eleicao()
  
  return(dados)
}

total_coligacoes_ano = function(con) {
  dados = lerDados(con, "select sum(total) as total, ano_eleicao from total_coligacoes_ano group by ano_eleicao order by ano_eleicao")  %>%
            add_tipo_eleicao()
  return(dados)
}

total_candidatos_ano = function(con) {
  dados = lerDados(con, "select * from total_candidatos_ano") %>%
          add_tipo_eleicao()
  return(dados)
}