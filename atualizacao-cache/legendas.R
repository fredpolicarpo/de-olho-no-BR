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
get_data_atualizacao_legendas_cepesp = function(cargo_cod, ano, params_extras = '') {
  colunas = c("ANO_ELEICAO", "DATA_GERACAO", "CODIGO_CARGO")
  
  data_atualizacao = get_data_atualizacao_cepesp("legendas", colunas, cargo_cod, ano)
  
  return (data_atualizacao)
}

# Arquitetura: Serviço de atualização de dados
# Passo 1.2
get_data_atualizacao_legendas_cache = function(cargo_cod, ano, con, params_extras = '') {
  data = get_data_atualizacao_cache("legendas", cargo_cod, ano, con)
  
  return (data)
}

# Arquitetura: Serviço de atualização de dados
# Passo 1.3
verifica_necessidade_atualizacao_legendas = function(cargo_cod, ano, con, params_extras = '') {
  data_geracao_cepesp = get_data_atualizacao_legendas_cepesp(cargo_cod, ano)
  data_geracao_cache = get_data_atualizacao_legendas_cache(cargo_cod, ano, con)
  
  precisa_atualizar = verifica_necessidade_atualizacao(data_geracao_cepesp, data_geracao_cache, cargo_cod, ano, params_extras)
  
  return(precisa_atualizar)
}

# Arquitetura: Serviço de atualização de dados
# Passo 2
get_legendas = function(cargo_cod, ano, filtros_extras = '') {
  colunas = c(
    "DATA_GERACAO",
    "ANO_ELEICAO",
    "NUM_TURNO",
    "DESCRICAO_ELEICAO",
    "SIGLA_UF",
    "SIGLA_UE",
    "CODIGO_CARGO",
    "DESCRICAO_CARGO",
    "TIPO_LEGENDA",
    "NUMERO_PARTIDO",
    "SIGLA_PARTIDO",
    "NOME_PARTIDO",
    "SIGLA_COLIGACAO",
    "NOME_COLIGACAO",
    "COMPOSICAO_COLIGACAO",
    "SEQUENCIAL_COLIGACAO"
  )
  
  dados = get_dados("legendas", colunas, cargo_cod, ano)
  
  return(dados)
}

# Arquitetura: Serviço de atualização de dados
# Passo 3
atualiza_dados_legendas = function(cargo_cod, ano) {
  tryCatch({
    atualiza_dados(
      "legendas",
      cargo_cod,
      ano,
      verifica_necessidade_atualizacao_legendas,
      get_legendas,
      recria_materialized_view_legendas,
      con
    )
  }, error = function(error_cod) {
    cat(red(error_cod, "\n"))
  })
}

recria_materialized_view_legendas = function(con, cargo_cod) {
  excutarSql(con, "data-source/cache-postgres/views/total_partidos_ano.sql")
  excutarSql(con, "data-source/cache-postgres/views/total_coligacoes_ano.sql")
}

atualiza_dados_legendas_paralelo = function(cod_cargos, anos_eleicoes) {
  qtde_eleicoes = length(anos_eleicoes)
  
  for (index in 1:length(cod_cargos)) {
    cargo_cod = cod_cargos[index]
    
    map2(rep(cargo_cod, qtde_eleicoes),
         anos_eleicoes,
         atualiza_dados_legendas)
  }
}

# Arquitetura: Serviço de atualização de dados
# Função PRINCIPAL
main_atualiza_dados_legendas = function() {
  #Eleições federativas
  atualiza_dados_legendas_paralelo(cod_cargos_eleicoes_federatvas, anos_eleicoes_federativas)
  
  #Eleições municipais
  atualiza_dados_legendas_paralelo(cod_cargos_eleicoes_municipais, anos_eleicoes_municipais)
}
