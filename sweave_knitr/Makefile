## Typical rules for use with R
## 
##   - take a copy and modify as necessary
##   - ideally put modified copy in a directory you access often or write
##     a script to grab a copy whenever you need

## include gmsl # standard library

.PHONY: all
all: sw

## Downloaded: *knitr* knitr-minimal.Rnw, 002-minimal.Rnw and 
##            *sweave* foo.Rnw, exampleSweave.Rnw

.PHONY: sw
sw: foo.pdf exampleSweave.pdf

.PHONY: kn
kn: knitr-minimal.pdf 002-minimal.pdf

## need a better way to define sweave versus knitr and programmatically too
## set SWEAVE_ENGINE before calling file else doesn't work
## could place at top of file if ALWAYS use it but not otherwise
SWEAVE_ENGINE=Sweave
include r-rules.mk

.PHONY: clean-all
clean-all:
	rm -f *.pdf *.Rout *.log *.aux *.bbl *~ *.html *.docx *.out *.tex

## NB: to clean up Sweave/latex auxillary files you need to use the -f
## option to force clean since .tex file removed - need to use ifdef
## on that too (might need for debugging) so use

## latexmk -c -f exampleSweave
## latexmk -c -f foo
