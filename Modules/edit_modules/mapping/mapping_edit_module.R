# Server ------------------------------------------------------------------

mapping_module <- function(
                           input,
                           output,
                           session,
                           title,
                           obj_to_edit,
                           trigger,
                           inputList
                           ) {

  # namespace ---------------------------------------------------------------

  ns <- session$ns

  flagAdd <- reactive({ is.null(obj_to_edit()) })

  # observer ----------------------------------------------------------------

  observeEvent(trigger(), {

    hold <- obj_to_edit()

    if (!flagAdd()) {
      ### edit

      showModal(
      modalDialog(
      fluidRow(
        column(
          width = 12,
          selectInput(inputId = ns("zone"),
                      label = "Choose Zones",
                      choices = inputList$zones,
                      multiple = FALSE,
                      selected = hold$zones),
          selectInput(inputId = ns("car"),
                      label = "Choose Cars",
                      choices = inputList$cars,
                      multiple = FALSE,
                      selected = hold$cars),
          selectInput(inputId = ns("defect"),
                      label = "Choose Defect",
                      choices = inputList$defects,
                      multiple = FALSE,
                      selected = hold$problems)
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
          style = "background-color: green;"
          )
        )
      )
    )
    } else {
      ## Add
      showModal(
        modalDialog(
          fluidRow(
            column(
              width = 12,
              selectInput(inputId = ns("zone"),
                          label = "Choose Zones",
                          choices = inputList$zones,
                          multiple = FALSE),
              selectInput(inputId = ns("car"),
                          label = "Choose Cars",
                          choices = inputList$cars,
                          multiple = FALSE),
              selectInput(inputId = ns("defect"),
                          label = "Choose Defect",
                          choices = inputList$defects,
                          multiple = TRUE)
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

  # observeEvent(input$problems,  {
  # 
  #   if(nchar(input$problems) < 3) {
  # 
  #       shinyFeedback::feedbackDanger(inputId = "problems",
  #                                     show = TRUE ,
  #                                     text = "Must enter a Defect!")
  #       shinyjs::disable('submit')
  # 
  #     } else {
  # 
  #       shinyFeedback::hideFeedback("problems")
  #       shinyjs::enable('submit')
  # 
  #   }
  # })

  edit_dat <- reactive({

    hold <- obj_to_edit()

    out <- list(
      uid = hold$uid,
      data = list(
        "zone" = tolower(input$zone),
        "car" = tolower(input$car),
        "defect" = tolower(input$defect)
      )
    )

    time_now <- as.character(Sys.time())

    if (flagAdd()) {
      # adding a new mapping

      out$data$created_at <- time_now
      out$data$created_by <- tolower(session$userData$email)
    } else {
      # Editing existing mapping

      out$data$created_at <- as.character(hold$created_at)
      out$data$created_by <- tolower(hold$created_by)
    }

    out$data$modified_at <- time_now
    out$data$modified_by <- tolower(session$userData$email)

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
        # uid <- digest::digest(Sys.time())

        newData <- data.table("zones" = input$zone,
                   "cars" = input$car,
                   "problems" = input$defect,
                   "created_at" = dat$data$created_at,
                   "created_by" = dat$data$created_by,
                   "modified_at" = dat$data$modified_at,
                   "modified_by" = dat$data$modified_by,
                   "is_deleted" = dat$data$is_deleted
                   )

        dbWriteTable(
            session$userData$conn,
            name = "mapping",
            value = newData,
            append = TRUE
          )
      } else {

        dbExecute(
          session$userData$conn,
          "UPDATE mapping SET 
              zones = $1,
              cars = $2,
              problems = $3, 
              created_at = $4, 
              created_by = $5,
              modified_at = $6, 
              modified_by = $7,
              is_deleted = $8 
          WHERE uid=$9",
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