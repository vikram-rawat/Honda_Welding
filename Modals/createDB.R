MainDB <- dbConnect(RSQLite::SQLite(),
                    "Data/mainData.sqlite")

dailyFeedSQL <- "CREATE TABLE dailyfeed (
  uid INTEGER PRIMARY KEY AUTOINCREMENT,
  Date Date NOT NULL,
  Shift text NOT NULL,
  Zone text NOT NULL,
  Car text NOT NULL,
  defects text NOT NULL,
  value text NOT NULL,
  created_at text NOT NULL,
  created_by text NOT NULL,
  modified_at text NOT NULL,
  modified_by text NOT NULL,
  is_deleted integer NOT NULL
)"

dbSendStatement(MainDB,dailyFeedSQL)

write <- data.table(
  uid = lapply(1:10, function(row_num) {
          row_data <- digest::digest(row_num)
        }) %>% 
          unlist(),
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
mainFeed %>% names
mainFeed <- data.table(
  uid = 1:10,
  Date = Sys.Date(),
  Shift = c("Morning", "Noon"),
  Zone = c("Zone 1", "Zone 2"),
  Car = c("Maruti", "Honda"),
  defects = c("defects1", "defects2"),
  value = c(1,8),
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
    "dailyfeed",
    mainFeed,
    overwrite = TRUE
  )

MainDB %>% 
  dbWriteTable(
    "defects",
    write,
    overwrite = TRUE
  )

setnames(write,"problems", "cars")

MainDB %>% 
  dbWriteTable(
    "cars",
    write,
    overwrite = TRUE
  )

setnames(write,"cars", "zones")

MainDB %>% 
  dbWriteTable(
    "zones",
    write,
    overwrite = TRUE
  )


MainDB %>% 
  dbListTables()

MainDB %>% 
  dbSendStatement("delete from  zones")

MainDB %>% dbDisconnect()
