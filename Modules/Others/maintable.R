# ui  ---------------------------------------------------------------------

main_table_ui <- function(id) {
  # namespace ---------------------------------------------------------------
  
  ns <- NS(id)
  
  tagList(
    bs4Card(
      title = "Summary Table",
      width = 12,
      status = "primary",
      collapsible = TRUE,
      maximizable =  TRUE,
      closable = FALSE,
      labelStatus = "dark",
      overflow = TRUE,
      withSpinner(ui_element = gt_output(ns("gtTable")),
                  type = 1)
    )
  )
}

# server ------------------------------------------------------------------

main_table_server <- function(input, output, session) {
  # namespace ---------------------------------------------------------------
  
  ns <- session$ns
  
  # get Data ----------------------------------------------------------------
  
  mainTable <- reactive({

    dt <- session$userData$conn %>%
      tbl("dailyfeed") %>%
      collect() %>% 
      data.table(key = "uid")
    
    dt[,":="(defect = toupper(defect),
             car = toupper(car),
             zone = toupper(zone)
             )]
    
    return(dt)
    
  })
  
  transformedTable <- reactive({
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
    future({
      createGT(
          dtTransformed = dtTransformed,
          uniqueZones = uniqueZones
        )
    }) %...>% (function(result) {
      return(result)
    })
    
  })
  
  return(list(dailyFeed = mainTable))
  
}