#' Performs Colley Matrix Ranking Algorithm adapting for time
#'
#' @param df A winner-loser dataframe
#'     There should be four columns. The first two are each
#'     competitor in a competition. The third columns should
#'     have a 1 if the team in the first column is the winner and
#'     a 0 if the team in the second column is the winner. The
#'     fourth column is a time unit.
#' @param method The method to adjust weights of wins based on time.
#'    Can be \code{linear}, \code{exp}, \code{log} or  \code{step}.
#' @param ts The time unit at which the step function goes from weighting
#' wins as 1 to 2.
#' @return A vector of ratings
#' @examples
#'  colley_weight(bball2, 'linear')
#'  colley_weight(bball2, 'log')
#'  colley_weight(bball2, 'exp')
#'  colley_weight(bball2, 'step', ts=5)
#' @section Further details:
#' Method not yet implemented for ties.
#' @export

colley_weight <- function(df, method="linear",ts=NULL){

  colnames(df)<-c("team1","team2","winner","time")

  df$team1 <- as.character(df$team1)
  df$team2 <- as.character(df$team2)

  if(method=="linear") { df$meth <- (df$time - 0) / (max(df$time) - 0) }
  if(method=="log") { df$meth <- log( (df$time - 0) / (max(df$time) - 0) + 1) }
  if(method=="exp") { df$meth <- exp( (df$time - 0) / (max(df$time) - 0)) }
  if(method=="step") { df$meth <- ifelse(df$time<=ts, 1, 2) }

  wina <- df[df$winner==1,c('team1','team2','meth')]
  winb <- df[df$winner==0,c('team2','team1','meth')]
  colnames(wina)<-colnames(winb)<-c("teamA","teamB","meth")
  winners<-rbind(wina,winb)

  losa <- df[df$winner==0,c('team1','team2','meth')]
  losb <- df[df$winner==1,c('team2','team1','meth')]
  colnames(losa)<-colnames(losb)<-c("teamA","teamB","meth")
  losers<-rbind(losa,losb)

  totalgames <- rbind(winners[c(1,3)],losers[c(1,3)])
  totalgames.sum <- aggregate(totalgames$meth, list(totalgames$teamA), FUN = sum)
  diagvals <-as.vector(totalgames.sum[,2])+2
  names(diagvals)<- totalgames.sum[,1]
  diagvals <- diagvals[sort(names(diagvals))]

  allgames <- rbind(winners,losers)

  mat <- reshape2::acast(allgames, teamA~teamB, value.var="meth",drop=FALSE,fill=0)
  ids<-sort(unique(c(df$team1,df$team2)))
  mat<- mat[ids,ids]*-1
  diag(mat)<-diagvals
  C <- mat

  #b
  bwin<-aggregate(winners$meth, list(winners$teamA), FUN = sum)
  blos<-aggregate(losers$meth, list(losers$teamA), FUN = sum)

  bwinsadd <- ids[!ids %in% bwin[,1]]
  bwin <- rbind(bwin,data.frame('Group.1'=bwinsadd,'x'=0))
  bwin <-  bwin[order(bwin[,1]),]

  blosadd <- ids[!ids %in% blos[,1]]
  blos <- rbind(blos,data.frame('Group.1'=blosadd,'x'=0))
  blos <-  blos[order(blos[,1]),]

  winloss <- cbind(bwin,blos[,2])
  colnames(winloss)<-c("team","win","loss")

  b <- (0.5* (winloss$win  - winloss$loss))+ 1

  # Solve
  rating <- solve(C) %*% b
  colnames(rating) <- "colley.rating"
  rating1<-as.vector(rating)
  names(rating1)<-ids
  return(rating1)

}

