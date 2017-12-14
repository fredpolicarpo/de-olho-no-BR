source("data-sources/data-source-candidatos.R")
source("utils.R")

library(ggplot2)

dados_despesa_eleicoes_cargo = function(output, input) {
  render_despesa_total_por_cargo(output, input)
  render_despesa_media_por_cargo(output, input)
}

# TODO: Adicionar quantidade de candidatos
render_despesa_total_por_cargo = function(output, input) {
  exibirPartidos = F
  
  if (!is.null(input$filtros) && input$filtros == "Top 5 partidos")  {
    dados_despesa_eleicoes_cargo = despesa_total_por_cargo_top_5(input$filtroCargos)
    exibirPartidos = T
  } else {
    dados_despesa_eleicoes_cargo = despesa_por_cargo(input$filtroPartidos, input$filtroCargos)  
    
    if (length(input$filtroPartidos) > 0) {
      exibirPartidos = T
    }
  }
  
  if (exibirPartidos) {
    plot = ggplot(dados_despesa_eleicoes_cargo,
                  aes(
                    x = reorder(DESCRICAO_CARGO,DESPESA),
                    y = DESPESA,
                    fill  = SIGLA_PARTIDO
                  )) +
      geom_bar(stat = "identity", position = "dodge") +
      xlab('') + 
      geom_label(aes(label = paste(SIGLA_PARTIDO, dinheiro(DESPESA)),  alpha=0.1), check_overlap=T,  position = position_dodge(width=0.9)) +
      theme(
        legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()
      ) +
      coord_flip() 
  } else {
    #Destaca a categoria de maior despesa
    dados_despesa_eleicoes_cargo$cor = dados_despesa_eleicoes_cargo$DESPESA == max(dados_despesa_eleicoes_cargo$DESPESA)
    
    plot = ggplot(dados_despesa_eleicoes_cargo,
                  aes(
                    x = reorder(DESCRICAO_CARGO,DESPESA),
                    y = DESPESA,
                    fill  = cor
                  )) +
      geom_bar(stat = "identity") +
      xlab('') + 
      geom_label(aes(label = dinheiro(DESPESA),  alpha=0.1), check_overlap=T)+
      scale_fill_manual(values = c('#A89694', '#dd4b39'))  +
      theme(
        legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()
      ) +
      coord_flip() 
  }
  
  output$grafico_despesa_total_cargo = renderPlot({plot})
}

render_despesa_media_por_cargo = function(output, input) {
  exibirPartidos = F
  
  if (!is.null(input$filtros) &&input$filtros == "Top 5 partidos")  {
    despesa_media_por_cargo = despesa_media_por_cargo_top_5(input$filtroCargos)
    exibirPartidos = T
  } else {
    despesa_media_por_cargo = despesa_media_por_cargo(input$filtroPartidos, input$filtroCargos)
    
    if (length(input$filtroPartidos) > 0) {
      exibirPartidos = T
    }
  }
  
  if (exibirPartidos) {
    plot = ggplot(despesa_media_por_cargo,
                  aes(
                    x = reorder(DESCRICAO_CARGO, DESPESA),
                    y = DESPESA,
                    fill  = SIGLA_PARTIDO
                  )) +
      geom_bar(stat = "identity", position = "dodge") +
      xlab('') + 
      geom_label(aes(label = paste(SIGLA_PARTIDO, dinheiro(DESPESA)),  alpha=0.1), check_overlap=T,  position = position_dodge(width=0.9)) +
      theme(
        legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()
      ) +
      coord_flip() 
  } else {
    #Destaca a categoria de maior despesa
    despesa_media_por_cargo$cor = despesa_media_por_cargo$DESPESA == max(despesa_media_por_cargo$DESPESA)
    
    plot = ggplot(despesa_media_por_cargo,
                  aes(
                    x = reorder(DESCRICAO_CARGO,DESPESA),
                    y = DESPESA,
                    fill  = cor
                  )) +
      geom_bar(stat = "identity") +
      xlab('') + 
      geom_label(aes(label = dinheiro(DESPESA),  alpha=0.1), check_overlap=T)+
      scale_fill_manual(values = c('#A89694', '#dd4b39'))  +
      theme(
        legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()
      ) +
      coord_flip() 
  }
  
  
  output$grafico_despesa_media_cargo = renderPlot({plot})
}
