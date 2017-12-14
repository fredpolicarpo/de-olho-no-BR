library(dplyr)

# Setup
dados_carregados = F

if (!dados_carregados) {
  legendas =  load(file.path(PROCESSED_DIR, "LEGENDAS.RData")) %>% get()
  
  rm(df)
  
  dados_carregados = T
}
# Fim Setup

agrupamento_geral_partido = function() {
  candidados_por_partido = legendas %>%
    group_by(SIGLA_PARTIDO) %>%
    summarise(total_candidatos = n())
  
  return(candidados_por_partido)
}

qtde_candidatos_por_eleicao = function() {
  candidatos_por_eleicao = legendas %>%
    group_by(ANO_ELEICAO, DESCRICAO_CARGO) %>%
    summarise(total_candidatos = n())
  
  return(candidatos_por_eleicao)
}

qtde_candidatos_por_eleicao_cargo = function(cargos) {
  candidatos_por_eleicao = legendas %>%
    filter(DESCRICAO_CARGO %in% cargos) %>%
    group_by(ANO_ELEICAO, DESCRICAO_CARGO) %>%
    summarise(total_candidatos = n())
  
  return(candidatos_por_eleicao)
}

qtde_partidos_por_eleicao = function() {
  partidos_por_eleicao = legendas %>%
    filter(TIPO_LEGENDA %in% c("PARTIDO_ISOLADO", "PARTIDO ISOLADO")) %>%
    group_by(ANO_ELEICAO, SIGLA_PARTIDO) %>%
    select(ANO_ELEICAO, SIGLA_PARTIDO) %>%
    distinct(SIGLA_PARTIDO) %>%
    group_by(ANO_ELEICAO) %>%
    summarise(total = n())
  
  return(partidos_por_eleicao)
}

qtde_coligacoes_por_eleicao = function() {
  legendas_por_eleicao = legendas %>%
    filter(TIPO_LEGENDA == "COLIGACAO") %>%
    group_by(ANO_ELEICAO, NOME_COLIGACAO) %>%
    select(ANO_ELEICAO, NOME_COLIGACAO) %>%
    distinct(NOME_COLIGACAO) %>%
    group_by(ANO_ELEICAO) %>%
    summarise(total = n())
  
  return(legendas_por_eleicao)
}

todos_partidos = function() {
  return (legendas %>% distinct(SIGLA_PARTIDO))
}

todas_uf = function() {
  return (legendas %>% distinct(SIGLA_UF))
}

todos_cargos = function() {
  return (legendas %>% distinct(DESCRICAO_CARGO))
}


