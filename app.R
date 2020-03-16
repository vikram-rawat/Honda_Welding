
# load libraries ----------------------------------------------------------

library(shiny)
library(bs4Dash)
library(DBI)
library(data.table)
library(plotly)
library(bootstraplib)

# set defaults ------------------------------------------------------------

setDTthreads(0L)

# source files ------------------------------------------------------------


# ui ----------------------------------------------------------------------

ui <- bs4DashPage(
  old_school = FALSE,
  sidebar_min = TRUE,
  sidebar_collapsed = FALSE,
  controlbar_collapsed = FALSE,
  controlbar_overlay = TRUE,
  title = "Basic Dashboard",
  navbar = bs4DashNavbar(),
  sidebar = bs4DashSidebar(),
  controlbar = bs4DashControlbar(disable = TRUE),
  footer = bs4DashFooter(),
  body = bs4DashBody()
)

# server ------------------------------------------------------------------

server <- function(input, output, session){
  
}

# shinyApp ----------------------------------------------------------------

shinyApp(ui, server)
