library("dplyr")
library("lubridate")

reader <- function() {
  print("Reading file")
  messages <- read.csv('messages.csv')
  print("File read")
  return(messages)
}

tidy_up <- function(messages) {
  filtered_me <- messages %>%
    select(text, date, id, is_from_me, room_name) %>%
    mutate(formatted_date = as_datetime(date / 1000)) %>%
    mutate(wday = wday(formatted_date)) %>%
    mutate(id = case_when(is_from_me == 1 ~ '+16158308574', is_from_me == 0 ~ id))
  return(filtered_me)
}


stats <- function(messages) {
  by_person <- messages %>%
    filter(!id == "")
  by_id <- table(by_person$id)
  by_id <- sort(by_id, decreasing = TRUE)
  by_id <- head(by_id, 100)
  barplot(head(by_id,10), xlab = 'Sender', ylab = 'Number of Messages Sent')
  print(head(by_id))
}

main <- function() {
  messages <- reader()
  filtered_me <- tidy_up(messages)
  stats(filtered_me)
}

main()