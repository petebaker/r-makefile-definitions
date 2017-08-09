## Filename: read.R
## Purpose: read in data from 'simple.csv'
##
## To run in terminal use:  R CMD BATCH --vanilla read.R

## Created at:  Wed Sep 14 13:09:19 2016
## Author:      Peter Baker
## Licence:     GPLv3 see <http://www.gnu.org/licenses/>
##
## Change Log: 
##

## ## generate some simple regression data for simple.csv
## N <- 50
## x <- 1:N
## y <- 5 + 2*x + 10*rnorm(N)
## ## transpose x & y for 40th value to produce an obvious outlier
## df1$x[40] <- df1$y[40]
## df1$y[40] <- 40
## df1 <- data.frame(x = x, y = y)
## write.csv(df1, row.names = FALSE, file = "simple.csv")

## read data
sim1 <- read.csv("simple.csv")
## structure
str(sim1)
## comment for simulated data
(comment(sim1) <- paste("Simulated data read and stored at", date()))

save(sim1, file = "simple.RData")
