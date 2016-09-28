## Example Makefile

.PHONY: all
all: test.pdf test.html test.docx test2.pdf test-stitch.Rout test-stitch.pdf knitr-minimal-syntax.R  knitr-minimal.pdf

## produce pdf, html, docx from test.Rmd
test.pdf: ${@:.pdf=.Rmd}
test.html: ${@:.html=.Rmd}
test.docx: ${@:.docx=.Rmd}

## produce pdf from test2.rmd
test2.pdf: ${@:.pdf=.rmd}

## produce .Rout file - note that this is standard so does not need
##                      to be added unless more dependencies than the .R file
test-stitch.Rout: ${@:.Rout=.R}

## use stitch to produce pdf via rmarkdown (exactly as in RStudio)
test-stitch.pdf: ${@:.pdf=.R}

## comment following line if you place the 'r-rules.mk' file elsewhere
include r-rules.mk

## if you have 'r-rules.mk' in ~/lib directory uncomment line below and
##  comment include line above
## include ~/lib/r-rules.mk

## on windows either of these will work but, depending on your setup, the
##  first may produce a warning
## include c:/myLibrary/r-rules.mk
## include /cygdrive/c/myLibrary/r-rules.mk

## uncomment for testing rsync
##RSYNC_DESTINATION = ~/ownCloud/myProject
##RSYNC_FILES = r-rules.mk test.Rmd knitr-minimal.Rnw

RM=rm
RM_OPTS=-f

.PHONY: clean-all
clean-all: ##*.pdf *.html *.docx
	${RM} ${RM_OPTS} *.pdf *.html *.docx readme.tex

.PHONY: clean-severe
clean-severe: ##*.tex *.pdf *.html *.docx
	${RM} ${RM_OPTS} *.tex *.pdf *.html *.docx

## on MACOSX this may be necessary only if these not in PATH
## export LATEXMK=/Library/TeX/texbin/latexmk
## export RM=/usr/local/opt/coreutils/libexec/gnubin/rm
## export RM_OPTS=
## export CAT=/usr/local/opt/coreutils/libexec/gnubin/cat
## export CAT_OPTS=
## export PDFJAM=/Library/TeX/texbin/pdfjam
### export PDFJAM_OPTS=

