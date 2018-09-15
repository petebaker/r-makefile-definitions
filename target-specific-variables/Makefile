.PHONY: all
all: minimal.html minimal-1.html minimal-2.html minimal-3.html # clean-rmd

## NB: make clean-rmd  will force the rebuild because minimal-1.Rmd missing etc

##include ~/lib/r-rules.mk
include r-rules.mk
RMARKDOWN_HTML_EXTRAS=

## so there is two issues
## 1) passing extra parameters via RMARKDOWN_HTML_EXTRAS
##    DONE via target specific variable RMARKDOWN_HTML_EXTRAS
## 2) Prob: changing the output file given that minimal.Rmd already made
##    DONE via cp to create relevant .Rmd file 

## rules to create intermediate .Rmd's etc -------------------------------

## create intermediate .Rmd if necessary
minimal-1.Rmd minimal-2.Rmd minimal-3.Rmd: minimal.Rmd
	cp $< $@

## remove output and/or intermediate .Rmd files
.PHONY: clean-rmd
clean-rmd:
	${RM} ${RM_OPTS} minimal-?.Rmd
.PHONY: clean-reports
clean-reports:
	${RM} ${RM_OPTS} *.html minimal-?.Rmd

## define different target rules for different output files ------------

minimal.html: RMARKDOWN_HTML_EXTRAS =, params=list(VALUE_1='aa')
minimal.html: minimal.Rmd

minimal-1.html: RMARKDOWN_HTML_EXTRAS =, params=list(VALUE_2='bb')
minimal-1.html: minimal.Rmd
## 	cp minimal.Rmd minimal-1.Rmd

minimal-2.html: RMARKDOWN_HTML_EXTRAS=, params=list(VALUE_1='AA2')
minimal-2.html: minimal.Rmd
##	cp minimal.Rmd minimal-2.Rmd

minimal-3.html: RMARKDOWN_HTML_EXTRAS=, params=list(VALUE_2='BB2')
minimal-3.html: minimal.Rmd
##	cp minimal.Rmd minimal-3.Rmd

## Naturally, this won't work - unless the pattern rule is overitten
## completely with a new one
## minimal4.html: RMARKDOWN_HTML_EXTRAS=, params=list(VALUE_2='BB2'), output_file='minimal4.html'
## minimal4.html: minimal.Rmd
