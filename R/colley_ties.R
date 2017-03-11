#' Performs Colley Matrix Ranking Algorithm allowing ties
#'
#' @param df A winner-loser dataframe
#'     There should be four columns. The first two are each
#'     competitor in a competition. The third columns are the points
#'     or goals scored by individual in the first columns. The
#'     fourth column are the points/goals scored by the individual
#'     in the second column.
#' @return A vector of ratings
#' @importFrom magrittr "%>%"
#' @importFrom reshape2 "acast"
#' @examples
#'  colley_ties(epl2014_15)
#' @section Further details:
#' ties are considered to be half-wins.
#' @export


colley_ties <- function(df) {

  . <-cval <-cval1<- cval2<-t1<-t2<-team1<-team2<-NULL

  colnames(df) <- c("team1", "team2", "t1", "t2")

    # Work on vector - b

  df %>% mutate(cval1 = ifelse(t1>t2, 1, ifelse(t1==t2, 0.5, 0)),
                 cval2 = ifelse(t2>t1, 1, ifelse(t1==t2, 0.5, 0))
  ) -> df

  df1 <- rbind(df %>% select(team1, team2, cval=cval1),
               df %>% select(team1=team2, team2=team1, cval=cval2)
  ) %>% arrange(team1, team2)


  cvals <- df1 %>%
    group_by(team1) %>%
    summarize(cvals = sum(cval)) %>%
    mutate(team1 = as.character(team1)) %>%
    arrange(team1) %>%
    .$cvals


  tx <- df1 %>%
    group_by(team1) %>%
    summarize(total = n()) %>%
    mutate(team1 = as.character(team1)) %>%
    arrange(team1) %>%
    .$total

  l <- tx-cvals


  # Work on matrix - C
  # ensure square and ordered.
  dfa  <- df[c('team1','team2','cval1')]
  dfb  <-  df[c('team2','team1','cval2')]
  colnames(dfa)<-colnames(dfb)<-c("team1","team2","val")
  dfc <- rbind(dfa,dfb)
  dfd <- aggregate(dfc$val, as.list(dfc[,1:2]), FUN = sum)
  mat <- reshape2::acast(dfd, team1~team2, value.var="x",drop=FALSE,fill=0)
  Name <- sort(colnames(mat))
  mat <- mat[Name,Name]

  C <- diag(tx + 2) - (mat+t(mat))

  # Solve
  b <- 1 + (cvals - l) / 2

  rating <- solve(C) %*% b
  colnames(rating) <- "colley.rating"
  rating1<-as.vector(rating)
  names(rating1)<-rownames(rating)
  return(rating1)

}
