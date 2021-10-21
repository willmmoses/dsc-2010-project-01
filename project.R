library("RSQLite")

reader <- function (){
  print("Reading file")
  db <- dbConnect(RSQLite::SQLite(), "iMessage-Data.sqlite")
  print(dbListTables(db))
  print(dbListFields(db, 'Messages'))
}

reader()