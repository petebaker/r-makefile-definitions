### File:    clean_simple_csv.R
### Purpose: clean data from 'simple.csv' stored in 
###          in file orig_simple_csv.RData in directory '../data/derived'
###          and store in clean_simple_csv.RData in directory '../data/derived'
### Created: Wed Oct 26 17:17:52 2016
### Author:  Peter Baker
### Licence: GPL3 see <http://www.gnu.org/licenses/>

### Changelog: -- insert comments and times re changes here --

## Specific libraries to be used. NB: can also be loaded in .Rprofile
library(ggplot2)

## Source any R functions in own library directory
## Add any extra function files here or comment or delete to not load
## NB: You can source (load) all files in a directory 'myLib' with
##     lapply(Sys.glob(file.path("myLib", "*.R")), source)
##source(file.path("..", "lib", ""))

### Read/Load data in file ../data/derived/orig_simple_csv.RData  ---------
load("../data/derived/orig_simple_csv.RData")

## Data structure(s)
## ls.str() # uncomment this line to see structure of all objects in workspace
str(orig_data)

## take a copy useful while working interactively if accidentally alter
simple_copy <- orig_data  

## Clean data  -------------------------------------------------

##' Insert any transformations here, tidy up variable names, perform
##' checks, modify values (and ideally date and document here and
##' elsewhere)

summary(orig_data)

ggplot(orig_data, aes(x=x, y=y)) + geom_point() + geom_smooth(method = "lm")

##' Clearly an outlier so perhaps just list the data, go back to
##' original records, talk to researcher etc but we know it's actually
##' 40th record transposed
orig_data[35:45,]

##' Could fix this here - but can do it later to demonstrate make in action
clean_data <- orig_data
##' Uncomment next three lines to fix the data and show changes
## clean_data[40,] <- orig_data[40, c(2,1)]
## clean_data[35:45,]
## ggplot(clean_data, aes(x=x, y=y)) + geom_point() + geom_smooth(method = "lm")

### Store cleaned data for subsequent analysis  -----------------------

(oldComment <- paste("Original: ", comment(orig_data)))
(newComment  <-
   paste("Data 'orig_data' cleaned at", date()))
comment(clean_data) <- c(newComment, oldComment)
comment(clean_data)

save(clean_data,
     file = file.path("..", "data", "derived", "clean_simple_csv.RData"))
