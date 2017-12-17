presidentes = fluidRow(
  box(
    title = "Votos dos presidentes eleitos",
    collapsible = TRUE,
    width = 12,
    plotlyOutput("grafico_presidentes_eleitos")
  )
)

governadores = fluidRow(
  box(
    solidHeader = F,
    collapsible = F,
    width=12,
    selectInput(
      "selectUfsGovernadoresEleitos",
      "",
      selected = 'SP',
      choices = c("Escolha a(s) uf(s)" = "", ufs),
      multiple = T
    ),
    box(
      title = "Votos dos governadores eleitos",
      collapsible = TRUE,
      solidHeader = F,
      width = 12,
      plotlyOutput("grafico_governadores_eleitos")
    )
  )
)

senadores =  fluidRow(
  box(
    solidHeader = F,
    collapsible = F,
    width=12,
    selectInput(
      "selectUfsSenadoresEleitos",
      "",
      selected = 'SP',
      choices = c("Escolha a(s) uf(s)" = "", ufs),
      multiple = T
    ),
    box(
      title = "Votos dos senadores eleitos",
      collapsible = TRUE,
      solidHeader = F,
      width = 12,
      plotlyOutput("grafico_senadores_eleitos")
    )
  )
)

deputados_federais =  fluidRow(
  box(
    solidHeader = F,
    collapsible = F,
    width=12,
    selectInput(
      "selectUfsDeputadosFederaisEleitos",
      "",
      selected = 'SP',
      choices = c("Escolha a(s) uf(s)" = "", ufs),
      multiple = T
    ),
    box(
      title = "Votos dos deputados federais eleitos",
      collapsible = TRUE,
      solidHeader = F,
      width = 12,
      plotlyOutput("grafico_deputados_federais_eleitos")
    )
  )
)

deputados_estaduais =  fluidRow(
  box(
    solidHeader = F,
    collapsible = F,
    width=12,
    selectInput(
      "selectUfsDeputadosEstaduaisEleitos",
      "",
      selected = 'SP',
      choices = c("Escolha a(s) uf(s)" = "", ufs),
      multiple = T
    ),
    box(
      title = "Votos dos deputados estaduais eleitos",
      collapsible = TRUE,
      solidHeader = F,
      width = 12,
      plotlyOutput("grafico_deputados_estaduais_eleitos")
    )
  )
)

prefeitos = fluidRow(
  box(
    title = 'Votos dos prefeitos eleitos',
    width = 12,
    solidHeader = F,
    collapsible = F,
    fluidRow(column(
      6,
      selectInput(
        "selectUfsPrefeitosEleitos",
        "",
        choices = c("Selecione a(s) uf(s).." = '', ufs),
        multiple = T
      )),
      column(
        6,
        selectInput(
          "selectCidadesPrefeitosEleitos",
          "",
          choices = c("Selecione a(s) cidade(s).." = ""),
          multiple = T
        )
      )),
    plotlyOutput("grafico_prefeitos_eleitos")
  )
)


vereadores = fluidRow(
  box(
    title = 'Votos dos vereadores eleitos',
    width = 12,
    solidHeader = F,
    collapsible = F,
    fluidRow(column(
      6,
      selectInput(
        "selectUfsVereadoresEleitos",
        "",
        choices = c("Selecione a(s) uf(s).." = '', ufs),
        multiple = T
      )),
      column(
        6,
        selectInput(
          "selectCidadesVereadoresEleitos",
          "",
          choices = c("Selecione a(s) cidade(s).." = ""),
          multiple = T
        )
      )),
    plotlyOutput("grafico_vereadores_eleitos")
  )
)

dashVotos = tabItem(
  tabName = "votos",
  tags$div(
    HTML(
      "<span style='color:#848484'>Para dados analíticos sobre votos acesse <a href='http://cepesp.io/consulta/votos'>http://cepesp.io/consulta/votos</a>.</span>"
      )
    ),
  tags$br(),
  presidentes,
  governadores,
  senadores,
  deputados_federais,
  deputados_estaduais,
  prefeitos
  #vereadores - Não utilizado pois a API do Cepesp não suporta obter os dados da forma que estamos fazendo - Buscar outra forma
)
