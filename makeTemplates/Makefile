## Typical rules for use with R
## 
##   - take a copy and modify as necessary
##   - ideally put modified copy in a directory you access often or write
##     a script to grab a copy whenever you need

.PHONY: all
all: test.pdf test.html test.docx test2.pdf test-stitch.Rout test-stitch.pdf

## produce pdf, html, docx etc from test.Rmd
test.pdf: ${@:.pdf=.Rmd}
test.html: ${@:.html=.Rmd}
test.docx: ${@:.docx=.Rmd}
test.odt: ${@:.docx=.Rmd}
test.rtf: ${@:.docx=.Rmd}

## produce pdf from test2.rmd
test2.pdf: ${@:.pdf=.rmd}

## produce .Rout file - note that this is standard so does not need
##                      to be added unless more dependencies than the .R file
## test-stitch.Rout: ${@:.Rout=.R}

## use stitch to produce pdf notebook via rmarkdown (as in RStudio)
test-stitch.pdf: ${@:.pdf=.R}

## comment following line if you place the 'r-rules.mk' file elsewhere
## include r-rules.mk

## if you have 'r-rules.mk' in ~/lib directory uncomment line below and
##  comment include line above
include ~/lib/r-rules.mk

## on windows either of these will work but, depending on your setup, the
##  first may produce a warning
## include c:/myLibrary/r-rules.mk
## include /cygdrive/c/myLibrary/r-rules.mk
