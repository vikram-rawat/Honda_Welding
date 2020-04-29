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
                 edit_ui("edit_tables")),
      bs4TabItem(tabName = "DailyFeed",
                 feed_ui("daily_data")),
      bs4TabItem(tabName = "Summary",
                 main_table_ui("gttable"))
    ),
    tags$script(src = "js/custom.js")
  )
}

# server ------------------------------------------------------------------

mainbody_server <- function(input, output, session) {
  return(list(sucessfull = 1))
}
