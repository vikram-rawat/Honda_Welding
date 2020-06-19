# load libraries ----------------------------------------------------------

library(package = "jsonlite", character.only = TRUE)
library(package = "DT", character.only = TRUE)
library(package = "shinyFeedback", character.only = TRUE)
library(package = "shinytoastr", character.only = TRUE)
library(package = "shinycssloaders", character.only = TRUE)
library(package = "shinyWidgets", character.only = TRUE)
library(package = "shinyjs", character.only = TRUE)
library(package = "dplyr", character.only = TRUE)
library(package = "gt", character.only = TRUE)
library(package = "stringi", character.only = TRUE)
# library(package = "future", character.only = TRUE)
# library(package = "promises", character.only = TRUE)
library(package = "pool", character.only = TRUE)
library(package = "DBI", character.only = TRUE)
library(package = "data.table", character.only = TRUE)
library(package = "plotly", character.only = TRUE)
library(package = "bs4Dash", character.only = TRUE)
library(package = "shiny", character.only = TRUE)

# library(bootstraplib)

# set defaults ------------------------------------------------------------

# plan(multisession)

setDTthreads(1L)

options(scipen = 999)
options(spinner.type = 8)

shiny::onStop(function() {
  poolClose(conn)
})

# bs_theme_new(version = "4", bootswatch = NULL)
# bs_theme_base_colors(bg = "salmon", fg = "white")

# getData -----------------------------------------------------------------

source(file = "globals.R")
source(file = "R/functions.R")

# source files ------------------------------------------------------------

source(file = "Modules/edit_modules/defects/defects_table_module.R")
source(file = "Modules/edit_modules/defects/defects_edit_module.R")
source(file = "Modules/edit_modules/cars/cars_table_module.R")
source(file = "Modules/edit_modules/cars/cars_edit_module.R")
source(file = "Modules/edit_modules/zones/zones_table_module.R")
source(file = "Modules/edit_modules/zones/zones_edit_module.R")
source(file = "Modules/edit_modules/mapping/mapping_table_module.R")
source(file = "Modules/edit_modules/mapping/mapping_edit_module.R")
source(file = "Modules/edit_modules/edit_modules.R")
source(file = "Modules/delete_module.R")
source(file = "Modules/Entry/dailyfeed_module.R")
source(file = "Modules/Others/maintable.R")
source(file = "Modules/UI/controlbar_module.R")
source(file = "Modules/UI/footer_module.R")
source(file = "Modules/UI/navbar_module.R")
source(file = "Modules/UI/sidebar_module.R")
source(file = "Modules/UI/mainbody_module.R")
source(file = "Modules/main_app.R")

# ui ----------------------------------------------------------------------

ui <- main_ui("main_app")

# server ------------------------------------------------------------------

server <- function(input, output, session) {

  callModule(main_server, "main_app")

}

# shinyApp ----------------------------------------------------------------

shinyApp(
  ui = ui,
  server = server,
  options = list(
    port = 9002,
    host = "127.0.0.1"
  )
)