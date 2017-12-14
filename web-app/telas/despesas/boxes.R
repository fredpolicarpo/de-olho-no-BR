source("data-sources/data-source-candidatos.R")
source("utils.R")

criarBoxes = function(output) {
  output$total_despesa =  renderInfoBox({
    infoBox(
      "Gasto total",
      dinheiro(despesa_total_geral()),
      icon = icon("money"),
      color = "blue"
    )
  })
  
  despesa_partido_mais_gastou = despesa_partido_mais_gastou()
  
  info = paste(
    as.character(despesa_partido_mais_gastou$SIGLA_PARTIDO),
    dinheiro(despesa_partido_mais_gastou$despesa)
  )
  
  output$partido_maior_despesa =  renderInfoBox({
    infoBox(
      "Partido que mais gastou",
      info,
      icon = icon("money"),
      color = "red"
    )
  })
  
  despesa_media = despesa_media()
  
  output$despesa_media =  renderInfoBox({
    infoBox(
      "Média por partido",
      dinheiro(despesa_media),
      icon = icon("money"),
      color = "green"
    )
  })
}
