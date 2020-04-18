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

create_insert_table <- function(dt, useremail) {
  dt[, ":="(
    created_at = Sys.time(),
    created_by = tolower(useremail),
    modified_at = Sys.time(),
    modified_by = tolower(useremail),
    is_deleted = FALSE
  )]
}

# create GT table ---------------------------------------------------------

createGT <- function(dtTransformed,
                     uniqueZones,
                     numericCol,
                     Title = "Defects Data",
                     SubTitle = "filtered",
                     rowStudHead = "Defect Names") {

  dtnames <- names(dtTransformed)
  
  newdtnames <- stri_replace_all_regex(str = dtnames,
                                       pattern = "_[^_]+",
                                       replacement = "")
  
  colLables <- mapply(
    FUN = function(x, y) {
      x = y
    },
    dtnames,
    newdtnames,
    SIMPLIFY = FALSE,
    USE.NAMES = TRUE
  )
  
  mainTable <- gt(data = dtTransformed,
                  rowname_col = "defect")  %>%
    cols_label(.list = colLables) %>%
    tab_stubhead(label = rowStudHead) %>%
    tab_header(title = Title,
               subtitle = SubTitle)

  lapply(uniqueZones, function(x) {
    mainTable <<- mainTable %>%
      tab_spanner(label = x,
                  columns = stri_detect_regex(str = dtnames,
                                              pattern = x))
  })

  
  mainTable <- mainTable %>%
    grand_summary_rows(
      columns = numericCol,
      fns = list(
        MINIMUM = ~ min(., na.rm = TRUE),
        MAXIMUM = ~ max(., na.rm = TRUE),
        AVERAGE = ~ mean(., na.rm = TRUE),
        TOTAL = ~ sum(., na.rm = TRUE)
      ),
      formatter = fmt_number,
      use_seps = FALSE
    ) %>%
    data_color(
      columns = numericCol,
      colors = scales::col_numeric(
        palette = RColorBrewer::brewer.pal(n = 9, name = "Reds"),
        domain = NULL
      )
    ) %>%
    tab_style(style = list(
      cell_fill(color = "black", alpha = 0.7),
      cell_text(
        color = "#fff",
        weight = "bold",
        size = "xx-large"
      )
    ),
    locations = (cells_title(groups = c("title")))) %>%
    tab_style(style = list(
      cell_fill(color = "white"),
      cell_borders(sides = "bottom", weight = "2px")
    ),
    locations = (cells_title(groups = c("subtitle")))) %>%
    tab_style(
      style = list(
        cell_fill(color = "lightcyan"),
        cell_borders(
          sides = c("right", "left"),
          color = "#d3d3d3",
          weight = "2px"
        ),
        cell_text(weight = "bold",
                  size = "large")
      ),
      locations =
        cells_column_spanners(spanners = uniqueZones)
    ) %>%
    tab_style(style = list(
      cell_fill(color = "lightcyan"),
      cell_text(weight = "bold", style = "italic"),
      cell_borders(sides = "bottom", weight = "2px")
    ),
    locations = cells_stubhead()) %>%
    tab_style(
      style = list(
        cell_fill(color = "lightcyan"),
        cell_text(style = "italic"),
        cell_borders(sides = "bottom", weight = "2px")
      ),
      locations = (cells_column_labels(columns = numericCol))
    ) %>%
    tab_style(style = cell_fill(color = "lightcyan"),
              locations = cells_stub())
  
  return(mainTable)
}