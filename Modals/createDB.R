MainDB <- dbConnect(RSQLite::SQLite(),
                    "Data/mainData.sqlite")

write <- data.table(
  uid = 1:10,
  problems = c("leakage","beakage"),
  created_at = seq.POSIXt(from = Sys.time(),
                          by = 'sec',
                          length.out = 2),
  created_by = c("vikram","rawat"),
  modified_at = seq.POSIXt(from = Sys.time(),
                          by = 'sec',
                          length.out = 2),
  modified_by = c("vikram","rawat"),
  is_deleted = c(FALSE,FALSE)
)

MainDB %>% 
  dbWriteTable(
    "defects",
    write,
    overwrite = TRUE
  )


MainDB %>% 
  dbListTables()

MainDB %>%
  tbl('defects') %>%
  collect() %>%
  # Filter out deleted rows from database `mtcars` table
  filter(is_deleted == FALSE) %>%
  arrange(desc(modified_at))
