load(file.path(PROCESSED_DIR, "resumo_legendas.RData"))
load(file.path(PROCESSED_DIR, "total_candidatos_por_partido.RData"))

criarBoxesLegendas = function(output) {
  # Legendas
  partido_max = resumo %>%
    filter(total == max(resumo$total))
  
  partido_min = resumo %>%
    filter(total == min(resumo$total))
  
  total_partidos_ativos = total_cadidatos_por_partido$SIGLA_PARTIDO %>% unique() %>% length()
  
  output$partido_max =  renderInfoBox({
    infoBox(
      "Partido com mais candidatos desde 1998",
      paste(partido_max[1, ]$SIGLA_PARTIDO,
            partido_max[1,]$total),
      icon = icon("triangle-top", lib = "glyphicon"),
      color = "green"
    )
  })
  
  output$partido_min =  renderInfoBox({
    infoBox(
      "Partido com menos candidatos desde 1998",
      paste(partido_min[1, ]$SIGLA_PARTIDO,
            partido_min[1,]$total),
      icon = icon("triangle-bottom", lib = "glyphicon"),
      color = "red"
    )
  })
  
  output$partidos_ativos = renderInfoBox({
    infoBox(
      "Num. de partidos desde 1998",
      total_partidos_ativos,
      icon = icon("list", lib = "glyphicon")
    )
  })
}