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

# navbar ------------------------------------------------------------------

navbar <- bs4DashNavbar(skin = "dark")

# sidebar -----------------------------------------------------------------

sidebar <- bs4DashSidebar(
  expand_on_hover = FALSE,
  skin = "dark",
  status = "primary",
  title = "Welding Dashboard",
  brandColor = "gray-light",
# url = "https://www.google.fr",
  src = "img/hondaicon.jpg",
  elevation = 3,
  opacity = 0.8,
  bs4SidebarMenu(
    id = "test",
    bs4SidebarHeader("Welding"),
    bs4SidebarMenuItem(
      tabName = "FeedData",
      icon = "edit",
      text = "Feed Data",
      bs4SidebarMenuSubItem(
        tabName = "Original",
        text = "Main Tables",
        icon = "cube"
      ),
      bs4SidebarMenuSubItem(
        tabName = "DailyFeed",
        text = "Daily Feed",
        icon = "file-excel"
      )
    ),
    bs4SidebarMenuItem(
      tabName = "Summary",
      icon = "table",
      text = "Summary Table"
    )
  )
)

# controlbar --------------------------------------------------------------

controlbar <- bs4DashControlbar(
  disable = TRUE,
  title = "Controls"
)

# mainbody ----------------------------------------------------------------

mainbody <- bs4DashBody(
  tags$link(
    rel = "stylesheet", type = "text/css",
    href = "css/custom.css"
  ),
  bs4TabItems(
    bs4TabItem(
      tabName = "Original",
      edit_ui("edit_tables")
    ),
    bs4TabItem(
      tabName = "DailyFeed",
      feed_ui("daily_data")
    ),
    bs4TabItem(
      tabName = "Summary",
      main_table_ui("gttable")
    )
  ),
  tags$script(src = "js/custom.js")
)

# ui ----------------------------------------------------------------------

ui <- bs4DashPage(
  old_school = FALSE,
  sidebar_min = TRUE,
  sidebar_collapsed = TRUE,
  controlbar_collapsed = TRUE,
  controlbar_overlay = TRUE,
  enable_preloader = TRUE,
  loading_duration = 2,
  loading_background = "#2F4F4F",
  title = "Weilding Defects",
  navbar = navbar,
  sidebar = sidebar,
  controlbar = controlbar,
  footer = bs4DashFooter(),
  body = mainbody
)

# server ------------------------------------------------------------------

server <- function(input, output, session) {
  # user session$userData to store user data that will be needed throughout
  # the Shiny application
  session$userData$email <- "vikram.rawat@GreyvalleyInfotech.com"
  session$userData$conn <- conn
  session$userData$db_trigger <- reactiveVal(0)

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