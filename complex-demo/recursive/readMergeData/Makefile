## Makefile created at Wed Oct 26 17:17:52 2016 to read/clean data
## Could generate *.Rout or .docx files instead by changing target 'all'

.PHONY: all
all: clean_simple_csv.Rout

## Read data and store for cleaning
read_simple_csv.Rout: ${@:.Rout=.R} ../data/original/simple.csv

## Clean data and store for analysis
clean_simple_csv.Rout: ${@:.Rout=.R} read_simple_csv.Rout

## remove intermediate files
.PHONY: cleanall
cleanall: ; rm -f *~ *.Rout *.RData *.pdf *.docx *.html

include  ~/lib/r-rules.mk
