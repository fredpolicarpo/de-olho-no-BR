library(httr)
library(dplyr)
library(stringr)
library(data.table)
library(purrr)
library(foreach)
library(doMC)
library(crayon)

source("config/settings.R")
source("config/api-params.R")
source("atualizacao-cache-utils.R")
source("data-source/cepesp-io/cepesp-io-utils.R")
source("data-source/cache-postgres/cache-postgres-utils.R")
source("data-source/cache-postgres/db-connector.R")
source("utils.R")

# Execução paralela 4 núcleos
registerDoMC(4)

# Arquitetura: Serviço de atualização de dados
# Passo 1.1
# Os dados desta API atualmente não possuem data de geração!!!
get_data_atualizacao_consolidacao_eleicao_cepesp = function(cargo_cod, ano) {
  return (NA)
}

# Arquitetura: Serviço de atualização de dados
# Passo 1.2
# Os dados desta API atualmente não possuem data de geração!!!
get_data_atualizacao_consolidacao_eleicao_cache = function(cargo_cod, ano, con) {
  return (NA)
}

# Arquitetura: Serviço de atualização de dados
# Passo 1.3
verifica_necessidade_atualizacao_consolidacao_eleicao = function(cargo_cod, ano, con, filtros_extras = '') {
  data_geracao_cepesp = get_data_atualizacao_consolidacao_eleicao_cepesp(cargo_cod, ano)
  data_geracao_cache = get_data_atualizacao_consolidacao_eleicao_cache(cargo_cod, ano, con)
  
  precisa_atualizar = verifica_necessidade_atualizacao(data_geracao_cepesp, data_geracao_cache, cargo_cod, ano)
  
  return(precisa_atualizar)
}

# Arquitetura: Serviço de atualização de dados
# Passo 2
get_consolidacao_eleicao = function(cargo_cod, ano, filtros_extras = '') {
  colunas = c(
    "CODIGO_MACRO",
    "NOME_MACRO",
    "UF",
    "NOME_UF",
    "ANO_ELEICAO",
    "NUM_TURNO",
    "DESCRICAO_ELEICAO",
    "CODIGO_CARGO",
    "DESCRICAO_CARGO",
    "QTD_APTOS",
    "QTD_COMPARECIMENTO",
    "QTD_ABSTENCOES",
    "QT_VOTOS_NOMINAIS",
    "QT_VOTOS_BRANCOS",
    "QT_VOTOS_NULOS",
    "QT_VOTOS_LEGENDA",
    "QT_VOTOS_ANULADOS_APU_SEP"
  )
  
  extra_param="&agregacao_regional=2&agregacao_politica=4&brancos=true&nulos=true"
  
  dados = get_dados("tse", colunas, cargo_cod, ano, extra_param=extra_param)
  
  return (dados)
}

# Arquitetura: Serviço de atualização de dados
# Passo 3
atualiza_dados_consolidacao_eleicao = function(cargo_cod, ano) {
  tryCatch({
    atualiza_dados(
      "consolidacao_eleicao",
      cargo_cod,
      ano,
      verifica_necessidade_atualizacao_consolidacao_eleicao,
      get_consolidacao_eleicao,
      recria_materialized_view_consolidacao_eleicao,
      con
    )  
  }, error = function(error_cod) {
    cat(red(error_cod, "\n"))
  })
}

recria_materialized_view_consolidacao_eleicao = function(con, cargo_cod) {
  excutarSql(con,"data-source/cache-postgres/views/resumo_votos_ano.sql")
}

atualiza_dados_consolidacao_eleicao_paralelo = function(cod_cargos, anos_eleicoes) {
  qtde_eleicoes = length(anos_eleicoes)
  
  for(index in 1:length(cod_cargos)) {
    cargo_cod = cod_cargos[index]
    
    map2(rep(cargo_cod, qtde_eleicoes),
         anos_eleicoes,
         atualiza_dados_consolidacao_eleicao)
  }
}

# Arquitetura: Serviço de atualização de dados
# Função PRINCIPAL
main_atualiza_dados_consolidacao_eleicao = function() {
  #Eleições federativas
  atualiza_dados_consolidacao_eleicao_paralelo(cod_cargos_eleicoes_federatvas, anos_eleicoes_federativas)
  
  #Eleições municipais
  atualiza_dados_consolidacao_eleicao_paralelo(cod_cargos_eleicoes_municipais, anos_eleicoes_municipais)
}
