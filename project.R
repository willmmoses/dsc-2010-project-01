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
    select(text, date, sender, room_name) %>%
    mutate(formatted_date = as_datetime(date)) %>%
    mutate(wday = wday(formatted_date))
  return(filtered_me)
}


stats <- function(messages) {

}

main <- function() {
  messages <- reader()
  filtered_me <- tidy_up(messages)
}

main()