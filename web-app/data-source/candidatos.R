library(dplyr)

despesa_total_geral = function() {
  despesa = sum(candidatos$DESPESA_MAX_CAMPANHA)
  return(despesa)
}

despesas_eleicoes_federativas = function() {
  despesa =  candidatos %>%
    filter(!DESCRICAO_CARGO %in% c("PRFEITO", "VEREADOR")) %>%
    group_by(ANO_ELEICAO) %>%
    summarise(despesa = sum(DESPESA_MAX_CAMPANHA))
  return(despesa)
}

despesas_eleicoes_locais = function() {
  despesa =  candidatos %>%
    filter(DESCRICAO_CARGO %in% c("PRFEITO", "VEREADOR")) %>%
    group_by(ANO_ELEICAO) %>%
    summarise(despesa = sum(DESPESA_MAX_CAMPANHA))
  return(despesa)
}

despesa_partido_mais_gastou = function() {
  despesa_por_partido = candidatos %>%
    group_by(SIGLA_PARTIDO) %>%
    summarise(despesa = sum(DESPESA_MAX_CAMPANHA))
  
  return(despesa_por_partido %>% filter(despesa == max(despesa_por_partido$despesa)))
}

despesa_media = function() {
  despesa_por_partido = candidatos %>%
    group_by(SIGLA_PARTIDO) %>%
    summarise(despesa = sum(DESPESA_MAX_CAMPANHA))
  
  return(
    despesa_por_partido %>% filter(despesa > 2) %>% summarise(media = mean(despesa)) %>% as.numeric()
  )
}

despesa_por_cargo = function(partidos = NA, cargos = NA) {
  despesa_por_cargo = candidatos
  
  if (!is.null(cargos) && !is.na(cargos) && length(cargos) > 0) {
    despesa_por_cargo = despesa_por_cargo %>%
      filter(DESCRICAO_CARGO %in% cargos)
  }
  
  if (!is.null(partidos) && !is.na(partidos) && length(partidos) > 0) {
    despesa_por_cargo = despesa_por_cargo %>%
      filter(SIGLA_PARTIDO %in% partidos) %>%
      group_by(DESCRICAO_CARGO, SIGLA_PARTIDO)
  } else {
    despesa_por_cargo = despesa_por_cargo %>%
      group_by(DESCRICAO_CARGO)
  }
  
  despesa_por_cargo = despesa_por_cargo %>%
    summarise(DESPESA = sum(DESPESA_MAX_CAMPANHA)) %>%
    arrange(desc(DESPESA))
  
  return(despesa_por_cargo)
}

despesa_total_por_cargo_top_5 = function(cargos = NA) {
  despesa = despesa_por_cargo(partidos = todos_partidos()$SIGLA_PARTIDO)
  
  if (!is.null(cargos) && !is.na(cargos) && length(cargos) > 0) {
    despesa = despesa %>% filter(DESCRICAO_CARGO %in% cargos)
  }
  
  return(despesa %>% arrange(DESCRICAO_CARGO, desc(DESPESA)) %>% top_n(5))
}

despesa_media_por_cargo_top_5 = function(cargos = NA) {
  despesa = despesa_media_por_cargo(partidos = todos_partidos()$SIGLA_PARTIDO)
  
  if (!is.null(cargos) && !is.na(cargos) && length(cargos) > 0) {
    despesa = despesa %>% filter(DESCRICAO_CARGO %in% cargos)
  }
  
  return(despesa %>% arrange(DESCRICAO_CARGO, desc(DESPESA)) %>% top_n(5))
}

despesa_media_por_cargo = function(partidos = NA, cargos = NA) {
  despesa_por_cargo = candidatos
  
  if (!is.null(cargos) && !is.na(cargos) && length(cargos) > 0) {
    despesa_por_cargo = despesa_por_cargo %>%
      filter(DESCRICAO_CARGO %in% cargos)
  }
  
  if (!is.null(partidos) && !is.na(partidos) && length(partidos) > 0) {
    despesa_por_cargo = despesa_por_cargo %>%
      filter(SIGLA_PARTIDO %in% partidos) %>%
      group_by(DESCRICAO_CARGO, SIGLA_PARTIDO)
  } else {
    despesa_por_cargo = despesa_por_cargo %>%
      group_by(DESCRICAO_CARGO)
  }
  
  despesa_por_cargo = despesa_por_cargo %>%
    summarise(DESPESA = mean(DESPESA_MAX_CAMPANHA)) %>%
    arrange(desc(DESPESA))
  
  return(despesa_por_cargo)
}

despesa_por_eleicao = function(partidos = NA) {
  if (!is.null(partidos) &&
      !is.na(partidos) && length(partidos) > 0) {
    despesa_por_cargo = candidatos %>%
      filter(SIGLA_PARTIDO %in% partidos) %>%
      group_by(ANO_ELEICAO, SIGLA_PARTIDO) %>%
      summarise(DESPESA = sum(DESPESA_MAX_CAMPANHA)) %>%
      arrange(ANO_ELEICAO)
  } else {
    despesa_por_cargo = candidatos %>%
      group_by(ANO_ELEICAO) %>%
      summarise(DESPESA = sum(DESPESA_MAX_CAMPANHA)) %>%
      arrange(ANO_ELEICAO)
  }
  
  return(despesa_por_cargo)
}
