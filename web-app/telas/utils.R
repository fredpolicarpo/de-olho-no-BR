require(plotly)

grafico_barras_horizontais = function(x, y, sufixo = "") {
  options(repr.plot.width = 8, repr.plot.height = 6)
  
  y = reorder(y, x)
  
  destaque = c('rgba(222,45,38,0.6)')
  cinzas = rep('rgba(204,204,204,1)', length(y) - 1)
  marker = list(color = c(destaque, cinzas))
  
  
  plot = plot_ly(y = y, 
                 x = x,  
                 hoverinfo = 'text',
                 text =  paste0(y,": ", numero(x), sufixo),
                 marker = marker,
                 type = 'bar', 
                 color = 'gray10',
                 textposition = 'auto',
                 orientation = 'h') %>% 
    layout(yaxis = list(showgrid = FALSE, 
                        showline = FALSE, 
                        showticklabels = F),
           xaxis = list(zeroline = FALSE, 
                        showline = FALSE, 
                        showticklabels = F, 
                        title="",
                        showgrid = F))
  
  return(plot)
}

