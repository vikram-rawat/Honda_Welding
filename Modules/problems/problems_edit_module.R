# Server ------------------------------------------------------------------

edit_module <- function(input,
                        output,
                        session,
                        title,
                        obj_to_edit,
                        trigger) {
  # namespace ---------------------------------------------------------------
  
  ns <- session$ns
  
  flagAdd <- reactive({is.null(obj_to_edit())}) 

  # observer ----------------------------------------------------------------
  
  observeEvent(trigger(), {

    hold <- obj_to_edit()
    
    if(!flagAdd()){

    showModal(
      modalDialog(
      fluidRow(
        column(
          width = 12,
          textInput(
            ns("problems"),
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
          style = "color: green"
        )
      )
    ))
    } else {
      
      showModal(
        modalDialog(
          fluidRow(
            column(
              width = 12,
              textInput(
                ns("problems"),
                '',
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
              style = "color: green"
            )
          )
        ))
    }
  })
  
  observeEvent(input$problems,  {

    if(nchar(input$problems) < 3) {
  
        shinyFeedback::feedbackDanger(inputId = "problems",
                                      show = TRUE ,
                                      text = "Must enter a Defect!")
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
    
    if (flagAdd()) {
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

      if (flagAdd()) {
        # creating a new car
        uid <- digest::digest(Sys.time())
        
        dbExecute(
          session$userData$conn,
          "INSERT INTO problems( $1, created_at=$2, created_by=$3,
           modified_at=$4, modified_by=$5, is_deleted=$6 WHERE uid=$7)",
          params = c(
            list(uid),
            unname(dat$data)
          )
        )
      } else {
        dbExecute(
          session$userData$conn,
          "UPDATE defects SET problems=$1, created_at=$2, created_by=$3,
           modified_at=$4, modified_by=$5, is_deleted=$6 WHERE uid=$7",
          params = c(unname(dat$data),
                     list(dat$uid))
        )
      }

      session$userData$db_trigger(session$userData$db_trigger() + 1)
      shinytoastr::toastr_success(paste0(title, " Success"))
    }, error = function(error) {
      shinytoastr::toastr_error(paste0(title, " Error"))
      
      print(error)
    })
  })
}