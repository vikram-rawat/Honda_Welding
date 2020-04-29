# navbar --------------------------------------------------------------

navbar_ui <- function(id) {

  # namespace ---------------------------------------------------------------

  ns <- NS(id)

  # main ui ----------------------------------------------------------------------

  bs4DashNavbar(skin = "dark")
}

# server ------------------------------------------------------------------

navbar_server <- function(input, output, session) {
  return(list(sucessfull = 1))
}
