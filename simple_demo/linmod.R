## Filename: linmod.R
## Purpose: Fit linear model to simulated data
##
## To run in terminal use:  R CMD BATCH --vanilla linmod.R

## Created at:  Thu Sep 15 15:39:53 2016
## Author:      Peter Baker
## Hostname:    peterbakerlinux.sph.uq.edu.au
## Directory:   /home/pete/Data/dev/r-makefile-definitions/simple_demo/
## Licence:     GPLv3 see <http://www.gnu.org/licenses/>
##
## Change Log: 
##

library(ggplot2) # do I need this - e.g. can I get effects plot + data
library(car)
library(effects)

## load data and check attributes ----------------------------------
load("simple.RData")
ls.str()
comment(sim1)

## plot data -------------------------------------------------------

## data
gplot0 <-
  ggplot(sim1, aes(x=x, y=y)) +  # plot data
  geom_point(shape=1)            # Use hollow circles

## data + regression line
gplot1 <-
  gplot0 + geom_smooth(method=lm) # Add linear regression line 
                                  #  (by default includes 95% confidence region)
## gplot1                         # uncomment this line to see plot

## data + loess smoothed fit curve with confidence region
gplot2 <- 
  gplot0 + geom_smooth(col="red")  
## gplot2                    # uncomment this line to see plot

## fit linear model  -----------------------------------------------
lm1 <- lm(y ~ x, data = sim1)
summary(lm1)

## residual and effects plots from car/effects (uncomment to plot)
##qqPlot(lm1)
##residualPlots(lm1)
plot(allEffects(lm1))

## store analysis for reporting
(comment(lm1) <- paste("Linear model for simulated data stored at", date()))
save(lm1, gplot0, gplot1, gplot2, file = "linmod.RData")
