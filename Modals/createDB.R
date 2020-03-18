MainDB <- dbConnect(RSQLite::SQLite(),
                    "Data/mainData.sqlite")

write <- data.table(
  x = 1:10,
  problems = c("leakage","beakage"),
  created_at = seq.POSIXt(from = Sys.time(),
                          by = 'days',
                          length.out = 2),
  created_by = c("vikram","rawat"),
  modified_at = seq.POSIXt(from = Sys.time(),
                          by = 'days',
                          length.out = 2),
  modified_by = c("vikram","rawat"),
  is_deleted = c(1,1)
)

MainDB %>% 
  dbWriteTable(
    "defects",
    write,
    overwrite = TRUE
  )


