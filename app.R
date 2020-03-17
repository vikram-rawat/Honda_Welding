

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
  
}

# shinyApp ----------------------------------------------------------------

shinyApp(ui, server)
