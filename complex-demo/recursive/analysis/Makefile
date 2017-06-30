## Makefile created by 'dryworkflow' at Wed Oct 26 17:17:52 2016

.PHONY: all
all: summary_simple_csv.Rout analyse_simple_csv.Rout

## Summaries and analyses
summary_simple_csv.Rout: ${@:.Rout=.Rmd} ../readMergeData/clean_simple_csv.Rout

analyse_simple_csv.Rout: ${@:.Rout=.Rmd} ../readMergeData/clean_simple_csv.Rout

## remove intermediate files
.PHONY: cleanall
cleanall:
	rm -fr *~ *.Rout *.pdf *.html *.docx

include ~/lib/r-rules.mk
