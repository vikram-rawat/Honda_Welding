# ui  ---------------------------------------------------------------------

main_table_ui <- function(id) {

  # namespace ---------------------------------------------------------------

  ns <- NS(id)

  tagList(
    tags$script(src = "js/vue.js"),
    fluidRow(
      htmlTemplate("www/html/mainTableSelect.html")
      ),
    fluidRow(
      bs4Card(
        title = "Summary Table",
        width = 12,
        status = "primary",
        collapsible = TRUE,
        maximizable = TRUE,
        closable = FALSE,
        labelStatus = "dark",
        overflow = TRUE,
        withSpinner(
          ui_element = gt_output(ns("gtTable")),
          type = 8,
          size = 3
        )
      )
    ),
    tags$script(src = "js/mainTableSelect.js")
  )
}

# server ------------------------------------------------------------------

main_table_server <- function(input, output, session, inputList) {

  # namespace ---------------------------------------------------------------

  ns <- session$ns

  observe({
    session$sendCustomMessage(
      "mainTable_NameSpaceValue",
      ns("")
    )
  })

  # send Data to Vue --------------------------------------------------------

  observe({
    session$sendCustomMessage(
      "mainTable_ChassisValues",
      toJSON(inputList$chassisNumbers())
    )
  })


  # raise red flags ---------------------------------------------------------

  observeEvent(input$RaiseFlag, {
    toastr_error(
    message = paste0("There is no value in ", input$RaiseFlag),
    title = paste0("No ", input$RaiseFlag, " Selected"),
    showDuration = 2000)
  })
  # get Data ----------------------------------------------------------------

  mainTable <- reactive({

    req(input$FilterParams)

    filterDate <- fromJSON(input$FilterParams)$Date
    filterChassis <- fromJSON(input$FilterParams)$Chassis

    if (is.null(filterDate)) {
      dt <- session$userData$conn %>%
        tbl("dailyfeed") %>%
        filter(chassis == filterChassis) %>%
        collect() %>%
        data.table(key = "uid")
    } else {
      dt <- session$userData$conn %>%
        tbl("dailyfeed") %>%
        filter(date == filterDate) %>%
        collect() %>%
        data.table(key = "uid")
    }

    dt[, ":="(
      defect = toupper(defect),
      car = toupper(car),
      zone = toupper(zone)
    )]

    setorder(dt, zone, car, defect)

    return(dt)

  })

  transformedTable <- reactive({

    shiny::validate(
      need(
        expr = nrow(mainTable()) >= 1,
        message =  " There is no Data Available",
        label = "Check Parameters"
      )
    )
    
    dcast.data.table(
      data = mainTable(),
      formula = defect ~ car + zone,
      value.var = "value",
      fill = 0,
      fun.aggregate = sum
    )

  })

  # create GT Table ------------------------------------------------------------

  output$gtTable <- render_gt({
    uniqueZones <- mainTable()[, unique(zone)]
    dtTransformed <- transformedTable()
    # future({
      createGT(
        dtTransformed = dtTransformed,
        uniqueZones = uniqueZones
        )  
    # }) %...>% 
    # (function(result) {
    #   return(result)
    # })

  })

  return(list(dailyFeed = mainTable))

}