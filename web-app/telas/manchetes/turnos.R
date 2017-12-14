require(glue)

source("data-source/manchetes.R")

dados_manchetes_turno = function(con, output, input) {
  anos = input$selectAnoEleicaoManchetesOutrasEstatisticas
  
  manchetes_turnos = manchetes_turnos(con, anos)
  
  geral_turnos(manchetes_turnos, output)
}

geral_turnos = function(manchetes_turnos, output) {
  porcent_1_turno = manchetes_turnos[manchetes_turnos$num_turno == 1, ]$porcentagem[1]
  porcent_2_turno = manchetes_turnos[manchetes_turnos$num_turno == 2, ]$porcentagem[1]
  
  texto = glue('Desde 1998 <span style="font-size:30px"><strong>{porcent_1_turno}%</strong></span>  das eleiçõe para cargos do executivo 
                 foram decididas no <span style="font-size:30px">1° turno</span>
                 e apenas <span style="font-size:20px"><strong>{porcent_2_turno}%</strong></span> foram decididas no <span style="font-size:20px">2° turno</span>')
  
  texto = glue("<p style='margin-left:20px'>{texto}</p>")
  
  output$tops_turnos = renderUI({ fluidRow(tags$div(HTML(texto), style="margin-left: 30px"))})
}