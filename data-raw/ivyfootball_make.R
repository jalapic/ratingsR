df=data.frame(
  team1 = c('Penn','Penn','Penn','Harvard','Harvard','Princeton','Princeton','Brown','Brown','Columbia','Columbia','Dartmouth'),
  team2 = c('Cornell','Harvard','Princeton','Yale','Columbia','Dartmouth','Yale','Yale','Dartmouth','Brown','Cornell','Cornell'),
  t1 = c(34,17,42,14,34,23,24,35,14,28,30,20),
  t2 = c(0,7,7,10,14,11,17,21,7,14,20,17)
)

write.csv(df, "data-raw/ivyfootball.csv",row.names=F)
ivyfootball<-df
devtools::use_data(ivyfootball,overwrite=T)
