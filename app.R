# load libraries ----------------------------------------------------------

library(shiny)
library(bs4Dash)
library(DBI)
library(data.table)
library(plotly)
library(DT)
library(shinyFeedback)
library(shinytoastr)
library(shinycssloaders)
library(shinyWidgets)
library(shinyjs)
library(dplyr)

# library(bootstraplib)

# set defaults ------------------------------------------------------------

setDTthreads(0L)

options(scipen = 999)

options(spinner.type = 8)

shiny::onStop(function() {
  dbDisconnect(conn)
})

# bs_theme_new(version = "4", bootswatch = NULL)
# bs_theme_base_colors(bg = "salmon", fg = "white")

# source files ------------------------------------------------------------
source("globals.R")

source("Modules/car_delete_module.R")
source("Modules/car_edit_module.R")
source("Modules/cars_table_module.R")

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
      bs4SidebarMenuSubItem(tabName = "Original",
                            text = "Main Tables",
                            icon = "cube"),
      bs4SidebarMenuSubItem(tabName = "DailyFeed",
                            text = "Daily Feed",
                            icon = "file-excel")
    )
  )
)

# controlbar --------------------------------------------------------------

controlbar <- bs4DashControlbar(disable = TRUE,
                                title = "Controls")

# mainbody ----------------------------------------------------------------

mainbody <- bs4DashBody(
  useToastr(),
  useShinyFeedback(),
  useShinyjs(),
  tags$link(rel = "stylesheet", type = "text/css", 
           href = "css/custom.css"), 
  tags$script(src = "js/custom.js"),
  titlePanel(
    h1("Shiny CRUD Application", align = 'center'),
    windowTitle = "Shiny CRUD Application"
  ),
  cars_table_module_ui("cars_table")
)

# ui ----------------------------------------------------------------------

ui <- bs4DashPage(
  old_school = FALSE,
  sidebar_min = TRUE,
  sidebar_collapsed = TRUE,
  controlbar_collapsed = TRUE,
  controlbar_overlay = TRUE,
  enable_preloader = TRUE,
  loading_duration =  2,
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
  session$userData$email <- 'tycho.brahe@tychobra.com'
  session$userData$conn <- conn
  session$userData$db_trigger <- reactiveVal(0)
  
  callModule(
    cars_table_module,
    "cars_table"
  )
}

# shinyApp ----------------------------------------------------------------

shinyApp(ui, server)
