# controlbar --------------------------------------------------------------

controlbar_ui <- function(id) {
  
  # namespace ---------------------------------------------------------------
  
  ns <- NS(id)
  
  # main ui ----------------------------------------------------------------------
  
  bs4DashControlbar(disable = TRUE,
                    title = "Controls")
}

# server ------------------------------------------------------------------

controlbar_server <- function(input, output, session) {
  return(list(sucessfull = 1))
}
