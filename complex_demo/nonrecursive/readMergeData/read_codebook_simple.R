### File:    read_codebook_simple.R
### Purpose: read codebook  'simple_codebook.csv'
###          in directory '../data/codebook'
###          and store in 'codebook_simple.RData' in 
### Created: Wed Oct 26 17:17:52 2016 by 'dryworkflow::createProjectSkeleton'
### Author:  -- Insert author here --
### Licence: GPL3 see <http://www.gnu.org/licenses/>

### Changelog: -- insert comments and times re changes here --

## Specific libraries to be used. NB: can also be loaded in .Rprofile
library(dryworkflow) # Some of these libraries load others too
library(plyr)
library(reshape2)
library(lubridate)
library(stringr)
library(Hmisc)
library(car)
library(compare)

## Source any R functions in own library directory
## Add any extra function files here or comment or delete to not load
## NB: You can source (load) all files in a directory 'myLib' with
##     lapply(Sys.glob(file.path("myLib", "*.R")), source)
source(file.path("..", "lib", ""))

### Read in codebook file 'simple_codebook.csv' in '../data/codebook'
codebook_simple <- readCodeBook("../data/codebook/simple_codebook.csv")

## Data structure
str(codebook_simple)

### You can insert any transformations here or tidy up variable names
### and so on but ideally these should be carried out when cleaning
### the data so that an unchanged original version is stored initially
### but minor tweaks could be inserted here

### Store data for subsequent analysis
comment(codebook_simple) <-
  paste("Read codebook 'simple_codebook.csv' in '../data/codebook' at",
        date())

save(codebook_simple,
  file = file.path("../data/derived", "codebook_simple.RData"))
