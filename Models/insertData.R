
# library -----------------------------------------------------------------

library(DBI)
library(magrittr)
library(dplyr)
library(data.table)

# source ------------------------------------------------------------------

source("R/functions.R")

# connection --------------------------------------------------------------

MainDB <- dbConnect(RSQLite::SQLite(),
                    "Data/mainData.sqlite")

# zones -------------------------------------------------------------------

zones <- fread(file = "Data/csv/zones.csv",
               sep = ",")

zones <- unique(x = zones, by = "zones")

zones <- create_insert_table(dt = zones,
                    useremail = "vikram")

dbSendStatement(MainDB, "delete from zones")

dbWriteTable(conn = MainDB,
             name = "zones",
             value = zones,
             append = TRUE)

MainDB %>% tbl("zones")
rm(zones)

# cars --------------------------------------------------------------------

cars <- fread(file = "Data/csv/cars.csv",
              sep = ",")

cars <- unique(x = cars, by = "cars")

cars <- create_insert_table(dt = cars,
                    useremail = "vikram")

dbSendStatement(MainDB, "delete from cars")

dbWriteTable(conn = MainDB,
             name = "cars",
             value = cars,
             append = TRUE)

MainDB %>% tbl("cars")
rm(cars)

# defects -----------------------------------------------------------------

defects <- fread(file = "Data/csv/defects.csv",
                 sep = ",")

defects <- unique(x = defects, by = "problems")

defects <- create_insert_table(dt = defects,
                            useremail = "vikram")

dbSendStatement(MainDB, "delete from defects")

dbWriteTable(conn = MainDB,
             name = "defects",
             value = defects,
             append = TRUE)

MainDB %>% tbl("defects")
rm(defects)

# mapping -----------------------------------------------------------------

mapping <- fread(file = "Data/csv/mapping.csv",
                 sep = ",")

mapping <- unique(x = mapping,
                  by = c(
                    "zones",
                    "cars",
                    "problems"
                    )
                  )

mapping <- create_insert_table(dt = mapping,
                               useremail = "vikram")

dbSendStatement(MainDB, "delete from mapping")

dbWriteTable(conn = MainDB,
             name = "mapping",
             value = mapping,
             append = TRUE)

MainDB %>% tbl("mapping")
rm(mapping)

# dailyfeed ---------------------------------------------------------------

dailyfeed <- fread(file = "Data/csv/dailyfeed.csv",
                   sep = ",")

dbSendStatement(MainDB, "delete from dailyfeed")

dbWriteTable(conn = MainDB,
             name = "dailyfeed",
             value = dailyfeed,
             append = TRUE)

MainDB %>% tbl("dailyfeed")
rm(dailyfeed)

# disconnect --------------------------------------------------------------

dbDisconnect(MainDB)
