### File:    summary_simple_csv.R
### Purpose: summary data from 'simple.csv' stored in 
###          in file clean_simple_csv.RData in directory '../data/derived'
###          and store in summary_simple_csv.RData in directory '../data/derived'
### Created: Wed Oct 26 17:17:52 2016
### Author:  Peter Baker
### Licence: GPL3 see <http://www.gnu.org/licenses/>

### Changelog: -- insert comments and times re changes here --

## Specific libraries to be used. NB: can also be loaded in .Rprofile
library(car)
library(RcmdrMisc)
library(ggplot2)

### Read/Load data in file ../data/derived/clean_simple_csv.RData  ---------
load("../data/derived/clean_simple_csv.RData")

## Data structure(s)
## ls.str() # uncomment this line to see structure of all objects in workspace
str(clean_data)

## Example summaries  --------------------------------------------------

summary(clean_data)

RcmdrMisc::numSummary(clean_data)
sumData <- RcmdrMisc::numSummary(clean_data)
sumData

### Example simple plot ------------------------------------------------

scatterplot(y ~ x, data = clean_data)

gg1 <- ggplot(clean_data, aes(x=x, y=y)) + geom_point() +
  geom_smooth(method = "lm") + geom_smooth()
gg1

(newComment <- c(paste("Summaries for 'clean_data' saved at", date()),
                 comment(clean_data)))

comment(clean_data) <- newComment

### Store summary data for subsequent analysis/reports  ----------------

save(clean_data, gg1, sumData, 
     file = file.path("../data/derived", "summary_simple_csv.RData"))

