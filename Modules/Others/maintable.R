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
      withSpinner(
        ui_element = gt_output(ns("gtTable")),
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
    data <- session$userData$conn %>%
      tbl("dailyfeed") %>%
      collect()
    
    return(data)
    
  })
  
  
  # create GT Table ------------------------------------------------------------
  
  output$gtTable <- render_gt(createGT(mainTable()))
  
  return(list(dailyFeed = mainTable))
  
}