GNU Make rules for Data Analysis and Reporting
=============

Also see [the blog site](http://www.petebaker.id.au "Peter Baker's outback R blog") for this and related material.

Comprehensive documentation will soon be available as *Peter Baker (2020) Using GNU Make to Manage the Workflow of Data Analysis Projects, Journal of Statistical Software.*

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

The file *r-rules.mk* can be included in a standard *Makefile* to
facilitate a more efficient workflow.

**NB:** For **macOS**, make (like many other programs), is pretty
ancient in computing terms. You may prefer to install a recent version
of *GNU Make*. IMHO, the best way is to install via *homebrew* - see
http://brew.sh/. Use *gmake* which will run the new version instead of
*make* which runs the old one.

Using r-rules.mk
============

1. Download the file to a directory you use for such files. Ideally,
   this would something like:
   - <kbd>~/lib</kbd> or <kbd>C:\MyLibrary</kbd> or <kbd>/usr/local/include</kbd>
2. put the following line in your *Makefile*
   - <kbd>include ~/lib/r-rules.mk</kbd> where ~ will be expanded to be your HOME directory, or
   - <kbd>include C:/MyLibrary/r-rules.mk</kbd> (in windows), or
   - <kbd>include r-rules.mk</kbd> if location in system directory for *Makefile* includes (eg <kbd>/usr/local/include</kbd>)

**Note:** the very simplest way to run make would be to simply create
a new text file named *Makefile* in your working directory or a system directory like <kbd>/usr/local/include</kbd> with a
single line above including the file *r-rules.mk*. If you have an R
syntax file named say mySpecialAnalysis.R then, in a terminal, you can
run *R* to produce an output file by typing 'make
mySpecialAnalysis.Rout' or produce a notebook using *Rmarkdown* by
typing 'make mySpecialAnalysis.pdf'.

However, you will miss out on the power of make which you can harness by describing the dependencies among files.

To actually use these rules in practice, we may have several prerequisite files like an R syntax file and several data files. In the *Makefile* we may specify the dependencies as

```make
readData.Rout: readData.R data1.csv data2.csv oldData.RData
```

so we can run the syntax file by typing ‘make readData.Rout’ at the command prompt. If any of the files readData.R, data1.csv, data2.csv or oldData.RData have changed recently, and so are newer than the target file readData.Rout, then the predefined R batch command is run to get a new output file, otherwise readData.Rout is ‘up to date’. Of course, it is better if we set up our *Makefile* so that 'readData.Rout' gets built automatically and so we can just type 'make'. 

To take advantage of *make*, the best approach is to define all necessary targets and dependencies in project *Makefile*(s).

Example Makefiles
==============

```make
.PHONY : all
all: test.pdf test.html test.docx test2.pdf test-stitch.Rout test-stitch.pdf \
     myTalk_ioslides.html myTalk_beamer.pdf myTalk_Present.pdf

## produce pdf, html, docx from test.Rmd
test.pdf: ${@:.pdf=.Rmd}
test.html: ${@:.html=.Rmd}
test.docx: ${@:.docx=.Rmd}

## produce pdf from test2.rmd
test2.pdf: ${@:.pdf=.rmd}

## use stitch to produce pdf via rmarkdown (exactly as in RStudio)
test-stitch.pdf: ${@:.pdf=.R}

## produce a beamer & ioslides presentation from .Rmd file
myTalk_ioslides.html: myTalk.Rmd
myTalk_beamer.pdf: myTalk.Rmd

## produce a beamer presentation from .Rnw file
myTalk_Present.pdf: myTalk.Rnw

## if you have r-rules.mk in ~/lib directory uncomment line below and comment
include r-rules.mk
##include ~/lib/r-rules.mk
```

You can then run this with the command **make** or **make all** at the
shell prompt. Any target that is not up to date will be created by
running the appropriate commands. Even better: set up *RStudio* or
your favourite editor to do this at the press of a button. Note also
that because of the rules defined in *r-rules.mk*, you can use make to
produce targets not actually defined in the *Makefile*. For instance,
to use stitch to create pdf output *newAnalysis.pdf* from the file
*newAnalysis.R* simply type **make newAnalysis.pdf** at the prompt.

More usually, if there is a sequence of steps relying on a data file
*myData.csv* your *Makefile* may look something like

```make
.PHONY:	all
all: report.pdf

## produce report from .Rmd once previous steps carried out
report.pdf: ${@:.pdf=.Rmd} summaryAndPlots.Rout

## summarise data
summaryAndPlots.Rout: ${@:.Rout=.R} readData.Rout

## read data
readData.Rout: ${@:.Rout=.R} myData.csv

include ~/lib/r-rules.mk
```

Prerequisites
==========

To use these makefile definitions you need to install
- GNU Make  http://www.gnu.org/software/make/
- R         http://www.r-project.org/
- R packages on CRAN: rmarkdown, knitr
- pandoc   http://johnmacfarlane.net/pandoc/
- latexmk   http://http://www.ctan.org/pkg/latexmk/ (only for R Sweave)

Note that *Windows* users can install *Rtools* (available via CRAN) to get a working version of make and may also need to install pandoc and latex to produce pdf files if they haven't already. Miktex is recommended although texlive will also work well.
- Rtools   http://cran.r-project.org/bin/windows/Rtools/
- miktex   http://miktex.org/

*macOS* users can install *gnu make* from homebrew or macports. Homebrew versions of *latexmk* and *pandoc* are also available but *MacTex* is available as a binary package at http://www.tug.org/mactex/. Some rules may need a newer version of *make* than comes with *XCode* so using *gmake* is highly recommended.

Notes
=======

Definitions in 'r-rules.mk' have been developed and tested on linux. These rules have also been reasonably well tested on windows (Rtools) and macOS (homebrew 'gmake' - not macOS Xcode gnu 'make' which is 10 years old). Some tweaking may be required and is indeed encouraged.

Extra rules for SAS, STATA, PSPP, python and perl are very preliminary and not extensively tested.

Once you have a *Makefile* which includes the file 'r-rules.mk' you can type 'make help' at the command prompt for further information. You can also tweak the variables like $R, $R_OPTS defined in 'r-rules.mk' to change the defaults without needing to rewrite 'r-rules.mk'.

Finally, there are two bash scripts to help use these R pattern rules. Firstly,  'checkInstalled' checks that the pattern rules, *Makefile* templates etc in ~/lib or ~/bin are the same and highlights differences using the unix command 'diff'.The 'cpMakeTemplate' bash script can be put in your path to copy a *Makefile* template to the current directory. Several templates are available. Please see 'cpMakeTemplate -h' and 'checkInstalled -h' for details. The file 'install.txt' gives advice and some commands for installing these files to make them readily available.
