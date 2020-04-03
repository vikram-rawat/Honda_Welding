library(DBI)

MainDB <- dbConnect(RSQLite::SQLite(),
                    "Data/mainData.sqlite")

Zones <- "CREATE TABLE zones (
  uid INTEGER PRIMARY KEY AUTOINCREMENT,
  zones text NOT NULL unique,
  created_at text NOT NULL,
  created_by text NOT NULL,
  modified_at text NOT NULL,
  modified_by text NOT NULL,
  is_deleted integer NOT NULL
)"

dbSendStatement(MainDB,"drop table zones")
dbSendStatement(MainDB, Zones)

Cars <- "CREATE TABLE cars (
  uid INTEGER PRIMARY KEY AUTOINCREMENT,
  cars text NOT NULL unique,
  created_at text NOT NULL,
  created_by text NOT NULL,
  modified_at text NOT NULL,
  modified_by text NOT NULL,
  is_deleted integer NOT NULL
)"

dbSendStatement(MainDB,"drop table cars")
dbSendStatement(MainDB, Cars)

Defects <- "CREATE TABLE defects (
  uid INTEGER PRIMARY KEY AUTOINCREMENT,
  problems text NOT NULL unique,
  created_at text NOT NULL,
  created_by text NOT NULL,
  modified_at text NOT NULL,
  modified_by text NOT NULL,
  is_deleted integer NOT NULL
)"

dbSendStatement(MainDB,"drop table defects")
dbSendStatement(MainDB, Defects)

Mapping <- "CREATE TABLE mapping (
  uid INTEGER PRIMARY KEY AUTOINCREMENT,
  zones text NOT NULL,
  cars text NOT NULL ,
  problems text NOT NULL,
  created_at text NOT NULL,
  created_by text NOT NULL,
  modified_at text NOT NULL,
  modified_by text NOT NULL,
  is_deleted integer NOT NULL
)"

dbSendStatement(MainDB, "drop table mapping")
dbSendStatement(MainDB, Mapping)

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

dbSendStatement(MainDB,"drop table dailyfeed")
dbSendStatement(MainDB, dailyFeedSQL)


# setnames(write,"problems", "cars")

# setnames(write,"cars", "zones")

dbDisconnect(MainDB)