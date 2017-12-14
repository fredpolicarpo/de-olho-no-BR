library(httr)
library(dplyr)
library(stringr)
library(data.table)
library(purrr)
library(foreach)
library(doMC)
library(crayon)

require(glue)

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
get_data_atualizacao_votos_cepesp = function(cargo_cod, ano, filtro_uf) {
  colunas = c("DATA_GERACAO", "ANO_ELEICAO", "CODIGO_CARGO", "QTDE_VOTOS")
  
  extra_param = glue('&columns[0][name]=UF&columns[0][search][value]={filtro_uf}')
  
  data_atualizacao = get_data_atualizacao_cepesp("votos", colunas, cargo_cod, ano, extra_param)
  
  return (data_atualizacao)
}

# Arquitetura: Serviço de atualização de dados
# Passo 1.2
get_data_atualizacao_votos_cache = function(cargo_cod, ano, con, filtro_uf) {
  sql_param = glue(" AND SIGLA_UE = '{filtro_uf}'")
  
  data = get_data_atualizacao_cache("votos", cargo_cod, ano, con, sql_param)
  
  return (data)
}

# Arquitetura: Serviço de atualização de dados
# Passo 1.3
verifica_necessidade_atualizacao_votos = function(cargo_cod, ano, con, filtro_uf) {
  data_geracao_cepesp = get_data_atualizacao_votos_cepesp(cargo_cod, ano, filtro_uf)
  data_geracao_cache = get_data_atualizacao_votos_cache(cargo_cod, ano, con, filtro_uf)
  
  precisa_atualizar = verifica_necessidade_atualizacao(data_geracao_cepesp, data_geracao_cache, cargo_cod, ano,filtro_uf)
  
  return(precisa_atualizar)
}

# Arquitetura: Serviço de atualização de dados
# Passo 2
get_votos = function(cargo_cod, ano, filtro_uf) {
  colunas = c(
    "DATA_GERACAO",
    "ANO_ELEICAO",
    "SIGLA_UE",
    "NUM_TURNO",
    "DESCRICAO_ELEICAO",
    "CODIGO_CARGO",
    "DESCRICAO_CARGO",
    "NUMERO_CANDIDATO",
    "QTDE_VOTOS",
    "CODIGO_MACRO",
    "NOME_MACRO",
    "UF",
    "NOME_UF",
    "CODIGO_MESO",
    "NOME_MESO",
    "CODIGO_MICRO",
    "NOME_MICRO",
    "COD_MUN_TSE",
    "COD_MUN_IBGE",
    "NOME_MUNICIPIO",
    "NUM_ZONA"
  )
  
  extra_param = '&agregacao_regional=8'
  
  if (is.null(filtro_uf) && is.na(filtro_uf) && filtro_uf != '') {
    extra_param = glue('{extra_param}}&columns[0][name]=UF&columns[0][search][value]={filtro_uf}')  
  }
  
  dados = get_dados("votos", colunas, cargo_cod, ano, extra_param=extra_param)
  
  return (dados)
}

# Arquitetura: Serviço de atualização de dados
# Passo 3
atualiza_dados_voto = function(cargo_cod, ano) {
  con = getCon()
  
  tryCatch({
    
    eh_dados_eleicao_local = cargo_cod %in% cod_cargos_eleicoes_municipais
    
    if (eh_dados_eleicao_local) {
      for (uf in ufs) {
        #Atualiza uma UF por vez para evitar arquivos muito grandes
        
        atualiza_dados(
          "votos",
          cargo_cod,
          ano,
          verifica_necessidade_atualizacao_votos,
          get_votos,
          recria_materialized_view_votos,
          con,
          uf
        )    
      }
    } else {
      atualiza_dados(
        "votos",
        cargo_cod,
        ano,
        verifica_necessidade_atualizacao_votos,
        get_votos,
        recria_materialized_view_votos,
        con
      )  
    }
  }, error = function(error_cod) {
    cat(red(error_cod, "\n"))
  }, finally =  dbDisconnect(con))
}

recria_materialized_view_votos = function(con, cargo_cod) {
  map <- new.env(hash = T, parent = emptyenv())
  
  map[["1"]] = "data-source/cache-postgres/views/presidentes_eleitos.sql"
  map[["3"]] = "data-source/cache-postgres/views/governadores_eleitos.sql"
  map[["5"]] = "data-source/cache-postgres/views/senadores_eleitos.sql"
  map[["6"]] = "data-source/cache-postgres/views/deputados_federais_eleitos.sql"
  map[["7"]] = "data-source/cache-postgres/views/deputados_estaduais_eleitos.sql"
  map[["8"]] = "data-source/cache-postgres/views/deputados_distritais_eleitos.sql"
  map[["11"]] = "data-source/cache-postgres/views/prefeitos_eleitos.sql"
  map[["13"]] = "data-source/cache-postgres/views/vereadores_eleitos.sql"
  
  excutarSql(con, map[[as.character(cargo_cod)]])
}

atualiza_dados_voto_paralelo = function(cod_cargos, anos_eleicoes) {
  qtde_eleicoes = length(anos_eleicoes)
  
  for(index in 1:length(cod_cargos)) {
    cargo_cod = cod_cargos[index]
    
    map2(rep(cargo_cod, qtde_eleicoes),
         anos_eleicoes,
         atualiza_dados_voto)
  }
  
}

# Arquitetura: Serviço de atualização de dados
# Função PRINCIPAL
main_atualiza_dados_votos = function() {
  #Eleições federativas
  atualiza_dados_voto_paralelo(cod_cargos_eleicoes_federatvas, anos_eleicoes_federativas)
  
  #Eleições municipais
  atualiza_dados_voto_paralelo(cod_cargos_eleicoes_municipais, anos_eleicoes_municipais)
}
