delete_module <-
  function(input,
           output,
           session,
           title,
           obj_to_delete,
           tableName,
           ShowValue = "defect",
           trigger) {

    # namespace ---------------------------------------------------------------

    ns <- session$ns
    # Observes trigger for this module (here, the Delete Button)

    observeEvent(trigger(), {
      # Authorize who is able to access particular buttons (here, modules)
      # req(session$userData$email == 'tycho.brahe@tychobra.com')
      showModal(modalDialog(
        h3(
          paste(
            "Are you sure you want to delete the information for the",
            obj_to_delete(),
            ShowValue, "?"
          )
        ),
        title = title,
        size = "m",
        footer = list(
          actionButton(ns("delete_button"),
                       paste0("Delete ", ShowValue),
                       style = "color: #fff; background-color: #dd4b39; border-color: #d73925"),
          modalButton("Cancel")
        )
      ))
    })

    observeEvent(input$delete_button, {
      req(trigger())

      removeModal()

      tryCatch({
        uid <- as.character(trigger())

        DBI::dbExecute(
          session$userData$conn,
          paste0("UPDATE ",
                 tableName,
                 " SET is_deleted=TRUE WHERE uid=$1"),
          params = c(uid)
        )

        session$userData$db_trigger(session$userData$db_trigger() + 1)
        shinytoastr::toastr_success(paste0(ShowValue, " Successfully Deleted"))
      }, error = function(error) {
        shinytoastr::toastr_error(paste0("Error Deleting ", ShowValue))
        print(error)
      })
    })
  }