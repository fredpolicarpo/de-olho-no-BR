votos_invalidos = fluidRow(
  box(
    title = "Votos inválidos - Eleições Federativas" ,
    solidHeader = TRUE,
    collapsible = TRUE,
    width = 6,
    plotlyOutput("grafico_votos_invalidos_federativas")
  ),
  box(
    title = "Votos inválidos - Eleições Locais" ,
    solidHeader = TRUE,
    collapsible = TRUE,
    width = 6,
    plotlyOutput("grafico_votos_invalidos_locais")
  )
)

mapas = fluidRow(
  box(
    solidHeader = F,
    collapsible = F,
    width=12,
    selectInput(
      "selectAnoEleicaoVotosInvalidos",
      "",
      selected = 2008,
      choices = c("Escolha um ano" = "", anos_eleicoes),
      multiple = F
    ),
    box(
      title = "Votos brancos" ,
      solidHeader = TRUE,
      collapsible = TRUE,
      width = 4,
      plotOutput("mapa_brancos", height = 600)
    ),
    box(
      title = "Votos nulos" ,
      solidHeader = TRUE,
      collapsible = TRUE,
      width = 4,
      plotOutput("mapa_nulos", height = 600)
    ),
    box(
      title = "Abstenções" ,
      solidHeader = TRUE,
      collapsible = TRUE,
      width = 4,
      plotOutput("mapa_abstencoes", height = 600)
    ),
    box(
      title = "Geral de votos inválidos" ,
      solidHeader = TRUE,
      collapsible = TRUE,
      width = 12,
      plotOutput("mapa_votos_invalidos", height = 800)
    ))
)

dashVotosInvalidos = tabItem(
  tabName = "votosInvalidos",
  tags$div(
    HTML(
      "<span style='color:#848484'>Para dados analíticos sobre votos acesse <a href='http://cepesp.io/consulta/tse'>http://cepesp.io/consulta/tse</a>.</span>"
    )
  ),
  tags$br(),
  votos_invalidos,
  mapas
)
