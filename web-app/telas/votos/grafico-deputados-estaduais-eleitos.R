source("data-source/votos.R")
source("utils.R")

dados_deputados_estaduais_eleitos = function(con, output, input) {
  ufs = input$selectUfsDeputadosEstaduaisEleitos
  
  dados = deputados_estaduais_eleitos(con, ufs)
  
  if (length(dados) == 0) {
    showNotification("Dados de deputados estaduais não encontrados para esse filtro", type="warning")
    return()
  }
  
  y_values = seq(from = min(dados$qtde_votos), 
                 to=max(dados$qtde_votos), 
                 by=(round(mean(dados$qtde_votos)/5)))
  
  if (length(dados) == 0) {
    return()
  }
  
  plot =   ggplot(dados,
                  aes(x = ano_eleicao,
                      y = qtde_votos,
                      col=sigla_uf)) +
    geom_line(se = F) +
    geom_text(aes(label = nome_candidato), size=3)+
    geom_point(aes(text = paste0(nome_candidato, "\n", sigla_partido, "\n", numero(qtde_votos), " votos"),
                   col=sigla_uf)) +
    ylab("Quantidade de Votos") +
    xlab("Ano Eleição")  +
    scale_x_continuous(breaks = dados$ano_eleicao) +
    scale_y_continuous(breaks = y_values, labels = numero(y_values))+
    coord_cartesian(ylim = c(0, max(dados$qtde_votos))) +
    theme(legend.position = "top", legend.direction="horizontal", legend.title = element_blank())
  
  plot = ggplotly(plot)
  output$grafico_deputados_estaduais_eleitos = renderPlotly({plot})
}