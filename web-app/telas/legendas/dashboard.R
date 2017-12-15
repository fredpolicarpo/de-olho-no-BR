source("config/api-params.R")

quantidade_candidatos = fluidRow(
  box(
    title = "Quantidade de candidatos - Eleições Federativas" ,
    solidHeader = TRUE,
    collapsible = TRUE,
    width = 6,
    plotlyOutput("grafico_total_candidatos_ano_eleicoes_federativas", height = 400)
  ),
  box(
    title = "Quantidade de candidatos - Eleições Locais" ,
    solidHeader = TRUE,
    collapsible = TRUE,
    width = 6,
    plotlyOutput("grafico_total_candidatos_ano_eleicoes_locais", height = 400)
  )
)

quantidade_partidos = fluidRow(
  box(
    title = "Quantidade de partidos - Eleições Federativas" ,
    solidHeader = TRUE,
    collapsible = TRUE,
    width = 6,
    plotlyOutput("grafico_total_partidos_eleicoes_federativas_ano", height = 400)
  ),
  box(
    title = "Quantidade de partidos - Eleições Locais" ,
    solidHeader = TRUE,
    collapsible = TRUE,
    width = 6,
    plotlyOutput("grafico_total_partidos_eleicoes_locais_ano", height = 400)
  )
)

quantidade_coligacoes = fluidRow(
  box(
    title = "Quantidade de coligações - Eleições Federativas" ,
    solidHeader = TRUE,
    collapsible = TRUE,
    width = 6,
    plotlyOutput("grafico_coligacoes_eleicoes_federativas_ano", height = 400)
  ),
  box(
    title = "Quantidade de coligações - Eleições Locais" ,
    solidHeader = TRUE,
    collapsible = TRUE,
    width = 6,
    plotlyOutput("grafico_coligacoes_eleicoes_locais_ano", height = 400)
  )
)

mapa_partidos_coligacoes = fluidRow(
  box(
    solidHeader = F,
    collapsible = F,
    width=12,
    selectInput(
      "selectAnoEleicao",
      "",
      selected = 2008,
      choices = c("Escolha um ano" = "", anos_eleicoes_federativas, anos_eleicoes_municipais),
      multiple = F
    ),
    box(
      title = "Quantidade de partidos" ,
      solidHeader = TRUE,
      collapsible = TRUE,
      width = 6,
      plotOutput("mapa_qtde_partidos", height = 600)
    ),
    box(
      title = "Quantidade de coligações" ,
      solidHeader = TRUE,
      collapsible = TRUE,
      width = 6,
      plotOutput("mapa_qtde_coligacoes", height = 600)
    ))
)

dashLegendas = tabItem(
  tabName = "legendas",
  tags$div(
    HTML(
      "<span style='color:#848484'>Para dados analíticos sobre legendas acesse <a href='http://cepesp.io/consulta/votos'>http://cepesp.io/consulta/legendas</strong></a>.</span>"
    )
  ),
  tags$br(),
  quantidade_candidatos,
  quantidade_partidos,
  quantidade_coligacoes,
  mapa_partidos_coligacoes
)
