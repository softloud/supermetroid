# libraries ----
suppressPackageStartupMessages({
  library(shiny)
  library(shinyjs)
  library(shinydashboard)
  library(shinydashboardPlus)
  library(shinyWidgets)
  library(tidyverse)
  library(plotly)
})

# setup ----
library(supermetroid)

# raincloud x-axis limits
raincloud_xmin <- round(min(src_run_df$t_s)/60/60,2)
raincloud_xmax <- round(max(src_run_df$t_s)/60/60,2)



# functions ----
source("scripts/func.R") # helper functions
source("scripts/gamehoard_text.R")

# user interface ----

## tabs ----
intro_tab <- tabItem(
  tabName = "intro_tab",
  tabBox(
    title = "What is Super Metroid speed running?",
    width = 12,
    tabPanel(title = "Super Metroid",
             imageOutput("cover_art")),
    tabPanel(title = "About Super Metroid",
             HTML(get_gamehoard())),
    tabPanel(title = "Most played SNES speed runner game",
             imageOutput("snes")),
    tabPanel(title = "Super Metroid vs top 3 speed runner games",
             imageOutput("top"))
  )
)

runs_tab <- tabItem(tabName = "runs_tab",
                    tabBox(
                      title = "Players' total time taken to speed run Super Metroid 100%",
                      width=12,
                      tabPanel(
                        title = "data",
                        plotOutput("all_run_raincloud"),
                        sliderInput(inputId = "runs_raincloud_lims",
                                    label="Set range of run times inspected",
                                    value = c(raincloud_xmin,
                                              raincloud_xmax),
                                    min = raincloud_xmin,
                                    max = raincloud_xmax
                                    )
                      ),
                      tabPanel(
                        title = "story",
                        p("Tell story of getting data")
                      )
                    )
                    )


splits_tab <- tabItem(tabName = "splits_tab",
                      p("Analysis across splits"))


split_tab <- tabItem(tabName = "split_tab",
                     p("By split analysis"))

runner_tab <- tabItem(tabName = "runner_tab", p("by runner analysis"))

# about tab

about_tab <- tabItem(
                    tabName = "about_tab",
                     box(title="Useful resource",
                         imageOutput("logo"))
                     )

skin_color <- "midnight"
sidebar_icon <- "gamepad"

## UI ----
ui <- dashboardPage(
  skin = skin_color,
  dashboardHeader(title = "When do Super Metroid speed runs get competitive?",
                  # puts sidebar toggle on right
                  titleWidth = "calc(100% - 44px)"),
                  dashboardSidebar(
                    # https://fontawesome.com/icons?d=gallery&m=free
                    sidebarMenu(
                      id = "tabs",
                      menuItem(
                        "Super Metroid",
                        tabName = "intro_tab",
                        icon = icon(sidebar_icon)
                      ),
                      menuItem(
                        "Run times",
                        tabName = "runs_tab",
                        icon = icon(sidebar_icon)
                      ),
                      menuItem("Splits",
                               tabName = "splits_tab",
                               icon = icon(sidebar_icon)),
                      menuItem("Split",
                               tabName = "split_tab",
                               icon = icon(sidebar_icon)),
                      menuItem("about",
                               tabName = "about_tab",
                               icon = icon("question"))
                    ),
                    tags$a(href = "https://github.com/softloud/supermetroid",
                           "on GitHub", style = "padding: 2em;")
                  ),
                  dashboardBody(
                    shinyjs::useShinyjs(),
                    chooseSliderSkin("Simple", color=sm_col_h$dominant_colour),
                    # setSliderColor("DarkSlateGrey", 1),
                    tags$head(
                      # links to files in www/
                      tags$link(rel = "stylesheet", type = "text/css", href = "basic_template.css"),
                      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
                      tags$script(src = "custom.js")
                    ),
                    tabItems(intro_tab,
                             runs_tab,
                             splits_tab,
                             split_tab,
                             about_tab)
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

    # intro tab -----

    output$cover_art <- renderImage({
      list(src = "www/img/Smetroidbox-wiki.png",
           alt = "Super Metroid cover art")
    }, deleteFile = FALSE)

    # counts vis
    output$snes <- renderPlot({
      top_five_vis()
    })

    output$top <- renderPlot({
      top_games_vis()
    })

    output$gamehoard_text <- renderText({
      "While the exploration-focused platformers known as Metroidvanias derive their genre name from two different series, there’s one game they’re all judged by. Super Metroid wasn’t the first Metroidvania, the first Metroid game also had the focus on exploring a large interconnected map and using new abilities to open up new areas, but its polish, visual direction, and atmosphere all created a more involved experience than its predecessors. Released in 1994, Super Metroid’s shadow looms over every game in the genre since... - [thegamehoard 2022](https://thegamehoard.com/2022/04/24/50-years-of-video-games-super-metroid-snes/)"
    })

    # run times tab ----

    output$all_run_raincloud <- renderPlot({
      all_run_raincloud(xmin = input$runs_raincloud_lims[1],
                        xmax = input$runs_raincloud_lims[2],
                        base_size = 25)
    })


  }

  shinyApp(ui, server)
