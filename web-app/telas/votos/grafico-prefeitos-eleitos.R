source("data-source/votos.R")
source("utils.R")

dados_prefeitos_eleitos = function(con, output, input) {
  if (is.null(input$selectUfsPrefeitosEleitos) || is.null(input$selectCidadesPrefeitosEleitos)) {
    return()
  }
  
  ufs =  input$selectUfsPrefeitosEleitos
  cidades = input$selectCidadesPrefeitosEleitos
  
  dados = prefeitos_eleitos(con,ufs, cidades)
  
  if (length(dados) == 0) {
    showNotification("Dados de prefeitos não encontrados para esse filtro", type="warning")
    return()
  }
  
  step = round((max(dados$qtde_votos) - min(dados$qtde_votos)) / 10)
  y_values = seq(from = min(dados$qtde_votos), to=max(dados$qtde_votos), by=step)  
  
  plot =   ggplot(dados,
                  aes(x = ano_eleicao,
                      y = qtde_votos,
                      col=descricao_ue)) +
    geom_line() +
    geom_point(aes(text = paste0(nome_candidato, "\n", sigla_partido, "\n", num_turno, "° turno\n", numero(qtde_votos), " votos"))) +
    ylab("") +
    xlab("Ano Eleição")  +
    scale_x_continuous(breaks = dados$ano_eleicao) +
    scale_y_continuous(breaks = y_values, labels = numero(y_values))+
    theme(legend.position = "top", legend.direction="horizontal", legend.title = element_blank())
  
  plot = ggplotly(plot)
  output$grafico_prefeitos_eleitos = renderPlotly({plot})
}