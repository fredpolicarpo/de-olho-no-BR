source("data-source/legendas.R")
source("utils.R")

dados_total_partidos_ano= function(con, output) {
  dados = total_partidos_ano(con)
  
  dados_eleicoes_locais = dados[dados$tipo_eleicoes == "local",]
  dados_eleicoes_federativas = dados[dados$tipo_eleicoes == "federativa",]
  
  y_values = seq(from = min(dados_eleicoes_locais$total), 
                 to=max(dados_eleicoes_locais$total), 
                 by=(round(mean(dados_eleicoes_locais$total)/10)))
  
  plot_locais =   ggplot(dados_eleicoes_locais,
                         aes(x = ano_eleicao,
                             y = total)) +
    geom_line(color="green") +
    ylab("") +
    xlab("Ano Eleição")  +
    scale_x_continuous(breaks = dados_eleicoes_locais$ano_eleicao) +
    scale_y_continuous(breaks = y_values, labels = numero(y_values))+
    theme(
      legend.position = "none"
    )
  plot_locais = ggplotly(plot_locais)
  output$grafico_total_partidos_eleicoes_locais_ano = renderPlotly({plot_locais})
  
  y_values_eleicoes_federativas = seq(from = min(dados_eleicoes_federativas$total), 
                                      to=max(dados_eleicoes_federativas$total), 
                                      by=(round(mean(dados_eleicoes_federativas$total)/10)))
  
  plot_federativas =   ggplot(dados_eleicoes_federativas,
                              aes(x = ano_eleicao,
                                  y = total)) +
    geom_line(color="green") +
    ylab("") +
    xlab("Ano Eleição")  +
    scale_x_continuous(breaks = dados_eleicoes_federativas$ano_eleicao) +
    scale_y_continuous(breaks = y_values_eleicoes_federativas, labels = numero(y_values_eleicoes_federativas))+
    theme(
      legend.position = "none"
    )
  plot_federativas = ggplotly(plot_federativas)
  output$grafico_total_partidos_eleicoes_federativas_ano = renderPlotly({plot_federativas})
}