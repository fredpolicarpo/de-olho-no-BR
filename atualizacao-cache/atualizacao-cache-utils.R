library(crayon)

verifica_necessidade_atualizacao = function(data_geracao_cepesp,
                                            data_geracao_cache,
                                            cargo_cod,
                                            ano,
                                            filtro_uf = '') {
  print(paste("Data do cepesp:", data_geracao_cepesp))
  print(paste("Data da cache:", data_geracao_cache))
  
  if (is.null(data_geracao_cepesp)) {
    stop("Falha ao verificar data de geração na API CEPESP.IO")
  }
  
  data_cache_desatualizada_ou_inexistente = is.null(data_geracao_cache) ||
    is.na(data_geracao_cache) ||
    data_geracao_cepesp != data_geracao_cache
  
  if (data_cache_desatualizada_ou_inexistente) {
    msg = paste(
      "Dados DESATUALIZADOS para cargo_cod=",
      cargo_cod,
      "e ano=",
      ano, 
      filtro_uf
    )
    
    cat(blue(msg, "\n"))
    
    return(TRUE)
  } else {
    print(paste("Dados atualizados para cargo_cod", cargo_cod, "e ano", ano, filtro_uf))
    return(FALSE)
  } 
}

atualiza_dados = function(categoria,
                          cargo_cod,
                          ano,
                          func_verify,
                          func_get,
                          func_views,
                          con,
                          filtros_extras = '') {
  tryCatch({
    precisa_atualizar = func_verify(cargo_cod, ano, con, filtros_extras)
    
    if (precisa_atualizar) {
      print(paste0("Baixando dados ", categoria, "..."))
      dados = func_get(cargo_cod, ano, filtros_extras)
      
      print(paste0("Escrevendo dados ", categoria, "..."))
      
      # Remover dados existentes
      sql_delete = paste("delete from", categoria, "where codigo_cargo=", cargo_cod, "and ano_eleicao=", ano)
      dbExecute(con, sql_delete)
      
      upsert(con, categoria, dados)
      
      print(paste0("Recriando view materializada ", categoria, "..."))
      func_views(con, cargo_cod)
      
      cat(green("Pronto!","\n"))
    }
  },  error = function(error_condition) {
    msg = paste(
      "Erro em atualiza_dados categoria/cargo/ano [",
      categoria,cargo_cod, ano,
      "] ",
      error_condition
    )
    
    cat(red(msg, "\n"))
  })
}
