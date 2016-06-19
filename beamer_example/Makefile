## test beamer examples
.PHONY: all
all: b1_Present.pdf b1_Notes.pdf b1_Article.pdf b1-2up.pdf b1-3up.pdf b1-4up.pdf b1-6up.pdf

## Changelog: Original version Sunday 2016-06-19 at 18:16:22

## main file is 'b1.Rnw'

## include ~/lib/common.mk
include ../common.mk

## NB: by default I put these preamble .Rnw files in ~/lib/beamerPreamble so
##     I know where the latest versions are
##     Could also use BEAMER_LIB = ./ or BEAMER_LIB=
##     which can be set since I use
##                    BEAMER_LIB = ~/lib/beamerPreamble
## BEAMER_LIB=
BEAMER_PRESENT = preamblePresent.Rnw
BEAMER_HANDOUT = preambleHandout.Rnw
BEAMER_ARTICLE = preambleArticle.Rnw
BEAMER_NOTES = preambleNotes.Rnw

## Note that all dependencies OK by default since b1.Rnw self contained

.PHONY: clean-all
clean-all:
	rm -fr *.pdf figure *.toc *.tex *.vrb *.snm *.out *.nav *.log *.aux
