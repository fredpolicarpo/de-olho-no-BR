require(glue)

source("data-source/db-connector.R")
source("data-source/candidatos.R")

presidentes_eleitos = function(con) {
  dados_votos = lerDados(con, "select * from presidentes_eleitos")
  
  return(dados_votos)
}

governadores_eleitos = function(con, uf = NULL) {
  sql = "select * from governadores_eleitos "
  
  if (!is.null(uf) && length(uf) > 0) {
    uf = paste0("'", paste(unlist(uf), collapse = "','"), "'")
    
    sql = paste0(sql, "\nwhere sigla_uf in (", uf, ")")
  }
  
  dados_votos = lerDados(con, sql)
  
  return(dados_votos)
}

senadores_eleitos = function(con, uf = NULL) {
  sql = "select * from senadores_eleitos "
  
  if (!is.null(uf) && length(uf) > 0) {
    uf = paste0("'", paste(unlist(uf), collapse = "','"), "'")
    
    sql = paste0(sql, "\nwhere sigla_uf in (", uf, ")")
  }
  
  dados_votos = lerDados(con, sql)
  
  return(dados_votos)
}

deputados_federais_eleitos = function(con, uf = NULL) {
  sql = "select * from deputados_federais_eleitos "
  
  if (!is.null(uf) && length(uf) > 0) {
    uf = paste0("'", paste(unlist(uf), collapse = "','"), "'")
    
    sql = paste0(sql, "\nwhere sigla_uf in (", uf, ")")
  }
  
  dados_votos = lerDados(con, sql)
  
  return(dados_votos)
}

deputados_estaduais_eleitos = function(con, uf = NULL) {
  sql = "select * from deputados_estaduais_eleitos "
  
  if (!is.null(uf) && length(uf) > 0) {
    uf = paste0("'", paste(unlist(uf), collapse = "','"), "'")
    
    sql = paste0(sql, "\nwhere sigla_uf in (", uf, ")")
  }
  
  dados_votos = lerDados(con, sql)
  
  return(dados_votos)
}

prefeitos_eleitos = function(con, uf = 'SP', cidades = c("SAO PAULO", "SÃO PAULO")) {
  uf = paste0("'", paste(unlist(uf), collapse = "','"), "'")
  cidades = paste0("'", paste(unlist(cidades), collapse = "','"), "'")
  
  sql = glue('WITH cidade AS
    (
      SELECT
      sigla_ue,
      max(descricao_ue) AS descricao_ue
      FROM prefeitos_eleitos
      WHERE sigla_uf IN ({uf}) AND sigla_ue IN ({cidades})
      GROUP BY sigla_ue
    )
    , eleitos AS
    (
      SELECT
      num_turno,
      ano_eleicao,
      nome_candidato,
      sigla_uf,
      sigla_ue,
      sigla_partido,
      sum(qtde_votos) AS qtde_votos
      FROM prefeitos_eleitos
      WHERE sigla_uf IN ({uf}) AND sigla_ue IN ({cidades})
      GROUP BY ano_eleicao, sigla_uf, sigla_ue, nome_candidato, num_turno, sigla_partido
    ) SELECT *
      FROM eleitos
    JOIN cidade ON eleitos.sigla_ue = cidade.sigla_ue')
  
  dados_votos = lerDados(con, sql)
  
  return(dados_votos)
}

vereadores_eleitos = function(con, uf = 'SP', cidades = c("SAO PAULO", "SÃO PAULO")) {
  uf = paste0("'", paste(unlist(uf), collapse = "','"), "'")
  cidades = paste0("'", paste(unlist(cidades), collapse = "','"), "'")
  
  sql = glue('WITH cidade AS
    (
      SELECT
      sigla_ue,
      max(descricao_ue) AS descricao_ue
      FROM vereadores_eleitos
      WHERE sigla_uf IN ({uf}) AND sigla_ue IN ({cidades})
      GROUP BY sigla_ue
    )
    , eleitos AS
    (
      SELECT
      ano_eleicao,
      nome_candidato,
      sigla_uf,
      sigla_ue,
      sigla_partido,
      sum(qtde_votos) AS qtde_votos
      FROM vereadores_eleitos
      WHERE sigla_uf IN ({uf}) AND sigla_ue IN ({cidades})
      GROUP BY ano_eleicao, sigla_uf, sigla_ue, nome_candidato, sigla_partido
    ) SELECT *
      FROM eleitos
    JOIN cidade ON eleitos.sigla_ue = cidade.sigla_ue')
  
  dados_votos = lerDados(con, sql)
  
  return(dados_votos)
}