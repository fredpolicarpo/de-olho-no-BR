source("data-source/manchetes.R")

dados_aproveitamento_partidos = function(con, output, input) {
  anos = input$selectAnoEleicaoManchetesPartidos
  
  aproveitamento_partidos_df = manchetes_aproveitamento_partidos(con, anos)
  
  monte_aproveitamento_partidos(aproveitamento_partidos_df, output)
}

monte_aproveitamento_partidos = function(aproveitamento_partidos_df, output) {
  melhor = aproveitamento_partidos_df[aproveitamento_partidos_df$porcentagem == max(aproveitamento_partidos_df$porcentagem), ]
  pior = aproveitamento_partidos_df[aproveitamento_partidos_df$porcentagem == min(aproveitamento_partidos_df$porcentagem), ]
  
  if (nrow(melhor) > 1) {
    texto_melhor = glue('<span style="font-size:30px"><strong>{paste(melhor$sigla_partido, collapse=",")}</strong></span> foram os partidos
                             com <strong>melhor aprovietamento</strong> nas eleições.
                             <span style="font-size:30px"><strong>{melhor$porcentagem}%</strong></span> dos seus candidatos foram eleitos.')
  } else {
    texto_melhor = glue('<span style="font-size:30px"><strong>{melhor$sigla_partido}</strong></span> foi o partido
                             com <strong>melhor aprovietamento</strong> nas eleições.
                             <span style="font-size:30px"><strong>{melhor$porcentagem}%</strong></span> dos seus candidatos foram eleitos.')
  }
  
  if (nrow(pior) > 1) {
    texto_pior = glue('<span style="font-size:20px"><strong>{paste(pior$sigla_partido, collapse=",")}</strong></span> foram os partidos
                             com <strong>melhor aprovietamento</strong> nas eleições.
                             <span style="font-size:20px"><strong>{pior$porcentagem}%</strong></span> dos seus candidatos foram eleitos.')
    
  } else {
    texto_pior = glue('<span style="font-size:20px"><strong>{paste(pior$sigla_partido, collapse=",")}</strong></span> foi o partido
                             com <strong>pior aprovietamento</strong> nas eleições.
                             <span style="font-size:20px"><strong>{pior$porcentagem}%</strong></span> dos seus candidatos foram eleitos.')
  }
  
  texto_melhor = glue("<p style='margin-left:20px'>{texto_melhor}</p>")  
  
  texto_pior = glue("<p style='margin-left:20px'>{texto_pior}</p>")
  
  output$aproveitamento_partidos = renderUI({ 
    fluidRow(
      tags$div(HTML(texto_melhor), style="margin-left: 30px"),
      tags$hr(),
      tags$div(HTML(texto_pior), style="margin-left: 30px"))
  })
}