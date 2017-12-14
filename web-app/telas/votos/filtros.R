carregaFiltroCidadesPrefeitosEleitos <- function(session, input, con) {
  ufs = input$selectUfsPrefeitosEleitos
  
  cidades_selecionadas = input$selectCidadesPrefeitosEleitos
  
  if (is.na(ufs) || is.null(ufs)) {
    return()
  }
  
  if (is.na(cidades_selecionadas) || is.null(cidades_selecionadas)) {
    cidades_selecionadas = c()
  }
  
  ufs = paste0("'", paste(unlist(ufs), collapse = "','"), "'")
  
  sql = paste0("select descricao_ue, sigla_ue from cidades where sigla_uf in (", ufs, ")")
  
  cidades_all = lerDados(con, sql)
  
  cidades = cidades_all$sigla_ue
  names(cidades) = cidades_all$descricao_ue
  
  updateSelectInput(
    session,
    "selectCidadesPrefeitosEleitos",
    choices = c("Selecione a(s) cidade(s).." = "", cidades),
    selected = cidades_selecionadas
  )
}

carregaFiltroCidadesVereadoresEleitos <- function(session, input, con) {
  ufs = input$selectUfsVereadoresEleitos
  
  cidades_selecionadas = input$selectCidadesVereadoresEleitos
  
  if (is.na(ufs) || is.null(ufs)) {
    return()
  }
  
  if (is.na(cidades_selecionadas) || is.null(cidades_selecionadas)) {
    cidades_selecionadas = c()
  }
  
  ufs = paste0("'", paste(unlist(ufs), collapse = "','"), "'")
  
  sql = paste0("select descricao_ue, sigla_ue from cidades where sigla_uf in (", ufs, ")")
  
  cidades_all = lerDados(con, sql)
  
  cidades = cidades_all$sigla_ue
  names(cidades) = cidades_all$descricao_ue
  
  updateSelectInput(
    session,
    "selectCidadesVereadoresEleitos",
    choices = c("Selecione a(s) cidade(s).." = "", cidades),
    selected = cidades_selecionadas
  )
}