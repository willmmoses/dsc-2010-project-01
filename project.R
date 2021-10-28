library("RSQLite")
library("dplyr")
library("dbplyr")
library("lubridate")

reader <- function() {
  print("Reading file")
  db <- dbConnect(RSQLite::SQLite(), "chat.db")
  messages <- tbl(db, 'message')
  my_messages <- messages %>%
    filter(handle_id == 0 & !is.na(text)) %>%
    mutate(epoch_date = (date/1000000) + 978307200000) %>% #reduces to miliseconds, adds offset between Core Date and Unix Epoch
    select(text, epoch_date) %>%
    arrange(desc(epoch_date)) %>%
    collect()
  print(my_messages)
  dbDisconnect(db)
}

reader()