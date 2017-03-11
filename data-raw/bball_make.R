df<-
  data.frame(
    team1  = c("Badin", "Badin","Badin","Badin",
               "Farley","Farley","Farley",
               "Lyons","Lyons",
               "McGlinn"),
    team2 = c("Farley","Lyons","McGlinn","Pangborn",
              "Lyons","McGlinn","Pangborn",
              "McGlinn","Pangborn",
              "Pangborn"),
    t1 = c(37,51,37,30,
           64,55,57,
           37,33,44),
    t2 = c(82,54,68,75,46,47,37,35,60,82)
  )

df
write.csv(df, "data-raw/bball.csv", row.names=F)
bball<-df
devtools::use_data(bball,overwrite = TRUE)
