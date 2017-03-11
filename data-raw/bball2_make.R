df <- data.frame(
  team1 = c("BING", "UVM", "BU", "ALBY", "STON", "UVM", "BU", "ME", "BING", "UVM", "BING", "ME", "UMBC"),
  team2 = c("HART", "UNH", "ME", "UMBC", "UNH", "ALBY", "HART", "UMBC", "ALBY", "BU", "STON", "HART", "UNH"),
  winner = c(0,1,0,1,1,1,0,1,0,0,0,0,1),
  time = c(1,1,1,1,4,4,4,4,6,7,8,8,8)
)


write.csv(df, "data-raw/bball2.csv", row.names=F)
bball2<-df
devtools::use_data(bball2,overwrite = TRUE)
