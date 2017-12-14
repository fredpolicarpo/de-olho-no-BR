require(dplyr)

source("config/api-params.R")

add_tipo_eleicao = function(dados) {
  federativas = dados$ano_eleicao %in% anos_eleicoes_federativas
  
  dados$tipo_eleicoes = character(nrow(dados))
  
  dados$tipo_eleicoes[federativas] = "federativa"
  dados$tipo_eleicoes[!federativas] = "local"
  
  return (dados)
}