# mainBody ----------------------------------------------------------------

mainbody_ui <- function(id) {
  # namespace ---------------------------------------------------------------
  
  ns <- NS(id)
  
  # main_ui -----------------------------------------------------------------
  
  bs4DashBody(
    tags$link(rel = "stylesheet", type = "text/css",
              href = "css/custom.css"),
    bs4TabItems(
      bs4TabItem(tabName = "Original",
                 edit_ui(ns("edit_tables"))),
      bs4TabItem(tabName = "DailyFeed",
                 feed_ui(ns("daily_data"))),
      bs4TabItem(tabName = "Summary",
                 main_table_ui(ns("gttable")))
    ),
    tags$script(src = "js/custom.js")
  )
}

# server ------------------------------------------------------------------

mainbody_server <- function(input, output, session) {
  # create sections ---------------------------------------------------------
  
  editData <- callModule(edit_server, "edit_tables")
  
  FeedData <-
    callModule(feed_server, "daily_data", allTables = editData)
  
  dailyFeed <-
    callModule(main_table_server, "gttable", inputList = FeedData)
  
  return(list(sucessfull = 1))
}
