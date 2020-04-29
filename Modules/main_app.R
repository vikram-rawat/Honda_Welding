# ui ----------------------------------------------------------------------

main_ui <- function(id) {

  # namespace ---------------------------------------------------------------

  ns <- NS(id)  

  # main ui -----------------------------------------------------------------

  bs4DashPage(
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
    
    navbar = navbar_ui(ns("app_navbar")),
    
    # sidebar -----------------------------------------------------------------
    
    sidebar = sidebar_ui(ns("app_sidebar")),
    
    # controlbar --------------------------------------------------------------
    
    controlbar = controlbar_ui(ns("app_controllbar")),
    
    # footer ------------------------------------------------------------------
    
    footer = footer_ui(ns("app_footer")),
    
    # mainbody ----------------------------------------------------------------
    
    body = mainbody_ui(ns("app_mainbody"))
  )
}


# server ------------------------------------------------------------------

main_server <- function(input, output, session) {
  
  # namespace ---------------------------------------------------------------

  ns <- session$ns
  
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
  
}