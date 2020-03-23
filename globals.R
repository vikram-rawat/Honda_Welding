# connection pool ---------------------------------------------------------

conn <- pool::dbPool(
  RSQLite::SQLite(),
  dbname = 'Data/mainData.sqlite'
)

# Names -------------------------------------------------------------------

