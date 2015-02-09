## test of using make only - no bash script
## NB: $< doesn't seem to work very well but ${@:.pdf=.Rmd} does

.PHONY: all
all: test.pdf test.html test.docx test2.pdf test-stitch.pdf

## produce pdf, html, docx from test.Rmd
test.pdf: ${@:.pdf=.Rmd}
test.html: ${@:.html=.Rmd}
test.docx: ${@:.docx=.Rmd}

## produce pdf from test2.rmd
test2.pdf: ${@:.pdf=.rmd}

## use stitch to produce pdf via rmarkdown (exactly as in RStudio)
test-stitch.pdf: ${@:.pdf=.R}

## if you have common in ~/lib directory uncomment line below and comment
include common.mk
##include ~/lib/common.mk

