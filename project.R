library("RSQLite")
library("RMariaDB")
library("dplyr")
library("dbplyr")
library("lubridate")
library("stringr")
library("stringi")

reader <- function() {
  print("Reading file")
  db <- dbConnect(RSQLite::SQLite(), "chat.db")
  messages <- tbl(db, 'message')
  my_messages <- messages %>%
    filter(handle_id == 0 & !is.na(text)) %>%
    mutate(epoch_date = (date/1000000) + 978307200000) %>% #reduces to miliseconds, adds offset between Core Date and Unix Epoch
    arrange(desc(epoch_date)) %>%
    collect() %>%
    mutate(split_text = str_split(text, "[^[A-Za-z0-9]]")) %>%
    select(split_text -matches(""), epoch_date) %>%
    collect()

  print(my_messages$split_text[1])
  dbDisconnect(db)
}

reader()