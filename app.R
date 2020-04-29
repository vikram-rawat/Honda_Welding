# load libraries ----------------------------------------------------------

library("jsonlite", character.only = TRUE)
library("shiny", character.only = TRUE)
library("bs4Dash", character.only = TRUE)
library("DBI", character.only = TRUE)
library("pool", character.only = TRUE)
library("data.table", character.only = TRUE)
library("plotly", character.only = TRUE)
library("DT", character.only = TRUE)
library("shinyFeedback", character.only = TRUE)
library("shinytoastr", character.only = TRUE)
library("shinycssloaders", character.only = TRUE)
library("shinyWidgets", character.only = TRUE)
library("shinyjs", character.only = TRUE)
library("dplyr", character.only = TRUE)
library("gt", character.only = TRUE)
library("stringi", character.only = TRUE)
library("future", character.only = TRUE)
library("promises", character.only = TRUE)

# library(bootstraplib)

# set defaults ------------------------------------------------------------

plan(multisession)

setDTthreads(1L)

options(scipen = 999)
options(spinner.type = 8)

shiny::onStop(function() {
  poolClose(conn)
})

# bs_theme_new(version = "4", bootswatch = NULL)
# bs_theme_base_colors(bg = "salmon", fg = "white")

# getData -----------------------------------------------------------------

source("globals.R")
source("R/functions.R")

# source files ------------------------------------------------------------

source("Modules/edit_modules/defects/defects_table_module.R")
source("Modules/edit_modules/defects/defects_edit_module.R")
source("Modules/edit_modules/cars/cars_table_module.R")
source("Modules/edit_modules/cars/cars_edit_module.R")
source("Modules/edit_modules/zones/zones_table_module.R")
source("Modules/edit_modules/zones/zones_edit_module.R")
source("Modules/edit_modules/mapping/mapping_table_module.R")
source("Modules/edit_modules/mapping/mapping_edit_module.R")
source("Modules/edit_modules/edit_modules.R")
source("Modules/delete_module.R")
source("Modules/Entry/entry_mod.R")
source("Modules/Others/maintable.R")
source("Modules/UI/controlbar_module.R")
source("Modules/UI/footer_module.R")
source("Modules/UI/navbar_module.R")
source("Modules/UI/sidebar_module.R")
source("Modules/UI/mainbody_module.R")

# ui ----------------------------------------------------------------------

ui <- bs4DashPage(

  # options -----------------------------------------------------------------

  old_school = FALSE,
  sidebar_min = TRUE,
  sidebar_collapsed = TRUE,
  controlbar_collapsed = TRUE,
  controlbar_overlay = TRUE,
  enable_preloader = TRUE,
  loading_duration = 2,
  loading_background = "#2F4F4F",
  title = "Weilding Defects",
  
  # navbar ------------------------------------------------------------------
  
  navbar = navbar_ui("app_navbar"),

  # sidebar -----------------------------------------------------------------

  sidebar = sidebar_ui("app_sidebar"),
  
  # controlbar --------------------------------------------------------------
  
  controlbar = controlbar_ui("app_controllbar"),

  # footer ------------------------------------------------------------------

  footer = footer_ui("app_footer"),
  
  # mainbody ----------------------------------------------------------------
  
  body = mainbody_ui("app_mainbody")
  
)

# server ------------------------------------------------------------------

server <- function(input, output, session) {

# userData ----------------------------------------------------------------

  session$userData$email <- "vikram.rawat@GreyvalleyInfotech.com"
  session$userData$conn <- conn
  session$userData$db_trigger <- reactiveVal(0)

# create UI ---------------------------------------------------------------

  sidebar <- callModule(sidebar_server, "app_sidebar")
  controlbar <- callModule(controlbar_server, "app_controllbar")
  navbar <- callModule(navbar_server, "app_navbar")
  footer <- callModule(footer_server, "app_footer")
  mainbody <- callModule(mainbody_server, "app_mainbody")

# create sections ---------------------------------------------------------

  editData <- callModule(edit_server, "edit_tables")

  FeedData <- callModule(feed_server, "daily_data", allTables = editData)

  dailyFeed <- callModule(main_table_server, "gttable", inputList = FeedData )

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