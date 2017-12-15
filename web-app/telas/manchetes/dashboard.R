source("config/api-params.R")

anos_eleicoes = c(anos_eleicoes_federativas, anos_eleicoes_municipais) %>%
  sort()

generos =  fluidRow(
  box(
    title = "Distribuição de gênero entre os candidatos eleitos",
    solidHeader = TRUE,
    collapsible = TRUE,
    width = 12,
    helpText("Dados gerados para os anos de eleições selecionados abaixo..."),
    selectInput(
      "selectAnoEleicaoManchetesGenero",
      "",
      selected = anos_eleicoes,
      choices = c("Exibindo dados para todas as eleições. Filtre anos específicos..." = "", anos_eleicoes),
      multiple = T
    ),
    uiOutput("geral_genero", inline = FALSE),
    tags$hr(),
    uiOutput("tops_ufs_generos", inline = FALSE),
    tags$hr(),
    uiOutput("tops_cargos_generos", inline = FALSE),
    tags$hr(),
    column(6,
           h3("Top 10 estados que elegem mais mulheres"),
           plotlyOutput("tops_10_feminino", inline = FALSE)
    ),
    column(6,
           h3("Top 10 estados que elegem mais homens"),
           plotlyOutput("tops_10_masculino", inline = FALSE)  
    ),
    column(6,
           h3("Proporção de mulheres eleitas por cargo"),
           plotlyOutput("mulheres_eleitas_cargo", inline = FALSE)
    ),
    column(6,
           h3("Proporção de homens eleitos por cargo"),
           plotlyOutput("homens_eleitos_cargo", inline = FALSE)  
    ),
    tags$hr()
  )
)

partidos =  fluidRow(
  box(
    title = "Estatísicas sobre os partidos e os cadidatos eleitos",
    solidHeader = TRUE,
    collapsible = TRUE,
    width = 12,
    helpText("Dados gerados para os anos de eleições selecionados abaixo..."),
    selectInput(
      "selectAnoEleicaoManchetesPartidos",
      "",
      selected = anos_eleicoes,
      choices = c("Exibindo dados para todas as eleições. Filtre anos específicos..." = "", anos_eleicoes),
      multiple = T
    ),
    column(6,
           h3("Partidos extremos em eleger candidatos"),
           uiOutput("tops_partidos", inline = FALSE)
    ),
    column(12,
           h3("Aproveitamento dos partidos que elegeram candidatos"),
           uiOutput("aproveitamento_partidos", inline = FALSE)
    )
  )
)

outros = fluidRow(
  box(
    title = "Outras estatísticas",
    solidHeader = TRUE,
    collapsible = TRUE,
    width = 12,
    helpText("Dados gerados para os anos de eleições selecionados abaixo..."),
    selectInput(
      "selectAnoEleicaoManchetesOutrasEstatisticas",
      "",
      selected = anos_eleicoes,
      choices = c("Exibindo dados para todas as eleições. Filtre anos específicos..." = "", anos_eleicoes),
      multiple = T
    ),
    column(12,
           h3("Proporções de candidatos do executivo eleitos em cada turno"),
           uiOutput("tops_turnos", inline = FALSE)
    ),
    column(6,
           h3("Graus de instrução dos candidatos eleitos"),
           helpText("Excluídos os que declaram os próprios cargos políticos como ocupação"),
           plotlyOutput("geral_grau_instrucao")  
    ),
    column(6,
           h3("Top 10 ocupações mais comuns entre os eleitos"),
           helpText("Excluídos os que declaram os próprios cargos políticos como ocupação"),
           plotlyOutput("top_10_ocupacoes")  
    )
  )
)

dashManchetes= tabItem(
  tabName = "manchetes",
  generos,
  partidos,
  outros,
  br()
)
