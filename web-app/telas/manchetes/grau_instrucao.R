require(ggplot2)
require(plotly)

source("data-source/manchetes.R")
source("telas/utils.R")

dados_grau_instrucao = function(con, output, input) {
  anos = input$selectAnoEleicaoManchetesOutrasEstatisticas
  
  dados = grau_instrucao(con, anos)
  
  plot = grafico_barras_horizontais(dados$total, dados$grau_instrucao)
  
  output$geral_grau_instrucao = renderPlotly({plot})
}