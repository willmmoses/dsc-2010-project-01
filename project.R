library("RSQLite")
library("dplyr")
library("dbplyr")
library("lubridate")

reader <- function() {
  print("Reading file")
  db <- dbConnect(RSQLite::SQLite(), "chat.db")
  messages <- tbl(db, 'message')
  messages %>%
    select(text) %>%
    mutate(text_split = strsplit(text, "[^\w\s]|_"))
}

reader()