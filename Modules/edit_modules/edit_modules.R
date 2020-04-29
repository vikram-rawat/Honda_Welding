
# edit_ui -----------------------------------------------------------------

edit_ui <- function(id) {

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
                    choices = c("zones",
                                "cars",
                                "defects",
                                "mappings"),
                    selected = "zones")
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

edit_server <- function(input, output, session) {

  # namespace ---------------------------------------------------------------

  ns <- session$ns

  defectsTable <- callModule(
  defects_server,
  "defects_table"
  )

  carsTable <- callModule(
  cars_server,
  "cars_table"
  )

  zonesTable <- callModule(
  zones_server,
  "zones_table"
  )

  mappingTable <- callModule(
  mapping_server,
  "mapping_table",
  list(
     zones = zonesTable()$zones,
     cars = carsTable()$cars,
     defects = defectsTable()$problems
   )
  )

  output$mainTable <- renderUI({
    switch(input$chooseTable,
            "defects" = bs4Card(
              title = "Defects Table",
              width = 12,
              status = "primary",
              collapsible = TRUE,
              maximizable = TRUE,
              closable = FALSE,
              labelStatus = "dark",
              defects_ui(ns("defects_table"))
              ),
            "cars" = bs4Card(
              title = "Cars Table",
              width = 12,
              status = "primary",
              collapsible = TRUE,
              maximizable = TRUE,
              closable = FALSE,
              labelStatus = "dark",
              cars_ui(ns("cars_table"))
            ),
            "zones" = bs4Card(
              title = "Zones Table",
              width = 12,
              status = "primary",
              collapsible = TRUE,
              maximizable = TRUE,
              closable = FALSE,
              labelStatus = "dark",
              zones_ui(ns("zones_table"))
            ),
            "mappings" = bs4Card(
              title = "Mapping Table",
              width = 12,
              status = "primary",
              collapsible = TRUE,
              maximizable = TRUE,
              closable = FALSE,
              labelStatus = "dark",
              mapping_ui(id = ns("mapping_table"))
            )
    )
  })

  return(
    list(
      defectsTable = defectsTable,
      carsTable = carsTable,
      zonesTable = zonesTable,
      mappingTable = mappingTable
    )
  )
}
