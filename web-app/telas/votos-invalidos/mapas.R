source("data-source/db-connector.R")
source("data-source/votos-invalidos.R")
source("utils.R")

mapaUF = readOGR("mapas/estados_2010/estados_2010.shp")
colfunc <- colorRampPalette(c("white", "darkred"))

mapa_votos_invalidos = function(con, output, input) {
  ano = input$selectAnoEleicaoVotosInvalidos
  
  mapa_brancos(con, output, ano)
  mapa_nulos(con, output, ano)
  mapa_abstencoes(con, output, ano)
  mapa_geral(con, output, ano)
}

mapa_brancos = function(con, output, ano) {
  dados = votos_brancos_uf(con, ano) 
  
  dados_organizados = organiza_dados(dados)
  
  # Plotando mapa
  output$mapa_brancos = renderPlot({ plota_mapa(dados_organizados, ano)})
}

mapa_nulos = function(con, output, ano) {
  dados = votos_nulos_uf(con, ano) 
  
  dados_organizados = organiza_dados(dados)
  
  # Plotando mapa
  output$mapa_nulos = renderPlot({ plota_mapa(dados_organizados, ano)})
}

mapa_abstencoes = function(con, output, ano) {
  dados = votos_abstencoes_uf(con, ano) 
  
  dados_organizados = organiza_dados(dados)
  
  # Plotando mapa
  output$mapa_abstencoes = renderPlot({ plota_mapa(dados_organizados, ano)})
}

mapa_geral= function(con, output, ano) {
  dados = votos_invalidos_uf(con, ano) 
  
  dados_organizados = organiza_dados(dados)

  # Plotando mapa
  output$mapa_votos_invalidos = renderPlot({ plota_mapa(dados_organizados, ano)})
}

plota_mapa = function(dados_organizados, ano) {
  parDefault = par(no.readonly = T)
  layout(matrix(c(1, 2), nrow = 2),
         widths = c(1, 1),
         heights = c(4, 1))
  par (mar = c(0, 0, 0, 0))
  plot(mapaUF, col = as.character(dados_organizados[['mapaData']]$Cores))
  plot(1, 1, pch = NA, axes = F)
  legend(
    x = 'center',
    legend = dados_organizados[['legenda']],
    box.lty = 0,
    fill = dados_organizados[['paleta']],
    ncol = 2,
    title = paste('Eleição de', ano)
  ) 
}

organiza_dados = function(dados) {
  totais_unique = dados$total %>% 
    unique() %>% 
    sort()
  
  paletaDeCores = totais_unique %>% 
    length() %>%
    colfunc()
  
  # Agora fazemos um pareamento entre as faixas da variável sobre PIB (categórica) e as cores:
  totais_cat = factor(numero(totais_unique), levels = numero(totais_unique))
  cores = data.frame(total = totais_unique, Cores = paletaDeCores)
  dados_cores = inner_join(dados, cores)
  
  mapaData = attr(mapaUF, 'data') %>%
    rename(uf = sigla) %>%
    inner_join(dados_cores, by = "uf")
  
  legenda_max = levels(totais_cat) %>% last()
  legenda_min = levels(totais_cat) %>% first()
  
  legenda = paste(c(legenda_min, legenda_max),"%")
  paleta = c(first(paletaDeCores), last(paletaDeCores))
  
  result = list(mapaData = mapaData, paleta = paleta, legenda = legenda)
  
  return (result)
}