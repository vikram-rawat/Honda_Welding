
# edit_ui -----------------------------------------------------------------

edit_ui <- function(id){

# namespace UI ------------------------------------------------------------

  ns <- NS(id)

  sidebarLayout(
    sidebarPanel = sidebarPanel(
      bs4Card(
        title = "Select Table to Edit",
        width = 12,
        status = "primary",
        collapsible = TRUE,
        closable = FALSE,
        selectInput(inputId = ns("chooseTable"),
                    label = "Choose Table",
                    choices = c("defects",
                                "cars",
                                "zones"),
                    selected = "defects")
      )
    ),
    mainPanel = mainPanel(
      useToastr(),
      useShinyFeedback(),
      useShinyjs(),
      uiOutput(ns("mainTable"))
      )
    )
}

# edit_server -------------------------------------------------------------

edit_server <- function(input, output, session){

# namespace ---------------------------------------------------------------

ns <- session$ns  

  callModule(
    defects_server,
    "defects_table"
  )
  
  callModule(
    cars_server,
    "cars_table"
  )
  
  callModule(
    zones_server,
    "zones_table"
  )
  
  # callModule(
  #   feeds_server,
  #   "feeds_table"
  # )
  
  output$mainTable <- renderUI({
    switch (input$chooseTable,
            "defects" = bs4Card(
              title = "Defects Table",
              width = 12,
              status = "primary",
              collapsible = TRUE,
              maximizable =  TRUE,
              closable = FALSE,
              labelStatus = "dark",
              defects_ui(ns("defects_table"))
              ),
            "cars" = bs4Card(
              title = "Cars Table",
              width = 12,
              status = "primary",
              collapsible = TRUE,
              maximizable =  TRUE,
              closable = FALSE,
              labelStatus = "dark",
              defects_ui(ns("cars_table"))
            ),
            "zones" = bs4Card(
              title = "Zones Table",
              width = 12,
              status = "primary",
              collapsible = TRUE,
              maximizable =  TRUE,
              closable = FALSE,
              labelStatus = "dark",
              defects_ui(ns("zones_table"))
            )
    )
  })
}
