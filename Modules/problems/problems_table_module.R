defects_ui <- function(id) {

  # namespace ---------------------------------------------------------------
  
  ns <- NS(id)
  
  # ui elements -------------------------------------------------------------
  
  tagList(
    fluidRow(column(
      width = 2,
      actionButton(
        ns("add_car"),
        "Add",
        class = "btn-success",
        style = "color: #000;",
        icon = icon('plus'),
        width = '100%'
      ),
      tags$br(),
      tags$br()
    )),
    fluidRow(
      column(
        width = 12,
        title = "Motor Trend Car Road Tests",
        DTOutput(ns('table')) %>%
          withSpinner(),
        tags$br(),
        tags$br()
      )
    ),
    tags$script(src = "js/cars_table_module.js"),
    tags$script(paste0("cars_table_module_js('", ns(''), "')"))
  )
}

# server ------------------------------------------------------------------

defects_server <- function(input, output, session) {

  # main Data ---------------------------------------------------------------

  mainTable <- reactive({

    session$userData$db_trigger()
    
    session$userData$conn %>%
      tbl('defects') %>%
      collect() %>%
      filter(is_deleted == FALSE) %>% 
      arrange(desc(modified_at))
  })

  table_prep <- reactiveVal(NULL)

  # changes in the Data -----------------------------------------------------
  
  observeEvent(mainTable(), {
    
    out <- mainTable()
    
    ids <- out$uid
    
    actions <- vapply(X = ids,FUN =  function(id_) {
        paste0(
          '<div class="btn-group" style="width: 75px;" role="group" aria-label="Basic example">
            <button class="btn btn-primary btn-sm edit_btn" data-toggle="tooltip" data-placement="top" title="Edit" id = ',
          id_,
          ' style="margin: 0"><i class="fa fa-pencil-square-o"></i></button>
            <button class="btn btn-danger btn-sm delete_btn" data-toggle="tooltip" data-placement="top" title="Delete" id = ',
          id_,
          ' style="margin: 0"><i class="fa fa-trash-o"></i></button>
          </div>'
        )
      },FUN.VALUE = character(1)
    )

    # Remove the `uid` column. We don't want to show this column to the user
    out <- out %>%
      select(- uid, -is_deleted)
    
    # Set the Action Buttons row to the first column of the `mtcars` table
    out <- cbind(
              tibble(" " = actions),
              out
            )
    
    if (is.null(table_prep())) {
      # loading data into the table for the first time, so we render the entire table
      # rather than using a DT proxy
      table_prep(out)
      
    } else {
      # table has already rendered, so use DT proxy to update the data in the
      # table without re-rendering the entire table
      replaceData(table_proxy,
                  out,
                  resetPaging = FALSE,
                  rownames = FALSE)
    }
  })
  
  # render Table ------------------------------------------------------------
  
  output$table <- renderDT({

    req(table_prep())
    out <- table_prep()
    
    datatable(
      out,
      rownames = FALSE,
      colnames = c(
        'Problems',
        'Created At',
        'Created By',
        'Modified At',
        'Modified By'
      ),
      selection = "none",
      class = "compact stripe row-border nowrap",
      # Escape the HTML in all except 1st column (which has the buttons)
      escape = -1,
      extensions = c("Buttons"),
      options = list(
        scrollX = TRUE,
        dom = 'Bftip',
        buttons = list(
          list(
            extend = "excel",
            text = "Download",
            title = paste0("mtcars-", Sys.Date()),
            exportOptions = list(columns = 1:(length(out) - 1))
          )
        ),
        columnDefs = list(list(
          targets = 0, orderable = FALSE
        ))
      )
    ) %>%
      formatDate(columns = c("created_at", "modified_at"),
                 method = 'toLocaleString')
  })

  table_proxy <- DT::dataTableProxy('table')
  
  # edit data ---------------------------------------------------------------
  
  callModule(
    edit_module,
    "add_car",
    title = "Add Car",
    obj_to_edit = function()
      NULL,
    trigger = reactive({
      input$add_car
    })
  )
  
  car_to_edit <- eventReactive(input$id_to_edit, {
    mainTable() %>%
      filter(uid == input$id_to_edit)
  })

  callModule(
    edit_module,
    "edit_problems",
    title = "Edit Car",
    obj_to_edit = car_to_edit,
    trigger = reactive({
      input$id_to_edit
    })
  )

  # delete data -------------------------------------------------------------
  
  obj_to_delete <- eventReactive(input$id_to_delete, {
    out <- mainTable() %>%
      filter(uid == input$id_to_delete) %>%
      pull(problems)
    out <- as.character(out)
  })
  
  callModule(
    delete_module,
    "delete_problems",
    title = "Delete Car",
    obj_to_delete = obj_to_delete,
    trigger = reactive({
      input$id_to_delete
    })
  )

}
