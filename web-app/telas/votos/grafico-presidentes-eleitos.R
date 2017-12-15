source("data-source/votos.R")
source("utils.R")

dados_presidentes_eleitos = function(con, output) {
  dados = presidentes_eleitos(con)
  
  if (length(dados) == 0) {
    showNotification("Dados de presidentes não encontrados para esse filtro", type="warning")
    return()
  }
  
  y_values = seq(from = min(dados$qtde_votos), to=max(dados$qtde_votos), by=(mean(dados$qtde_votos)/10))
  
  plot =   ggplot(dados,
                  aes(x = ano_eleicao,
                      y = qtde_votos)) +
    geom_line(col = "green") +
    geom_point(col = "darkgreen", aes(text = paste0(nome_candidato, "\n", sigla_partido, "\n", num_turno, "° turno\n", numero(qtde_votos), " votos"))) +
    ylab("") +
    xlab("Ano Eleição")  +
    scale_x_continuous(breaks = dados$ano_eleicao) +
    scale_y_continuous(breaks = y_values, labels = numero(y_values))+
    theme(
      legend.position = "none"
    ) 
  
  plot = ggplotly(plot)
  output$grafico_presidentes_eleitos = renderPlotly({plot})
}