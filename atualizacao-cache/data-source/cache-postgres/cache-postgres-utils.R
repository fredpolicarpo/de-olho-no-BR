get_data_atualizacao_cache = function(categoria, cargo_cod, ano, con, filtro_uf = '') {
  
  sql = paste0(
    "SELECT max(DATA_GERACAO) as data_geracao FROM ",
    categoria,
    " WHERE codigo_cargo=",
    cargo_cod,
    " AND ANO_ELEICAO = ",
    ano,
    filtro_uf
  )
  
  dados = lerDados(con, sql)
  
  data = dados$data_geracao[1]
  
  return (data)
}