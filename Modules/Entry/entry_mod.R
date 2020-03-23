# ui ----------------------------------------------------------------------

feed_ui <- function(id) {

  # namespace ---------------------------------------------------------------

  ns <- NS(id)

  tagList(
    tags$script(src = "js/vue.js"),
    fluidRow(
      column(
        width = 9,
        htmlTemplate("www/html/accordian.html")
        ),
      column(
        width = 3,
        gt_output(ns('feedView'))
        )
      ),
    tags$script(src = "js/DailyFeed.js")
  )

}

# server ------------------------------------------------------------------

feed_server <- function(input, output, session, allTables) {

  # namespace ---------------------------------------------------------------

  ns <- session$ns

  jsObjects <- reactiveVal()

  feedTable <- reactive({
    allTables$defectsTable() %>% 
      select(problems)
  })

  output$feedView <- render_gt({

    feedTable() %>%
      gt() %>%
      tab_header(
        title = input$Shifts,
        subtitle = Sys.Date()
      ) %>%
      tab_stubhead(label = "Defects Name")

  })
}