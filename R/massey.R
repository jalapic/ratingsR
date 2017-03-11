#' Performs Massey Matrix Ranking Algorithm
#'
#' @param df A winner-loser dataframe
#'     There should be four or five columns. The first two are each
#'     competitor in a competition. The third columns are the points
#'     or goals scored by individual in the first columns. The
#'     fourth column are the points/goals scored by the individual
#'     in the second column. The optional fifth column is the points/goals
#'     differential.
#' @return A vector of ratings
#' @importFrom("stats", "aggregate")
#' @examples
#'  massey(bball)
#'  round(massey(ivyfootball),2)
#' @export

massey <- function(df){

  colnames(df)<-c("team1","team2","t1","t2")
  df$team1 <- as.character(df$team1)
  df$team2 <- as.character(df$team2)
  df$dif <- df$t1-df$t2

  #X
  dfa  <- df[c('team1','team2','dif')]
  dfb  <-  df[c('team2','team1','dif')]
  dfb$dif <- dfb$dif * -1
  colnames(dfa)<-colnames(dfb)<-c("team1","team2","dif")
  dfc <- rbind(dfa,dfb)
  mat <- table(dfc[ , c("team1","team2")])
  mat <- as.matrix(mat)
  mat <- mat[sort(colnames(mat)), sort(colnames(mat))]
  mat <- mat*-1
  diag(mat) <- rowSums(mat)*-1
  mat[nrow(mat), ] <- 1

  #y
  spread<-aggregate(dfc$dif, by=list(dfc$team1), FUN=sum)
  y<-spread[,2]
  names(y)<-spread[,1]
  y<-y[sort(names(y))]
  y[length(y)] <- 0

  ratings <- solve(mat, y)
  return(ratings)
}


