require(ggplot2)
require(plotly)

source("data-source/manchetes.R")

dados_top_10_ocupacoes = function(con, output, input) {
  anos = input$selectAnoEleicaoManchetesOutrasEstatisticas
  
  dados = top_10_ocupacoes(con, anos)
  
  plot = grafico_barras_horizontais(dados$total, dados$ocupacao)
  
  output$top_10_ocupacoes = renderPlotly({plot})
}