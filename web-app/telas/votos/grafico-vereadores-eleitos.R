source("data-source/votos.R")
source("utils.R")

library(ggplot2)
library(plotly)

dados_vereadores_eleitos = function(con, output, input) {
  if (is.null(input$selectUfsVereadoresEleitos) || is.null(input$selectCidadesVereadoresEleitos)) {
    return()
  }
  
  ufs =  input$selectUfsVereadoresEleitos
  cidades = input$selectCidadesVereadoresEleitos
  
  dados = vereadores_eleitos(con,ufs, cidades)
  
  if (length(dados) == 0) {
    showNotification("Dados de vereadores não encontrados para esse filtro", type="warning")
    return()
  }
  
  step = round((max(dados$qtde_votos) - min(dados$qtde_votos)) / 10)
  y_values = seq(from = min(dados$qtde_votos), to=max(dados$qtde_votos), by=step)  
  
  plot =   ggplot(dados,
                  aes(x = ano_eleicao,
                      y = qtde_votos,
                      col=descricao_ue)) +
    geom_line() +
    geom_point(aes(text = paste0(nome_candidato, "\n", sigla_partido, "\n", numero(qtde_votos), " votos"))) +
    ylab("") +
    xlab("Ano Eleição")  +
    scale_x_continuous(breaks = dados$ano_eleicao) +
    scale_y_continuous(breaks = y_values, labels = numero(y_values))+
    theme(legend.position = "top", legend.direction="horizontal", legend.title = element_blank())
  
  plot = ggplotly(plot)
  output$grafico_vereadores_eleitos = renderPlotly({plot})
}