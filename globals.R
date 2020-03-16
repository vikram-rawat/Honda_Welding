# connection pool ---------------------------------------------------------

dbPool <- dbConnect(RSQLite::SQLite(),
                    "Data/mainData.sqlite")
