.PHONY: all
all: report1.pdf report2.docx

## reports 1 & 2 depend on results of 'linmod.Rout' & '.Rmd' file(s)
report1.pdf: report1.Rmd linmod.Rout
report2.docx: report2.Rmd linmod.Rout

## data analysis:  dependent on 'linmod.R' and 'read.Rout'
linmod.Rout: linmod.R read.Rout

## read in data: depends on 'read.R' and 'simple.csv'
read.Rout: read.R simple.csv

## include R pattern rule definitions from file in $HOME/lib
## include ~/lib/r-rules.mk
include ../r-rules.mk

## remove all target, output and extraneous files
.PHONY: cleanall
cleanall:
	rm -f *~ *.Rout *.RData *.docx *.pdf *.html *-syntax.R

## R syntax files from .Rmd files - these are default in r-rules.mk
## report1-syntax.R: report1.Rmd
## report2-syntax.R: report2.Rmd
