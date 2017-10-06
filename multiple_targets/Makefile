## File: multiple_targets/Makefile
## What: how to write a 'multiple targets' Makefile using a sentinel file
##       and call to the atomic function
## NB:   You may need to run demo in ../simple_demo to save simple.RData

## include r-rules function definitions in $HOME/lib
include ../r-rules-functions.mk

.PHONY: all
all: plots.Rout plots0.png plots1.pdf plots2.jpg

## call the atomic function to treat multiple targets as a single target
## NB: first argument: space separated list of target files
##     second   "    : dependency files
$(call atomic,plots.Rout plots0.png plots1.pdf plots2.jpg,\
  plots.R simple.RData)
	${R} ${R_FLAGS} ${R_OPTS} $<

## remove all target, output and extraneous files
.PHONY: cleanall
cleanall:
	rm -f *~ *.Rout *.png *.pdf *.jpg .sentinel* .Rhistory

## include R pattern rule definitions from file in $HOME/lib
include ../r-rules.mk
