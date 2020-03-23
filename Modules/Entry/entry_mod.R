# ui ----------------------------------------------------------------------

feed_ui <- function(id) {

  # namespace ---------------------------------------------------------------

  ns <- NS(id)

  tagList(
    tags$script(src = "js/vue.js"),
    fluidRow(
      column(
        width = 8,
        htmlTemplate("www/html/accordian.html")
        ),
      column(
        width = 4
        )
    ),
    tags$script(src = "js/DailyFeed.js")
  )

}
# server ------------------------------------------------------------------

feed_server <- function(input, output, session) {

  # namespace ---------------------------------------------------------------

  ns <- session$ns

}