#' Performs Colley Matrix Ranking Algorithm
#'
#' @param x A winner-loser matrix or dataframe
#' @return A vector of ratings
#' @importFrom reshape2 "acast"
#' @examples
#' colley(div3_2012)
#' colley(ivyfootball)
#' @section Further details:
#' Each cell of the input matrix represents number of wins by rows
#' versus columns
#' @export



colley <- function(x) {

  if(!is.matrix(x)){
    df <- x
    colnames(df)<-c("team1","team2","t1","t2")
    df$team1 <- as.character(df$team1)
    df$team2 <- as.character(df$team2)
    df$dif <- df$t1-df$t2
    dfa  <- df[c('team1','team2','dif')]
    dfb  <-  df[c('team2','team1','dif')]
    dfb$dif <- dfb$dif * -1
    colnames(dfa)<-colnames(dfb)<-c("team1","team2","dif")
    dfc <- rbind(dfa,dfb)
    dfc$dif[dfc$dif>0]<-1
    dfc$dif[dfc$dif<=0]<-0
    dfd <- aggregate(dfc$dif, as.list(dfc[,1:2]), FUN = sum)
    mat <- reshape2::acast(dfd, team1~team2, value.var="x",drop=FALSE,fill=0)

  }

  if(is.matrix(x)){
    mat<-x
  }

  Name <- colnames(mat)
  diag(mat) <- 0
  Len <- nrow(mat)
  mat <- matrix(as.numeric(as.matrix(mat)), nrow = Len)
  mat[is.na(mat)] <- 0
  w <- rowSums(mat)
  l <- colSums(mat)
  t <- w + l

  C <- diag(t + 2) - (mat+t(mat))
  b <- 1 + (w - l) / 2
  rating <- solve(C) %*% b
  rownames(rating) <- Name
  colnames(rating) <- "colley.rating"
  rating1<-as.vector(rating)
  names(rating1)<-Name
  return(rating1)
}
