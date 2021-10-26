library("RSQLite")
library("dplyr")
library("dbplyr")

reader <- function (){
  print("Reading file")
  # db <- dbConnect(RSQLite::SQLite(), "iMessage-Data.sqlite")
  db <- dbConnect(RSQLite::SQLite(), "chat.db")
  messages <- tbl(db, 'message')
  # result <- dbSendQuery(db, "select m.handle_id, m.text, m.date from message m INNER JOIN chat_message_join cmj ON cmj.chat_id = 1 AND m.ROWID = cmj.message_id")
  # print(dbFetch(res))
  # data <- dbFetch(result)
  # print(dbFetch(res))
  messages %>%
    group_by(handle_id) %>%
    summarize(Avg_Message_Length = mean(nchar(text))) %>%
    collect()
  # filter(handle_id = '1')
}

reader()