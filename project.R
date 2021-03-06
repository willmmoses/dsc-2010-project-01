library("dplyr")
library("lubridate")
library(data.table)

reader <- function() {
  print("Reading file")
  messages <- read.csv('messages.csv')
  print("File read")
  return(messages)
}

tidy_up <- function(messages) {
  filtered_me <- messages %>%
    select(text, date, id, is_from_me, chat_guid, cache_has_attachments, associated_message_guid, is_emote) %>%
    mutate(formatted_date = as_datetime(date / 1000)) %>%
    mutate(wday = wday(formatted_date)) %>%
    mutate(id = case_when(is_from_me == 1 ~ '+16158308574', is_from_me == 0 ~ id)) %>%
    filter(!id == "")
  return(filtered_me)
}


top10 <- function(messages) {
  by_id <- table(messages$id)
  by_id <- sort(by_id, decreasing = TRUE)
  by_id <- head(by_id, 100)
  with_me <- barplot(head(by_id, 10), ylim = c(0, 100000), xlab = 'Sender', ylab = 'Number of Messages Sent')
  with_me_y <- as.matrix(head(by_id, 10))
  text(with_me, with_me_y + 3000, labels = as.character(with_me_y))
  without_me <- barplot(tail(head(by_id, 11), 10), ylim = c(0, 30000), xlab = 'Sender', ylab = 'Number of Messages Sent')
  without_me_y <- as.matrix(tail(head(by_id, 11), 10))
  text(without_me, without_me_y + 1000, labels = as.character(without_me_y))
  print(head(by_id))
}

sprangbreak <- function(messages) {
  just_chat <- messages %>%
    filter(chat_guid == 'iMessage;+;chat83626697018543747')
  by_id <- table(just_chat$id)
  by_id <- sort(by_id, decreasing = TRUE)
  with_me <- barplot(by_id, ylim = c(0, 18000), xlab = 'Sender', ylab = 'Number of Messages Sent in Chat per Person')
  with_me_y <- as.matrix(by_id)
  text(with_me, with_me_y + 500, labels = as.character(with_me_y))
  print(head(by_id))
  by_day <- table(just_chat$wday)
  # by_day <- sort(by_day, decreasing = TRUE)
  with_me <- barplot(by_day, ylim = c(0, 12000), xlab = 'Day of Week', ylab = 'Number of Messages Sent in Chat per Day')
  with_me_y <- as.matrix(by_day)
  text(with_me, with_me_y + 500, labels = as.character(with_me_y))
}

messages_by_day <- function(messages) {
  actual_text <- messages %>%
    filter(id == '+16158308574')
  by_day <- table(actual_text$wday)
  sent <- barplot(by_day, ylim = c(0, 18000), xlab = 'Day of Week', ylab = 'Number of Messages Sent per Day')
  sent_y <- as.matrix(by_day)
  text(sent, sent_y + 500, labels = as.character(sent_y))
  actual_text <- messages %>%
  filter(id != '+16158308574')
  by_day <- table(actual_text$wday)
  received <- barplot(by_day, ylim = c(0, 26000), xlab = 'Day of Week', ylab = 'Number of Messages Received per Day')
  received_y <- as.matrix(by_day)
  text(received, received_y + 500, labels = as.character(received_y))
  cor.test(sent_y, received_y)
}

messages_over_time <- function(messages) {
  by_date <- messages %>%
    mutate(just_date = as_date(formatted_date))
  by_date_sent <- by_date %>%
    filter(id == '+16158308574')
  by_date_received <- by_date %>%
    filter(id != '+16158308574')
  just_date_sent <- cumsum(table(by_date_sent$just_date))
  just_date_received <- cumsum(table(by_date_received$just_date))
  plot(just_date_sent, type = 'l', col = 'blue', ylim = c(0, 160000), xlim = c(0, 1800), xlab = 'Time(days)', ylab = 'Number of messages')
  lines(just_date_received, type = 'l', col = 'grey')
  legend(1, 150000, legend = c('Sent', 'Received'), col = c('blue', 'grey'), lty = 1:1, cex = 0.9)
}

main <- function() {
  messages <- reader()
  filtered_me <- tidy_up(messages)
  top10(filtered_me)
  messages_by_day(filtered_me)
  messages_over_time(filtered_me)
}

main()