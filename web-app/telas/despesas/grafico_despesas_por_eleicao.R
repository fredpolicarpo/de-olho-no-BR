source("data-sources/data-source-candidatos.R")
source("utils.R")
source("config/api-params.R")

dados_despesa_por_eleicao = function(output, input) {
  dados_despesa_por_eleicao = despesa_por_eleicao(input$filtroPartidos)
  
  exibir_geral = length(input$filtroPartidos) == 0
  
  dados_eleicoes_federativas = dados_despesa_por_eleicao %>%
    filter(as.integer(as.character(ANO_ELEICAO))  %in% anos_eleicoes_federativas)
  
  dados_eleicoes_locais = dados_despesa_por_eleicao %>%
    filter(as.integer(as.character(ANO_ELEICAO))  %in% anos_eleicoes_municipais)
  
  dados_despesa_por_eleicao_federativa(output, dados_eleicoes_federativas, exibir_geral)
  dados_despesa_por_eleicao_local(output, dados_eleicoes_locais, exibir_geral)
}

dados_despesa_por_eleicao_federativa = function(output, dados, exibir_geral) {
  anos = as.integer(as.character(dados$ANO_ELEICAO))
  
  dados$DESPESA = round(dados$DESPESA / 1000000000, 2)
  
  if (exibir_geral) {
    plot =   ggplot(dados,
                    aes(x = anos,
                        y = DESPESA)) +
      geom_smooth(se = F) +
      ylab("Bilhões de R$") +
      xlab("Ano Eleição")  +
      scale_x_continuous(breaks = anos)
  } else {
    plot =   ggplot(dados,
                    aes(x = anos,
                        y = DESPESA,
                        col = SIGLA_PARTIDO)) +
      geom_smooth(se = F) +
      theme(legend.position = "top", legend.direction="horizontal", legend.title = element_blank()) +
      ylab("Bilhões de R$") +
      xlab("Ano Eleição")  +
      scale_x_continuous(breaks = anos) +
      theme(legend.position = "top")
  }
  
  
  output$grafico_despesa_por_eleicao_federativa = renderPlot({
    plot
  })
}

dados_despesa_por_eleicao_local = function(output, dados, exibir_geral) {
  anos = as.integer(as.character(dados$ANO_ELEICAO))
  
  dados$DESPESA = round(dados$DESPESA / 1000, 2)
  
  if (exibir_geral) {
    plot =     ggplot(dados,
                      aes(x = anos,
                          y = DESPESA)) +
      geom_smooth(se = F, method = "loess") +
      ylab("Bilhões de R$") +
      xlab("Ano Eleição")  +
      scale_x_continuous(breaks = anos)
  } else {
    plot =     ggplot(dados,
                      aes(x = anos,
                          y = DESPESA,
                          col = SIGLA_PARTIDO)) +
      geom_smooth(se = F, method = "loess") +
      theme(legend.position = "top", legend.direction="horizontal", legend.title = element_blank()) +
      ylab("Bilhões de R$") +
      xlab("Ano Eleição")  +
      scale_x_continuous(breaks = unique(anos))
  }
  
  output$grafico_despesa_por_eleicao_local = renderPlot({
    plot
  })
}
