# libraries ----
suppressPackageStartupMessages({
  library(shiny)
  library(shinyjs)
  library(shinydashboard)
  library(latex2exp)
  library(tidyverse)
  library(supermetroid)
})

# setup ----


# functions ----
source("scripts/func.R") # helper functions

# user interface ----

## tabs ----
info_tab <- tabItem(tab_name = "info_tab",
                    h1("Super Metroid"),
                    # imageOutput("cover_art")
                    p("test")
                    )

counts_tab <- tabItem(tab_name = "counts_tab",
                      h1("Super Metroid and speed runner communities"),
                      # plotOutput("snes"),
                      p("test"))

runtime_tab <- tabItem(tab_name = "runtime_tab",
                       h1("Super Metroid run times"),
                       p("Placeholder raincloud plot")
                       )

## Set colour and theme -----

skin_color <- "black"
gamepad_icon <- icon("gamepad")

## UI ----
ui <- dashboardPage(
  skin = skin_color,
  dashboardHeader(title = "When do Super Metroid speed runs get competitive?",
                  # puts sidebar toggle on right)
                  titleWidth = "calc(100% - 44px)"),
  dashboardSidebar(
    # https://fontawesome.com/icons?d=gallery&m=free
    sidebarMenu(
      id = "tabs",
      menuItem(
        "Super Metroid",
        tabName = "info_tab",
        icon = gamepad_icon
      ),
      menuItem(
        "Speed runners",
        tabName = "counts_tab",
        icon = gamepad_icon
      ),
      menuItem(
        "Runtimes",
        tabName = "runtime_tab",
        icon = gamepad_icon
      )
    ),
    tags$a(href = "https://debruine.github.io/shinyintro/",
           "ShinyIntro book", style = "padding: 1em;")
  ),
  dashboardBody(
    shinyjs::useShinyjs(),
    tags$head(
      # links to files in www/
      tags$link(rel = "stylesheet", type = "text/css", href = "basic_template.css"),
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
      tags$script(src = "custom.js")
    ),
    tabItems(info_tab,
             counts_tab,
             runtime_tab)
  )
)



# server ----
server <- function(input, output, session) {
  output$logo <- renderImage({
    list(
      src = "www/img/shinyintro.png",
      width = "300px",
      height = "300px",
      alt = "ShinyIntro hex logo"
    )
  }, deleteFile = FALSE)

  output$cover_art <- renderImage({
    list(
      src = "www/img/Smetroidbox-wiki.png",
      width = "300px",
      height = "300px",
      alt = "Super Metroid cover art"
    )

  })

  output$snes <- renderPlot({
    top_five_vis()
  })

  output$top <- renderPlot({
    top_games_vis()
  })
}

shinyApp(ui, server)
