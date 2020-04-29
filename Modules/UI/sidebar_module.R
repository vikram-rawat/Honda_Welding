# ui ----------------------------------------------------------------------

sidebar_ui <- function(id) {

  # namespace ---------------------------------------------------------------

  ns <- NS(id)

  # main ui ----------------------------------------------------------------------
  bs4DashSidebar(
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
        id = ns("mainSidebar"),
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
}

# server ------------------------------------------------------------------

sidebar_server <- function(input, output, session) {
  return(list(sucessfull = 1))
}
