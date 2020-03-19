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
        "problems" = input$problems,
      )
    )
    
    time_now <-
      as.character(lubridate::with_tz(Sys.time(), tzone = "UTC"))
    
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
    dat <- edit_car_dat()
    
    # Logic to validate inputs...
    
    dat
  })
  
  observeEvent(validate_edit(), {
    removeModal()
    dat <- validate_edit()
    
    tryCatch({
      if (is.na(dat$uid)) {
        # creating a new car
        uid <- digest::digest(Sys.time())
        
        dbExecute(
          session$userData$conn,
          "INSERT INTO mtcars (uid, model, mpg, cyl, disp, hp, drat, wt, qsec, vs, am,
          gear, carb, created_at, created_by, modified_at, modified_by, is_deleted) VALUES
          ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18)",
          params = c(list(uid),
                     unname(dat$data))
        )
      } else {
        # editing an existing car
        dbExecute(
          session$userData$conn,
          "UPDATE mtcars SET model=$1, mpg=$2, cyl=$3, disp=$4, hp=$5, drat=$6,
          wt=$7, qsec=$8, vs=$9, am=$10, gear=$11, carb=$12, created_at=$13, created_by=$14,
          modified_at=$15, modified_by=$16, is_deleted=$17 WHERE uid=$18",
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
