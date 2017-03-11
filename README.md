# ratingsR
Ranking and Rating Methods

This package includes functions for calculating the linear algebra based Colley and Massey ratings for win-loss data.  A detailed vignette is [available here](http://rpubs.com/jalapic/ratingsR).



#### Install 

`ratingsR` can be installed directly from GitHub.

```{r, eval=FALSE}
devtools::install_github('jalapic/ratingsR')
```

#### Colley Method
The basic Colley method uses `colley`.  Including spread in ratings uses `colley_spread`. Including ties in ratings uses`colley_ties`.  Weighting for time of win uses `colley_weight`.


#### Massey Method
The basic Massey method uses the function `massey`.


#### References

Some worked examples for the Colley ranking methods:
  
[1](http://www3.nd.edu/~apilking/Math10170/Information/Lectures%202015/Topic8Colley.pdf)
<br>
[2](http://public.gettysburg.edu/~cwessell/RankingPage/colley.pdf)


Some worked examples for the Massey ranking methods:
  
[3](http://public.gettysburg.edu/~cwessell/RankingPage/massey.pdf)
<br>
[4](http://www3.nd.edu/~apilking/Math10170/Information/Lectures%202015/Topic%209%20Massey's%20Method.pdf)

