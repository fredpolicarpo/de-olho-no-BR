require(glue)

source("data-source/manchetes.R")

dados_manchetes_partidos = function(con, output, input) {
  anos = input$selectAnoEleicaoManchetesPartidos
  
  manchetes_partidos_df = manchetes_partidos(con, anos)
  
  geral_partidos(manchetes_partidos_df, output)
}

geral_partidos = function(manchetes_partidos_df, output) {
  mais_elegeu = manchetes_partidos_df[manchetes_partidos_df$total_partido == max(manchetes_partidos_df$total_partido), ]
  menos_elegeu = manchetes_partidos_df[manchetes_partidos_df$total_partido == min(manchetes_partidos_df$total_partido), ]
  
  if (nrow(mais_elegeu) > 1) {
    texto_mais_elegeu = glue('<span style="font-size:30px"><strong>{paste(mais_elegeu$sigla_partido, collapse=","}</strong></span> foram os partidos
                            que <strong>mais elegeram</strong> candidatos.
                            <span style="font-size:30px">{numero(mais_elegeu$total_partido)}</span> candidatos eleitos, 
                            contabilizando <span style="font-size:30px"><strong>{mais_elegeu$porcentagem}%</strong></span> do total.')
  } else {
    texto_mais_elegeu = glue('<span style="font-size:30px"><strong>{mais_elegeu$sigla_partido}</strong></span> foi os partido
                            que <strong>mais elegeu</strong> candidatos.
                            <span style="font-size:30px">{numero(mais_elegeu$total_partido)}</span> candidatos eleitos, 
                            contabilizando <span style="font-size:30px"><strong>{mais_elegeu$porcentagem}%</strong></span> do total.') 
  }
  
  if (nrow(menos_elegeu) > 1) {
    texto_menos_elegeu = glue('<span style="font-size:20px"><strong>{paste(menos_elegeu$sigla_partido, collapse=",")}</strong></span> foram os partidos 
                             que <strong>menos elegeram</strong> candidatos.
                             <span style="font-size:20px">{numero(menos_elegeu$total_partido[1])}</span> candidato(s) eleito(s),
                             contabilizando <span style="font-size:20px"><strong>{menos_elegeu$porcentagem[1]}%</strong></span> do total.')
    
  } else {
    texto_menos_elegeu = glue('<span style="font-size:20px"><strong>{menos_elegeu$sigla_partido}</strong></span> foi o partido 
                             que <strong>menos elegeu</strong> candidatos.
                             <span style="font-size:20px">{numero(menos_elegeu$total_partido)}</span> candidato(s) eleito(s),
                             contabilizando <span style="font-size:20px"><strong>{menos_elegeu$porcentagem}%</strong></span> do total.')
  }
  
  texto_mais_elegeu = glue("<p style='margin-left:20px'>{texto_mais_elegeu}</p>")  
  
  texto_menos_elegeu = glue("<p style='margin-left:20px'>{texto_menos_elegeu}</p>")
  
  output$tops_partidos = renderUI({ 
    fluidRow(
      tags$div(HTML(texto_mais_elegeu), style="margin-left: 30px"),
      tags$hr(),
      tags$div(HTML(texto_menos_elegeu), style="margin-left: 30px"))
  })
}