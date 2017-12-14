library(shiny)
library(shinydashboard)

source("telas/manchetes/dashboard.R")
source("telas/despesas/dashboard.R")
source("telas/legendas/dashboard.R")
source("telas/votos/dashboard.R")
source("telas/votos-invalidos/dashboard.R")

sideBar = dashboardSidebar(width = 140, sidebarMenu(
  menuItem("Manchetes", tabName = "manchetes"),
  menuItem("Legendas", tabName = "legendas"),
  menuItem("Candidatos eleitos", tabName = "votos"),
  menuItem("Votos Inválidos", tabName = "votosInvalidos")
))

dashboard =  dashboardPage(
  dashboardHeader(title = "De olho no BR"),
  sideBar,
  dashboardBody(tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  tabItems(dashManchetes, dashLegendas, dashVotos, dashVotosInvalidos))
) 

shinyUI(dashboard)
