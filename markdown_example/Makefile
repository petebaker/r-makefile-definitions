## test RMarkdown examples
.PHONY: all
all: test.pdf test.html test.docx test.rtf test.odt test2_ioslides.html test2_slidy.html test2_beamer.pdf test2_tufte.pdf

## Changelog: Original version Sunday 2016-06-19 at 18:16:22

## main file is 'b1.Rnw'

## include ~/lib/common.mk
include ../common.mk

## Note that all dependencies OK by default for test.Rmd

.PHONY: clean-all
clean-all:
	rm -fr *.pdf *.html *.odt *.rtf *.docx *~
