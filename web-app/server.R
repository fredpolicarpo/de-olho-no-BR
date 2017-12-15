options(warn=-1)
options(scipen=999)
options(warn.conflicts = FALSE)

source("config/install-r-libraries.R")

source("config/settings.R")
source("config/api-params.R")

source("data-source/legendas.R")
source("data-source/votos-invalidos.R")

source("telas/manchetes/genero.R")
source("telas/manchetes/grau_instrucao.R")
source("telas/manchetes/top_10_ocupacoes.R")
source("telas/manchetes/turnos.R")
source("telas/manchetes/partidos.R")
source("telas/manchetes/aproveitamento_partidos.R")

source("telas/legendas/grafico_total_partidos_ano.R")
source("telas/legendas/grafico_total_coligacoes_ano.R")
source("telas/legendas/grafico_total_candidatos_ano.R")
source("telas/legendas/mapas.R")

source("telas/votos/grafico-presidentes-eleitos.R")
source("telas/votos/grafico-governadores-eleitos.R")
source("telas/votos/grafico-senadores-eleitos.R")
source("telas/votos/grafico-deputados-federais-eleitos.R")
source("telas/votos/grafico-deputados-estaduais-eleitos.R")
source("telas/votos/grafico-prefeitos-eleitos.R")
source("telas/votos/grafico-vereadores-eleitos.R")
source("telas/votos/filtros.R")

source("telas/votos-invalidos/mapas.R")
source("telas/votos-invalidos/grafico-votos-invalidos.R")

source("utils.R")

con = getCon()

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  #Legendas
  dados_total_candidatos_ano(con, output)
  dados_total_partidos_ano(con, output)
  dados_total_coligacoes_ano(con, output)
  
  #Eleitos
  dados_presidentes_eleitos(con, output)
  
  # Votos inválidos
  dados_votos_invalidos(con, output)
  
  observe({
    #Manchetes
    dados_grau_instrucao(con, output, input)
    dados_top_10_ocupacoes(con, output, input)
    dados_manchetes_turno(con, output, input)
    dados_manchetes_genero(con, output, input)
    dados_manchetes_partidos(con, output, input)
    dados_aproveitamento_partidos(con, output, input)
    
    mapa_qtd_partidos(con, output, input)
    mapa_qtd_coligacoes(con, output, input)
    
    mapa_votos_invalidos(con, output, input)
    
    dados_governadores_eleitos(con, output,input)
    dados_senadores_eleitos(con, output, input)
    dados_deputados_federais_eleitos(con, output, input)
    dados_deputados_estaduais_eleitos(con, output, input)
    
    carregaFiltroCidadesPrefeitosEleitos(session, input, con)
    dados_prefeitos_eleitos(con, output, input)
    
    carregaFiltroCidadesVereadoresEleitos(session, input, con)
    dados_vereadores_eleitos(con, output, input)
  })
})
