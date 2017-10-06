## Filename: plots.R
## Purpose: Produce several plots for simulated data for as demo for
##          multiple targets in GNU make 
##
## To run in terminal use:  R CMD BATCH --vanilla plots.R

## Created at:  Mon 2016-11-07 at 12:50:57
## Author:      Peter Baker
## Hostname:    peterbakerlinux.sph.uq.edu.au
## Directory:   /home/pete/Data/dev/r-makefile-definitions/multiple_targets/
## Licence:     GPLv3 see <http://www.gnu.org/licenses/>
##
## Change Log: 
##

library(ggplot2)

## load data and check attributes ----------------------------------
load("simple.RData")
ls.str()
comment(sim1)

## plots  -------------------------------------------------------

## data
gplot0 <-
  ggplot(sim1, aes(x=x, y=y)) +  # plot data
  geom_point(shape=1)            # Use hollow circles
## gplot0                         # uncomment this line to see plot

## data + regression line
gplot1 <-
  gplot0 + geom_smooth(method=lm) # Add linear regression line 
                                  #  (by default includes 95% confidence region)
## gplot1                         # uncomment this line to see plot

## data + loess smoothed fit curve with confidence region
gplot2 <- 
  gplot0 + geom_smooth(col="red")  
## gplot2                    # uncomment this line to see plot

## output multiple targets ----------------------------------------

## png file
png("plots0.png")
gplot0
dev.off()

## pdf file plots1.pdf
pdf("plots1.pdf")
gplot1
dev.off()

## jpg file plots2.jpg
jpeg("plots2.jpg")
gplot2
dev.off()
