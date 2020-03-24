# ui ----------------------------------------------------------------------

feed_ui <- function(id) {

  # namespace ---------------------------------------------------------------

  ns <- NS(id)

  tagList(
    tags$script(src = "js/vue.js"),
    fluidRow(
      column(
        width = 8,
        htmlTemplate("www/html/accordian.html")
        ),
      column(
        width = 4,
        bs4Card(
          width = 12, 
          inputId = "feedDetails",
          title = "Entered Values",
          status = "success",
          elevation = 1,
          maximizable = TRUE,
          closable = FALSE, 
          label = "Check your Values here",
          uiOutput(ns("DateTime")),
          uiOutput(ns("ZonesnCars"))
        )
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

  output$DateTime <- renderUI({
    bs4InfoBox(
      iconElevation = 1, 
      width = 12, 
      title = Sys.Date(),
      value = input$Shifts,
      icon = "calendar"
    )
  })
  
  output$ZonesnCars <- renderUI({
    req(input$Zones)
    
    fluidRow(
      id = ns("zoneCar"),
      column(
        width = 12,
        div(
            class = "card text-white bg-info mb-3",
            div(
              class = "card-header",
              div(
                class = "float-left",
                paste0(
                  "ZoneName: ",
                  input$Zones
                  )
              ),
              div(
                class = "float-right",
                if(!is.null(input$Cars)){
                paste0(
                    "CarName: ",
                    input$Cars
                  ) 
                }
                )
                )
              )
            )
        )
  })
  # output$feedView <- render_gt({
  # 
  #   feedTable() %>%
  #     gt() %>%
  #     tab_header(
  #       title = input$Shifts,
  #       subtitle = Sys.Date()
  #     ) %>%
  #     tab_stubhead(label = "Defects Name")
  # 
  # })
  
}