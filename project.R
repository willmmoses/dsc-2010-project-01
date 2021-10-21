install.packages("xlsx")
library("xlsx")

reader <- function (){
  db <- xlsx.read("iMessage-Data_2021-09-16.xlsx")
  print(db)
}

reader()