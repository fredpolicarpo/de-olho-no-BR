dashDespesas = tabItem(
  tabName = "despesas",
  fluidRow(
    height = 25,
    valueBoxOutput("total_despesa"),
    infoBoxOutput("despesa_media"),
    infoBoxOutput("partido_maior_despesa")
  ),
  fluidRow(column(
    12,
    radioButtons(
      "filtros",
      "",
      choices = list("Exibir Tudo", "Top 5 partidos", "Filtrar Dados"),
      selected = "Exibir Tudo"
    )
  )),
  fluidRow(
    conditionalPanel(condition = "input.filtros == 'Filtrar Dados'",
                     column(
                       6,
                       selectInput(
                         "filtroPartidos",
                         "",
                         choices = c("Selecione os partidos.." = ""),
                         multiple = T
                       )
                     )),
    conditionalPanel(condition = "input.filtros == 'Filtrar Dados' || input.filtros == 'Top 5 partidos'",
                     column(
                       6,
                       selectInput(
                         "filtroCargos",
                         "",
                         choices = c("Selecione os cargos.." = ""),
                         multiple = T
                       )
                     ))
  ),
  
  fluidRow(
    box(
      title = "Despesa média por candidato desde 1998",
      collapsible = TRUE,
      width = 6,
      plotOutput("grafico_despesa_media_cargo")
    ),
    box(
      title = "Despesa total por cargo desde 1998",
      collapsible = TRUE,
      width = 6,
      plotOutput("grafico_despesa_total_cargo")
    )
  ),
  fluidRow(
    box(
      title = "Despesas nas eleições federativas",
      collapsible = TRUE,
      width = 6,
      plotOutput("grafico_despesa_por_eleicao_federativa")
    ),
    box(
      title = "Despesas nas eleições locais",
      collapsible = TRUE,
      width = 6,
      plotOutput("grafico_despesa_por_eleicao_local")
    )
  )
)
