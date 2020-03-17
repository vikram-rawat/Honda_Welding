

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
  expand_on_hover = TRUE,
  skin = "dark",
  status = "primary",
  title = "bs4Dash",
  brandColor = "primary",
  url = "https://www.google.fr",
  src = "https://adminlte.io/themes/AdminLTE/dist/img/user2-160x160.jpg",
  elevation = 3,
  opacity = 0.8,
  bs4SidebarMenu(
  id = "test",
  bs4SidebarHeader("Main content"),
    bs4SidebarMenuItem(
      tabName = "tab1",
      icon = "dashboard",
      text = "Tab 1"
    ),
    bs4SidebarMenuItem(tabName = "tab2",
                       text = "Tab 2"),
    bs4SidebarMenuItem(
      text = "Click me pleaaaaase",
      bs4SidebarMenuSubItem(tabName = "subtab1",
                            text = "Tab 3"),
      bs4SidebarMenuSubItem(tabName = "subtab2",
                            text = "Tab 4")
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
