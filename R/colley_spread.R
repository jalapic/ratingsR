#' Performs Colley Matrix Ranking Algorithm adapting for spread
#'
#' @param df A winner-loser dataframe
#'     There should be four or five columns. The first two are each
#'     competitor in a competition. The third columns are the points
#'     or goals scored by individual in the first columns. The
#'     fourth column are the points/goals scored by the individual
#'     in the second column. The optional fifth column is the points/goals
#'     differential.
#' @param spreadval The points differential above which to adjust win values
#' @param adjval The constant value to adjust wins by if they are above \code{spreadval}
#' @return A vector of ratings
#' @examples
#'  colley_spread(div3_2012_spread, spreadval=3, adjval=1.5)
#'  colley_spread(ivyfootball, 10, 1.5)
#' @section Further details:
#' All loss and ties are considered to be worth 0 wins
#' @export




colley_spread <- function(df, spreadval=NULL, adjval=NULL) {

dfd<-dfa<-dfb<-dfc<-winner<-loser<-.<-dif<-res<- cvals<-cval<-t1<-t2<-team1<-team2<-NULL

  df$dif<-df[,3]-df[,4]
  colnames(df) <- c("team1", "team2", "t1", "t2", "dif")


  # Work on vector - b
  # where c equals adjval if team i beat team j by spreadval or more points, 1 if team i beat team j by less than spreadval points, and 0 otherwise


    dfa  <- df[c('team1','team2','dif')]
    dfb  <-  df[c('team2','team1','dif')]
    dfb$dif <- dfb$dif * -1
    colnames(dfa)<-colnames(dfb)<-c("team1","team2","dif")
    dfc <- rbind(dfa,dfb)
    dfc$cval <- ifelse(dfc$dif>=spreadval, adjval, ifelse(dfc$dif>0 & dfc$dif<spreadval, 1, 0))
    cvals <- tapply(dfc$cval, dfc$team1, sum)
    cvals <- cvals[sort(names(cvals))]

  # Work on matrix - C
    dfd <- dfc[dfc$cval>0,]
    mat <- table(dfd[ , c("team1","team2")])
    mat <- as.matrix(mat)
    mat <- mat[sort(colnames(mat)), sort(colnames(mat))]
    Name <- colnames(mat)
    diag(mat) <- 0
    Len <- nrow(mat)
    mat <- matrix(as.numeric(as.matrix(mat)), nrow = Len)
    mat[is.na(mat)] <- 0
    w <- rowSums(mat)
    l <- colSums(mat)
    t <- w + l

    C <- diag(t + 2) - (mat+t(mat))

    # Solve
    b <- 1 + (cvals - l) / 2

    rating <- solve(C) %*% b
    rownames(rating) <- Name
    colnames(rating) <- "colley.rating"
    rating1<-as.vector(rating)
    names(rating1)<-Name
    return(rating1)
}
