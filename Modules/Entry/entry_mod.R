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
          uiOutput(ns("ZonesnCars")),
          tableOutput(ns("defecttable"))
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
                input$Zones
              ),
              div(
                class = "float-right",
                input$Cars
              )
            )
          )
        )
      )
  })
  
  output$defecttable <- renderTable({
      req(input$Defects)
      fromJSON(input$Defects)
    }
  )
 
}