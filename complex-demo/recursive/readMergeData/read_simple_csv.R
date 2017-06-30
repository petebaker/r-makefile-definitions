### File:    read_simple_csv.R
### Purpose: read from data file 'simple.csv' in directory '../data/original'
###          and store in 'orig_simple_csv.RData' in directory '../data/derived'
### Created: Wed Oct 26 17:17:52 2016
### Author:  Peter Baker
### Licence: GPL3 see <http://www.gnu.org/licenses/>

### Changelog: -- insert comments and times re changes here --

## Specific libraries to be used. NB: can also be loaded in .Rprofile

## Source any R functions in own library directory
## Add any extra function files here or comment or delete to not load
## NB: You can source (load) all files in a directory 'myLib' with
##     lapply(Sys.glob(file.path("myLib", "*.R")), source)
## source(file.path("..", "lib", ""))

### Read in data file 'simple.csv' in '../data/original'
orig_data <- read.csv("../data/original/simple.csv")

## Data structure
str(orig_data)

### You can insert any transformations here or tidy up variable names
### and so on but ideally these should be carried out when cleaning
### the data so that an unchanged original version is stored initially
### and can always be used without rereading original data unless it
### changes

### Store data for subsequent analysis
comment(orig_data) <-
  paste("Data read from 'simple.csv' at", date())

save(orig_data,
  file = file.path("..", "data", "derived", "orig_simple_csv.RData"))
