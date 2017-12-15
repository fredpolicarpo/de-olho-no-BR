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
get_data_atualizacao_candidatos_cepesp = function(cargo_cod, ano) {
  colunas = c("DATA_GERACAO", "ANO_ELEICAO", "CODIGO_CARGO")
  
  data_atualizacao = get_data_atualizacao_cepesp("candidatos", colunas, cargo_cod, ano)
  
  return (data_atualizacao)
}

# Arquitetura: Serviço de atualização de dados
# Passo 1.2
get_data_atualizacao_candidatos_cache = function(cargo_cod, ano, con) {
  data = get_data_atualizacao_cache("candidatos", cargo_cod, ano, con)
  
  return (data)
}

# Arquitetura: Serviço de atualização de dados
# Passo 1.3
verifica_necessidade_atualizacao_candidatos = function(cargo_cod, ano, con, extra_param = '') {
  data_geracao_cepesp = get_data_atualizacao_candidatos_cepesp(cargo_cod, ano)
  data_geracao_cache = get_data_atualizacao_candidatos_cache(cargo_cod, ano, con)
  
  precisa_atualizar = verifica_necessidade_atualizacao(data_geracao_cepesp, data_geracao_cache, cargo_cod, ano)
  
  return(precisa_atualizar)
}

# Arquitetura: Serviço de atualização de dados
# Passo 2
get_candidatos = function(cargo_cod, ano, filtros_extras = '') {
  colunas = c(
    "DATA_GERACAO",
    "ANO_ELEICAO",
    "NUM_TURNO",
    "DESCRICAO_ELEICAO",
    "SIGLA_UF",
    "SIGLA_UE",
    "DESCRICAO_UE",
    "CODIGO_CARGO",
    "DESCRICAO_CARGO",
    "NOME_CANDIDATO",
    "NUMERO_CANDIDATO",
    "CPF_CANDIDATO",
    "NOME_URNA_CANDIDATO",
    "COD_SITUACAO_CANDIDATURA",
    "DES_SITUACAO_CANDIDATURA",
    "NUMERO_PARTIDO",
    "SIGLA_PARTIDO",
    "NOME_PARTIDO",
    "CODIGO_LEGENDA",
    "SIGLA_LEGENDA",
    "COMPOSICAO_LEGENDA",
    "NOME_COLIGACAO",
    "CODIGO_OCUPACAO",
    "DESCRICAO_OCUPACAO",
    "DATA_NASCIMENTO",
    "NUM_TITULO_ELEITORAL_CANDIDATO",
    "IDADE_DATA_ELEICAO",
    "CODIGO_SEXO",
    "DESCRICAO_SEXO",
    "COD_GRAU_INSTRUCAO",
    "DESCRICAO_GRAU_INSTRUCAO",
    "CODIGO_ESTADO_CIVIL",
    "DESCRICAO_ESTADO_CIVIL",
    "CODIGO_NACIONALIDADE",
    "DESCRICAO_NACIONALIDADE",
    "SIGLA_UF_NASCIMENTO",
    "CODIGO_MUNICIPIO_NASCIMENTO",
    "NOME_MUNICIPIO_NASCIMENTO",
    "DESPESA_MAX_CAMPANHA",
    "COD_SIT_TOT_TURNO",
    "DESC_SIT_TOT_TURNO"
  )
  
  dados = get_dados("candidatos", colunas, cargo_cod, ano)
  
  return(dados)
}

# Arquitetura: Serviço de atualização de dados
# Passo 3
atualiza_dados_candidatos = function(cargo_cod, ano) {
  tryCatch({
    atualiza_dados(
      "candidatos",
      cargo_cod,
      ano,
      verifica_necessidade_atualizacao_candidatos,
      get_candidatos,
      recria_materialized_view_candidatos,
      con
    )  
  }, error = function(error_cod) {
    cat(red(error_cod, "\n"))
  })
}

#TODO - Definir views
recria_materialized_view_candidatos = function(con, cargo_cod) {
  excutarSql(con, "data-source/cache-postgres/views/cidades.sql")
  excutarSql(con, "data-source/cache-postgres/views/eleitos_genero.sql")
  excutarSql(con, "data-source/cache-postgres/views/grau_instrucao_eleitos.sql")
  excutarSql(con, "data-source/cache-postgres/views/top_10_ocupacoes.sql")
  excutarSql(con, "data-source/cache-postgres/views/proporcao_executivos_turno.sql")
  excutarSql(con, "data-source/cache-postgres/views/proporcao_eleitos_partido.sql")
  excutarSql(con, "data-source/cache-postgres/views/aproveitamento_eleitos_partido.sql")
}

atualiza_dados_candidatos_paralelo = function(cod_cargos, anos_eleicoes) {
  qtde_eleicoes = length(anos_eleicoes)
  
  for (index in 1:length(cod_cargos)) {
    cargo_cod = cod_cargos[index]
    
    map2(rep(cargo_cod, qtde_eleicoes),
         anos_eleicoes,
         atualiza_dados_candidatos)
  }
}

# Arquitetura: Serviço de atualização de dados
# Função PRINCIPAL
main_atualiza_dados_candidatos = function() {
  #Eleições federativas
  atualiza_dados_candidatos_paralelo(cod_cargos_eleicoes_federatvas, anos_eleicoes_federativas)
  
  #Eleições municipais
  atualiza_dados_candidatos_paralelo(cod_cargos_eleicoes_municipais, anos_eleicoes_municipais)
}
