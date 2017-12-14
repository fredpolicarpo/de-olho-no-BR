source("data-source/db-connector.R")
source("data-source/legendas.R")
source("utils.R")

require(XML)
require(RCurl)
require(maptools)
require(RColorBrewer)
require(plotly)
require(rgdal)

mapaUF = readOGR("mapas/estados_2010/estados_2010.shp")
colfunc <- colorRampPalette(c("white", "darkgreen"))

mapa_qtd_partidos = function(con, output, input) {
  ano = input$selectAnoEleicao
  
  dados = total_partidos_ano_estado(con, ano) %>% 
    select(sigla_uf, total) %>%
    rename(UF = sigla_uf)
  
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
                rename(UF = sigla) %>%
                inner_join(dados_cores, by = "UF")

  # Plotando mapa
  output$mapa_qtde_partidos = renderPlot({
    parDefault = par(no.readonly = T)
    layout(matrix(c(1, 2), nrow = 2),
           widths = c(1, 1),
           heights = c(4, 1))
    par (mar = c(0, 0, 0, 0))
    plot(mapaUF, col = as.character(mapaData$Cores))
    plot(1, 1, pch = NA, axes = F)
    legend(
      x = 'center',
      legend = rev((levels(totais_cat))),
      box.lty = 0,
      fill = rev(paletaDeCores),
      cex = .8,
      ncol = 4,
      title = paste('Elição de', ano)
    ) 
  })
}

mapa_qtd_coligacoes = function(con, output, input) {
  ano = input$selectAnoEleicao
  
  dados = total_coligacoes_ano_estado(con, ano) %>% 
            select(sigla_uf, total) %>%
            rename(UF = sigla_uf)
  
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
    rename(UF = sigla) %>%
    inner_join(dados_cores, by = "UF")
  
  # Plotando mapa
  output$mapa_qtde_coligacoes = renderPlot({
    parDefault = par(no.readonly = T)
    layout(matrix(c(1, 2), nrow = 2),
           widths = c(1, 1),
           heights = c(4, 1))
    par (mar = c(0, 0, 0, 0))
    plot(mapaUF, col = as.character(mapaData$Cores))
    plot(1, 1, pch = NA, axes = F)
    legend(
      x = 'center',
      legend = rev((levels(totais_cat))),
      box.lty = 0,
      fill = rev(paletaDeCores),
      cex = .8,
      ncol = 4,
      title = paste('Elição de', ano)
    ) 
  })
}
