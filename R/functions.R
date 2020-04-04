# create data for insert and update ---------------------------------------

create_mod_Data <- function(hold,
                            xlist,
                            uid,
                            flagAdd,
                            useremail) {
  out <- list(uid = uid,
              data = xlist)
  
  time_now <- as.character(Sys.time())
  
  if (flagAdd) {
    # adding a new object
    
    out$data$created_at <- time_now
    out$data$created_by <- tolower(useremail)
  } else {
    # Editing existing car
    
    out$data$created_at <- as.character(hold$created_at)
    out$data$created_by <- tolower(hold$created_by)
  }
  
  out$data$modified_at <- time_now
  out$data$modified_by <- tolower(useremail)
  
  out$data$is_deleted <- FALSE
  
  out
  
}

# create data for primary insertion ---------------------------------------

create_insert_table <- function(dt,useremail){
  dt[, ":="(
    created_at = Sys.time(),
    created_by = tolower(useremail),
    modified_at = Sys.time(),
    modified_by = tolower(useremail),
    is_deleted = FALSE
  )]
}
