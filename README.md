R related Makefile definitions
=============

**GNU Make** is a commonly used tool as part of the process for
  managing software projects.

Data analysis can involve many steps including reading data; cleaning
and transforming data; plotting data, statistical analysis and finally
writing reports. While we can try and keep track of each step manually
by using good documentation and being highly organised, it can prove
to be more efficient to employ computer tools to augment these
practices. One such approach is to use a tool like GNU Make. Such an
approach does not obviate the need to be organised and document the
work but it can certainly prove helpful, especially as a project grows
in size.

While it is far from perfect, **make** is widely used and generally
proves to be useful for efficiently carrying out tasks in data
analysis.  Unfortunately, **make** does not provide standard rules for
producing *.Rout* files from *.R* files, *.pdf* files from *.Rnw*
files, *.docx* files from *.Rmd* files and so on.

The file *common.mk* can be included in a standard *Makefile* to
facilitate a more efficient workflow.

Using common.mk
============

1. Download the file to a directory you use for  files. Ideally,
   this would something like:
   - ~/lib or C:\MyLibrary
2. put the following line in your Makefile
   - include ~/lib, or
   - include C:\MyLibrary  ?? check this

Example Makefiles
==============

```make
.PHONY : all
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
```

More usually, if there is a seqence of steps relying on a data file
myData.csv your Makefile may look something like

```make
.PHONY:	all
all: report.pdf

## produce report from .Rmd once previous steps carried out
report.pdf: ${@:.pdf=.Rmd} summaryAndPlots.Rout

## summarise data
summaryAndPlots.Rout: ${@:.Rout=.R} read.Rout

## read data
read.Rout: ${@:.Rout=.R} myData.csv

include ~/lib/common.mk
```

Prerequisites
==========

To use these makefile definitions you need to install
- GNU Make  http://www.gnu.org/software/make/
- R         http://www.r-project.org/
- latexmk   http://http://www.ctan.org/pkg/latexmk/
- R packages on CRAN: rmarkdown, knitr

Note that Windows users can install Rtools (available from CRAN) to get a working version of make

Notes
=======

TODO: Need to check if date available under Rtools/msys for windows and if
not either drop it or do a conditional on OS style definition
