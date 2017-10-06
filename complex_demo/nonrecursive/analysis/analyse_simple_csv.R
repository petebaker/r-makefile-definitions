### File:    analyse_simple_csv.R
### Purpose: analyse data from 'simple.csv' stored in 
###          in file clean_simple_csv.RData in directory '../data/derived'
###          and store in analyse_simple_csv.RData in directory '../data/derived'
### Created: Wed Oct 26 17:17:52 2016
### Author:  Peter Baker
### Licence: GPL3 see <http://www.gnu.org/licenses/>

### Changelog: -- insert comments and times re changes here --

## Specific libraries to be used. NB: can also be loaded in .Rprofile
library(ggplot2)
library(effects)
library(car)

### Read/Load data in file ../data/derived/clean_simple_csv.RData  ---------
load("../data/derived/clean_simple_csv.RData")

## Data structure(s)
## ls.str() # uncomment this line to see structure of all objects in workspace
comment(clean_data)
str(clean_data)

## example analysis ----------------------------------------------------

summary(lm1 <- lm(y ~ x, data = clean_data))
confint(lm1)

plot(allEff1 <- allEffects(lm1))
arm::coefplot(lm1)

(comment(lm1) <-
  paste("Simple lm analysis for 'simple.csv' data saved at", date()))

### Store simple analysis for subsequent analysis/reports  ----------------

save(lm1, allEff1,
  file = file.path("../data/derived", "analyse_simple_csv.RData"))
