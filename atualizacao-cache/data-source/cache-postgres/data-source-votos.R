source("data-sources/db-connector.R")
source("data-sources/data-source-candidatos.R")

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

prefeitos_eleitos = function(con, uf = 'SP', cidades = c("SAO PAULO", "SÃO PAULO")) {
  cidades = paste0("'", paste(unlist(cidades), collapse = "','"), "'")
  
  sql = paste0(
    "select * from prefeitos_eleitos where sigla_uf='",
    uf,
    "' and descricao_ue in (",
    cidades,
    ")"
  )
  
  dados_votos = lerDados(con, sql)
  
  return(dados_votos)
}
