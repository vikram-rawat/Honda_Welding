library(data.table)
library(DBI)
library(dplyr)

MainDB <- dbConnect(RSQLite::SQLite(),
                    "Data/mainData.sqlite")
dt <- MainDB %>%
  tbl("mapping") %>%
  collect()

setDT(dt)

dt[, ':='(
  date = integer(),
  chassis = character(),
  shift = character(),
  value = character()
)]

dt %>% names
setnames(dt, c("zones", "cars", "problems"), c("zone", "car", "defect"))
setcolorder(dt, c(
  "uid",
  "date",
  "chassis",
  "shift",
  "zone",
  "car",
  "defect",
  "value",
  "created_at",
  "created_by",
  "modified_at",
  "modified_by",
  "is_deleted"
))
dt[, modified_by := "admin"]
dt[, created_by := "admin"]

dt <- rbindlist(lapply(1:3, function(x) { dt }))

shifts <- c("morning", "noon", "night")

dt[, shift := rep(shifts, each = 400)]

dt <- dt[, .(repeatit1 = rep(1, 7)), by = c(names(dt))]

dt[, repeatit1 := NULL]

dt[, date := rep((Sys.Date() - 1:7), each = 1200)]

# dt <- dt[,.(repeatit1 = rep(1, 20)),by=c(names(dt))]

dt <- rbindlist(replicate(n = 20, expr = dt, simplify = FALSE))

x <- 1:420
x <- ifelse(x <= 9, paste0("chassis10", x), paste0("chassis1", x))

dt[, chassis := rep(x, each = 400)]

values <- rep(0, 30)
values <- append(values, 1:10)
values <- sample(x = values, size = 168e3, replace = TRUE)

dt[, value := values]

dt[, uid := (1:.N)]

dt <- unique(dt, by = c("date", "chassis", "shift", "zone", "car", "defect"))

fwrite(dt, "Data/csv/dailyfeed.csv")

dbDisconnect(MainDB)
