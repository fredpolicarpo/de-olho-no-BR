require(glue)

source("data-source/manchetes.R")

dados_manchetes_genero = function(con, output, input) {
  anos = input$selectAnoEleicaoManchetesGenero
  
  manchetes_genero_df = manchetes_genero(con, anos)
  
  monta_geral_genero(manchetes_genero_df, output)
  monta_tops_ufs_generos(manchetes_genero_df, output)
  monta_tops_10_generos(manchetes_genero_df, output)
  monta_tops_cargos_generos(manchetes_genero_df, output)
  monta_proporcao_cargos_generos(manchetes_genero_df, output)
}

monta_tops_10_generos = function(manchetes_genero, output) {
  tops_10_m =  manchetes_genero$top_10_m_uf
  
  tops_10_f =  manchetes_genero$top_10_f_uf
  
  plo_f = grafico_barras_horizontais(tops_10_f$porcent, tops_10_f$uf, "%")
  
  plo_m = grafico_barras_horizontais(tops_10_m$porcent, tops_10_m$uf, "%")
  
  output$tops_10_feminino = renderPlotly({plo_f})
  output$tops_10_masculino = renderPlotly({plo_m})
}

monta_tops_ufs_generos = function(manchetes_genero, output) {
  top_m = manchetes_genero$top_m_uf
  estado_m = top_m$uf
  porcent_m = top_m$porcent
  
  top_f = manchetes_genero$top_f_uf
  estado_f = top_f$uf
  porcent_f = top_f$porcent
  
  texto_m = glue('<span style="font-size:30px">{estado_m}</span> foi o estado que <span style="font-size:30px">mais elegeu <strong>homens</strong></span> proporcionalmente 
                  com <span style="font-size:30px"><strong>{porcent_m}%</strong></span> de candidatos eleitos do sexo masculino.')
  
  texto_m = glue("<p style='margin-left:20px'>{texto_m}</p>")
  
  texto_f = glue('<span style="font-size:30px">{estado_f}</span> foi o estado que <span style="font-size:30px">mais elegeu <strong>mulheres</strong></span> proporcionalmente 
                  com <span style="font-size:30px"><strong>{porcent_f}%</strong></span> de candidatas eleitas do sexo feminino.')
  
  texto_f = glue("<p style='margin-left:20px'>{texto_f}</p>")
  
  output$tops_ufs_generos = renderUI({
    fluidRow(
      tags$div(HTML(texto_f), style="margin-left: 30px"),
      tags$hr(),
      tags$div(HTML(texto_m), style="margin-left: 30px")
    )
  })
}

monta_geral_genero = function(manchetes_genero, output) {
  mulheres_eleitas = manchetes_genero$geral %>%
    filter(descricao_sexo == 'FEMININO') %>%
    select(porcent_sexo)
  
  mulheres_eleitas = mulheres_eleitas$porcent_sexo
  
  homens_eleitos = manchetes_genero$geral %>%
    filter(descricao_sexo == 'MASCULINO') %>%
    select(porcent_sexo)
  
  homens_eleitos = homens_eleitos$porcent_sexo
  
  nao_informado = round(100 - homens_eleitos - mulheres_eleitas, 2)
  
  texto = glue('<span style="font-size:30px"><strong>{homens_eleitos}%</strong></span> de candidatos eleitos se declaram do <span style="font-size:30px">sexo masculino</span>, 
             e <span style="font-size:20px"><strong>{mulheres_eleitas}%</strong></span> de candiatas eleitas se declaram do <span style="font-size:20px">sexo feminino</span>.
             <br /><span style="font-style: italic">{nao_informado}% dos candidatos eleitos não informaram o sexo.</span>')
  
  texto = glue("<p style='margin-left:20px'>{texto}</p>")
  
  output$geral_genero = renderUI({fluidRow(tags$div(HTML(texto),style="margin-left: 30px"))})
}

monta_tops_cargos_generos = function(manchetes_genero, output) {
  top_cargo_m = manchetes_genero$top_cargo_m[1, ]
  top_cargo_f = manchetes_genero$top_cargo_f[1, ]
  
  texto_m = glue('<span style="font-size:30px">{top_cargo_m$cargo}</span> foi o cargo que <span style="font-size:30px">mais elegeu <strong>homens</strong></span> proporcionalmente 
                  onde <span style="font-size:30px"><strong>{top_cargo_m$porcent}%</strong></span>
                  dos candidatos eleitos se declaram do sexo masculino.')
  
  texto_m = glue("<p style='margin-left:20px'>{texto_m}</p>")
  
  texto_f = glue('<span style="font-size:30px">{top_cargo_f$cargo}</span> foi o cargo que <span style="font-size:30px">mais elegeu <strong>mulheres</strong></span> proporcionalmente 
                  onde <span style="font-size:30px"><strong>{top_cargo_f$porcent}%</strong></span>
                  das candidatas eleitas se declaram do sexo feminino.')
  
  texto_f = glue("<p style='margin-left:20px'>{texto_f}</p>")
  
  output$tops_cargos_generos = renderUI({
    fluidRow(
      tags$div(HTML(texto_f), style="margin-left: 30px"),
      tags$hr(),
      tags$div(HTML(texto_m), style="margin-left: 30px")
    )
  })
}

monta_proporcao_cargos_generos = function(manchetes_genero, output) {
  prop_cargo_m = manchetes_genero$top_cargo_m
  prop_cargo_f = manchetes_genero$top_cargo_f
  
  plo_f = grafico_barras_horizontais(prop_cargo_f$porcent, prop_cargo_f$cargo, "%")
  
  plo_m = grafico_barras_horizontais(prop_cargo_m$porcent, prop_cargo_m$cargo, "%")
  
  output$mulheres_eleitas_cargo = renderPlotly({plo_f})
  output$homens_eleitos_cargo = renderPlotly({plo_m})
}