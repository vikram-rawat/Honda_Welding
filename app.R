
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
  sidebar_collapsed = TRUE,
  controlbar_collapsed = TRUE,
  controlbar_overlay = TRUE,
  enable_preloader = TRUE,
  loading_duration =  4,
  title = "Basic Dashboard",
  navbar = bs4DashNavbar(
    skin = "dark" 
  ),
  sidebar = bs4DashSidebar(
    bs4DashSidebar(
      skin = "dark",
      bs4SidebarMenu(
        id = "test",
        bs4SidebarMenuItem(
          tabName = "tab1",
          icon = "dashboard", 
          text = "Tab 1"
        ),
        bs4SidebarMenuItem(
          tabName = "tab2",
          text = "Tab 2"
        ),
        bs4SidebarMenuItem(
          text = "Click me pleaaaaase",
          bs4SidebarMenuSubItem(
            tabName = "subtab1",
            text = "Tab 3"
          ),bs4SidebarMenuSubItem(
            tabName = "subtab2",
            text = "Tab 4"
          )
        )
      )
    )
  ),
  controlbar = bs4DashControlbar(
    disable = TRUE,
    title = "Controls" 
    ),
  footer = bs4DashFooter(),
  body = bs4DashBody()
)

# server ------------------------------------------------------------------

server <- function(input, output, session){
  
}

# shinyApp ----------------------------------------------------------------

shinyApp(ui, server)
