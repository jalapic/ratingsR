# ratingsR
Ranking and Rating Methods

This package includes functions for calculating the Colley and Massey ratings for win-loss data.  A detailed vignette is [available here](http://rpubs.com/jalapic/ratingsR).



#### Install 

`ratingsR` can be installed directly from GitHub.

```{r, eval=FALSE}
devtools::install_github('jalapic/ratingsR')
```

<br>

```{r}
library(ratingsR)
```

<br><br>



#### Colley Method

The `colley` function will calculate the Colley ratings for individuals based on win-loss data. It ignores ties. The input can either i) a square matrix of wins and losses (winners in rows and losers in columns, with all individuals in rows and columns), ii) a win-loss dataframe with the first two columns being the individuals/teams and the 3rd and 4th columns being the goals/points scored by individuals/teams in the 1st and 2nd rows respectively. Any other columns will be ignored.

`div3_2012` is an example win-loss matrix from 2012 div III football. Numbers indicate the total wins by team in the rows against teams in the columns.

```{r}
div3_2012
```
<br>

`div3_2012_spread` gives the results between each team. This dataframe also includes a fifth column giving the spread differential between each team.

```{r}
div3_2012_spread
```
<br>

To calculate Colley ratings, we can do the following:

```{r}
colley(div3_2012)
```

```{r}
colley(div3_2012_spread)
```
<br><br>

#### Colley Method accounting for Spread

The value of wins can be adjusted according to spread with the Colley method using the `colley_spread` function. The input is a win-loss dataframe as above. Two additional parameters are required. First, `spreadval` - the spread threshold value above which to consider a win as differentially weighted, and secondly, `adjval` - the adjusted weight of the win.  For example, to give wins a value of 1.5 wins if the spread is higher than 7: 

```{r}
colley_spread(div3_2012_spread, spreadval=7, adjval=1.5)
```

<br><br>

#### Colley Method with Ties

The function `colley_ties` enables calculation of Colley ratings accounting for ties. Ties are considered to be a half-win for each team. The input is a win-loss dataframe as above. When there are no ties, the resulting ratings will be the same as for the `colley` function. Here is an example using all 380 results from the 2014-15 EPL soccer season:

```{r}
head(epl2014_15)

```

<br>

```{r}
colley_ties(epl2014_15)
```

<br>

Here is a comparison of how accounting for ties adjusts the ratings value:

```{r, fig.width=5,fig.height=4}
plot(colley_ties(epl2014_15), colley(epl2014_15), xlab = "Colley with Ties", ylab="Basic Colley")
```

<br><br>

#### Colley Method with Weighting Wins by Time

Alternatively, wins can be weighted according to time. This might be needed when wins closer in time need to be considered more significant than wins that occurred earlier. There are four different weighting methods - `linear`, `exp`, `log`, or `step`. They differ in how much to devalue wins that occurred earliest. The `step` method requires an additional parameter `ts` which states at which time unit to consider wins worth twice the wins that occurred previously.  The `colley_weight` function performs these methods.  These methods require an input dataframe of four columns. The first two are the teams. The 3rd column is who won (1 for team1, 0 for team2). The fourth column is the time interval.  This method does not work for ties.

An example from college basketball:


```{r}
bball2
```

<br>

```{r}
colley_weight(bball2, 'linear')
```

<br>

```{r}
colley_weight(bball2, 'exp')
```
<br>

```{r}
colley_weight(bball2, 'log')
```

<br>

```{r}
colley_weight(bball2, 'step', ts='5')
```

<br><br>


#### Massey Method

The Massey method can be calculated using the `massey` function. The Massey method accounts for spread in its calculations. The input is a win-loss dataframe with at least four columns. Here is an example from the first few games of the 2009 Ivy Football League.

```{r}
ivyfootball
```

<br>

To  calculate the ratings, we do the following:

```{r}
massey_ivy<- massey(ivyfootball)
round(massey_ivy,2)
```

<br>

Comparing the Massey and Colley ratings we get:

```{r,fig.width=5,fig.height=4}
plot(colley(ivyfootball), massey(ivyfootball), xlab="Colley Rating", ylab="Massey Rating")
```

<br><br>

#### References

Some worked examples for the Colley ranking methods:
  
[1](http://www3.nd.edu/~apilking/Math10170/Information/Lectures%202015/Topic8Colley.pdf)
<br>
[2](http://public.gettysburg.edu/~cwessell/RankingPage/colley.pdf)


Some worked examples for the Massey ranking methods:
  
[3](http://public.gettysburg.edu/~cwessell/RankingPage/massey.pdf)
<br>
[4](http://www3.nd.edu/~apilking/Math10170/Information/Lectures%202015/Topic%209%20Massey's%20Method.pdf)

