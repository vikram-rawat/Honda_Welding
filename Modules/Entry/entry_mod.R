# ui ----------------------------------------------------------------------

feed_ui <- function(id) {

  # namespace ---------------------------------------------------------------

  ns <- NS(id)

  tagList(
    tags$script(src = "js/vue.js"),
    fluidRow(
      column(
        width = 8,
        htmlTemplate("www/html/dailyFeed.html")
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
          uiOutput(ns("ChassisUI")),
          uiOutput(ns("DateTime")),
          uiOutput(ns("ZonesnCars")),
          tableOutput(ns("defecttable"))
          )
        )
      ),
    tags$script(src = "js/dailyFeed.js")
  )
}

# server ------------------------------------------------------------------

feed_server <- function(input, output, session, allTables) {

  # namespace ---------------------------------------------------------------

  chassisNumbers <- reactive({

    session$userData$db_trigger()

    data <- session$userData$conn %>%
      tbl("dailyfeed") %>%
      arrange(desc(modified_by)) %>%
      distinct(chassis) %>%
      select(chassis) %>%
      head(1000) %>%
      collect()

    return(data$chassis)

  })

  observe({
    session$sendCustomMessage(
      "ChassisValue",
      toJSON(chassisNumbers())
    )
  })

  observe({

    session$sendCustomMessage(
      "changeMapping",
      toJSON(
        allTables$mappingTable() %>%
          select(zones, cars, problems)
        )
    )

  })

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

  output$ChassisUI <- renderUI({
    req(input$Chassis)

    fluidRow(
      id = ns("zoneCar"),
      column(
        width = 12,
        div(
          class = "card text-white bg-dark mb-3",
          div(
            class = "card-header",
            div(
              class = "float-left",
              input$Chassis
            )
          )
        )
      )
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

  defectValues <- reactive({
    req(input$Defects)
    fromJSON(input$Defects)
  })

  output$defecttable <- renderTable({
    defectValues()
  }
  )

  observeEvent(input$SubmitForm, {
    tryCatch(
      expr = {
      flagChassis <- is.null(input$Chassis)
      flagShifts <- is.null(input$Shifts)
      flagZones <- is.null(input$Zones)
      flagCars <- is.null(input$Cars)
      flagDefects <- is.null(input$Defects)

      if (flagChassis) {
        toastr_error(
            message = "Please Select a Chassis Number",
            title = "No Chassis Number",
            showDuration = 2000)
      }

      if (flagShifts) {
        toastr_error(
            message = "Please Select a Shift",
            title = "No Shift Selected",
            showDuration = 2000)
      }

      if (flagZones) {
        toastr_error(
            message = "Please Select a Zone",
            title = "No Zone Selected",
            showDuration = 2000)
      }

      if (flagCars) {
        toastr_error(
            message = "Please Select a Car",
            title = "No Car Selected",
            showDuration = 2000)
      }

      if (flagDefects) {
        toastr_error(
            message = "Please Select a Defect",
            title = "No Defect Selected",
            showDuration = 2000)
      }

      if (!(
          flagShifts ||
          flagZones ||
          flagCars ||
          flagDefects ||
          flagChassis
          )
          ) {

        table <- data.table(
            date = Sys.Date(),
            chassis = input$Chassis,
            shift = input$Shifts,
            zone = input$Zones,
            car = input$Cars,
            defect = defectValues()$defect,
            value = defectValues()$counts,
            created_at = Sys.time(),
            created_by = session$userData$email,
            modified_at = Sys.time(),
            modified_by = session$userData$email,
            is_deleted = FALSE
          )

        session$userData$db_trigger(session$userData$db_trigger() + 1)

        session$userData$conn %>%
            dbWriteTable(
              name = 'dailyfeed',
              value = table,
              append = TRUE
            )

        toastr_success(
            message = "All the values are inserted in Database",
            title = "Successfully Updated",
            showDuration = 2000
          )

        session$sendCustomMessage(
            "dataSubmit",
            Sys.time()
          )
      }
    },
      error = function(e) {
        toastr_error(
          message = paste0("Got an Error: ", e),
          title = "Unable to Insert",
          showDuration = 2000
          )
      },
      finally = {

    }
    )
  })
  
  return(
    list(
      chassisNumbers = chassisNumbers
    )
  )

}