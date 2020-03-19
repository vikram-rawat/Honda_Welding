# Server ------------------------------------------------------------------

edit_module <- function(input,
                        output,
                        session,
                        title,
                        obj_to_edit,
                        trigger) {
  # namespace ---------------------------------------------------------------
  
  ns <- session$ns

  # observer ----------------------------------------------------------------
  
  observeEvent(trigger(), {
    hold <- obj_to_edit()
    
    showModal(
      modalDialog(
      fluidRow(
        column(
          width = 12,
          textInput(ns("problems"),
                    'Problems',
                    value = hold$problems
                  )
        )
      ),
      title = title,
      size = 'm',
      footer = list(
        modalButton('Cancel'),
        actionButton(
          ns('submit'),
          'Submit',
          class = "btn btn-primary",
          style = "color: white"
        )
      )
    ))
  })
  
  observeEvent(input$problems, {
    if (input$problems == "") {
      shinyFeedback::feedbackDanger("problems",
                                    text = "Must enter model of car!")
      shinyjs::disable('submit')
    } else {
      shinyFeedback::hideFeedback("problems")
      shinyjs::enable('submit')
    }
  })
  
  edit_dat <- reactive({

    hold <- obj_to_edit()
    
    out <- list(
      uid = hold$uid,
      data = list(
        "problems" = input$problems
      )
    )
    
    time_now <- as.character(Sys.time())
    
    if (is.null(hold)) {
      # adding a new car
      
      out$data$created_at <- time_now
      out$data$created_by <- session$userData$email
    } else {
      # Editing existing car
      
      out$data$created_at <- as.character(hold$created_at)
      out$data$created_by <- hold$created_by
    }
    
    out$data$modified_at <- time_now
    out$data$modified_by <- session$userData$email
    
    out$data$is_deleted <- FALSE
    
    out
  })
  
  validate_edit <- eventReactive(input$submit, {
    
    dat <- edit_dat()
    
    # Logic to validate inputs...
    
    dat
  })
  
  observeEvent(validate_edit(), {
    
    removeModal()
    
    dat <- validate_edit()
    tryCatch({

        # editing an existing car
        dbExecute(
          session$userData$conn,
          "UPDATE defects SET problems=$1, created_at=$2, created_by=$3,
          modified_at=$4, modified_by=$5, is_deleted=$6 WHERE uid=$7",
          params = c(unname(dat$data),
                     list(dat$uid))
        )

      session$userData$db_trigger(session$userData$db_trigger() + 1)
      shinytoastr::toastr_success(paste0(title, " Success"))
    }, error = function(error) {
      shinytoastr::toastr_error(paste0(title, " Error"))
      
      print(error)
    })
  })
}
