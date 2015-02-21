## test of using make only - no bash script
## NB: $< doesn't seem to always work very well but ${@:.pdf=.Rmd} does

.PHONY: all
all: test.pdf test.html test.docx test2.pdf test-stitch.Rout test-stitch.pdf

## produce pdf, html, docx from test.Rmd
test.pdf: ${@:.pdf=.Rmd}
test.html: ${@:.html=.Rmd}
test.docx: ${@:.docx=.Rmd}

## produce pdf from test2.rmd
test2.pdf: ${@:.pdf=.rmd}

## produce .Rout file - note that this is standard so does not need
##                      to be added unless more dependencies than the .R file
## test-stitch.Rout: ${@:.Rout=.R}

## use stitch to produce pdf via rmarkdown (exactly as in RStudio)
test-stitch.pdf: ${@:.pdf=.R}

## comment following line if you place the 'common.mk' file elsewhere
include common.mk

## if you have 'common.mk' in ~/lib directory uncomment line below and
##  comment include line above
## include ~/lib/common.mk

## on windows either of these will work but, depending on your setup, the
##  first may produce a warning
## include c:/myLibrary/common.mk
## include /cygdrive/c/myLibrary/common.mk
