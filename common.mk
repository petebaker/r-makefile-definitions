## File:    common.mk - to be included in Makefile(s)
## Purpose: Define gnu make rules for R, knitr, Rmarkdown and Sweave
## Version: 0.2.01
## Usage: Place file in a directory such as ~/lib and include with
##         include ~/lib/common.mk
##         at the bottom of Makefile (or adjust for your directory of choice)
##         To override any definitions place them after the include statement
## NB: if using makepp then ~ is not recognized but the following is OK
##         include ${HOME}/lib/common.mk
##
##   The latest version of this file is available at
##   https://github.com/petebaker/r-makefile-definitions

## For help after including common.mk in Makefile: run
##         $  make help

## Changelog: None recorded until Frid 2015-02-06 at 15:40:21
##            On Frid 2015-02-06
##            1) Added Rmarkdown rules
##               run $ make help-rmarkdown
##            2) Added stitch rules
##            Sat 2015-03-28 at 20:48:20
##            1) added version
##            2) added git and rsync targets
##            3) fixed some knitr/rmarkdown targets
##            2015-06-16 at 08:50:37
##            1) Added rmarkdown pdf options to drop pdfcrop etc

## TODO: 1) proper documentation            2015-02-21 at 23:41:44
##       2) make knit more system independent
##          PARTIALLY DONE 2015-03-29 at 09:37:41
##       3) generic clean/backup needs work (see end of file)

## For Sweave I've changed the default to knit as that's what I
## usually want but to use Sweave then uncomment appropriate lines below
## KNIT not used but now used as it is now called inside Rscript
## but could be changed if this way preferred
## note - may need to use this (or similar) instead if knit is not in path
## KNIT     = knit
## KNIT     = /usr/lib/R/site-library/knitr/bin/knit
## KNIT     = /usr/lib/R/library/knitr/bin/knit
## KNIT     = /usr/lib64/R/library/knitr/bin/knit
## KNIT_FLAGS = -n -o
## %.md: %.Rmd
##	${KNIT} $@ ${KNIT_OPTS} $<
##%.tex: %.Rnw
##	${R} CMD Sweave $<
##%.R: %.Rnw
##	${R} CMD Stangle $<

## program defs:
##MAKE      = make

## general help -----------------------------------------------------

.PHONY: help
help:
	@echo ""
	@echo Simple help can be obtained with
	@echo ""
	@echo make help-r
	@echo make help-rmarkdown
	@echo make help-stitch
	@echo make help-beamer
	@echo make help-git
	@echo make help-rsync

# latex variables ---------------------------------------------------

## can be used to convert simple latex to .rtf file for MS word
LATEX2RTF     = latex2rtf

## cross platform way to run latex properly but best to run through R
LATEXMK       = $(R) CMD latexmk
LATEXMK_FLAGS = -pdf
## rubber - latexmk alternative on linux systems only
RUBBER    = $(R) CMD rubber
RUB_FLAGS = -d

## git variables ---------------------------------------------------

GIT_REMOTE = master
## GIT_REMOTE = ssh://pete@192.168.0.1:port/git.repository
GIT_ORIGIN = origin
GIT = git
GIT_FLAGS = -a

## rsync variables ------------------------------------------------

RSYNC_DESTINATION =
## RSYNC_DESTINATION = ~/ownCloud/myProject
RSYNC = rsync
RSYNC_FLAGS = -auvtr
RSYNC_FILES_LOCAL = *
RSYNC_FILES_REMOTE = *
RSYNC_DRY_RUN = --dry-run

## pandoc variables ---------------------------------------------

PANDOC = pandoc
PANDOC_OPTS = -s

## R variables ---------------------------------------------

R         = R
RSCRIPT   = Rscript
R_FLAGS   = CMD BATCH
##R_OPTS    = --no-save --no-restore --no-restore-history --no-readline
R_OPTS    = --vanilla
RWEAVE    = $(R) CMD Sweave
RWEAVE_FLAGS =

## R pattern rules -------------------------------------------------
.PHONY: help-r
help-r:
	@echo ""
	@echo Just one major rule to produce .Rout but can stitch .R file too
	@echo ""
	@echo $$ make myFile.R
	@echo will produce 'myFile.Rout' using R CMD BATCH --vanilla myFile.R
	@echo but you can change options with something like
	@echo $$ R_OPTS=--no-restore-history make myFile.R
	@echo ""
	@echo To stitch file \(like RStudio\) just choose any or all of:
	@echo make myFile.pdf
	@echo make myFile.docx
	@echo make myFile.html
	@echo NB: This assumes you don\'t have files like myFile.\{Rmd,Rnw,tex\} etc present,
	@echo "    only 'myFile.R'"
	@echo "    So good practice is to use different names for reports and analysis"

## produce .Rout from .R file --------------------------------------

## Running R to produce text file output
## If you want to see start and end time on a linux system uncomment
##  the echo lines 
%.Rout: %.R
##	@echo Job $<: started at `date`
	${R} ${R_FLAGS} ${R_OPTS} $< 
##	@echo Job $<: finished at `date`

## knit (and Sweave) pattern rules ----------------------------------

%.R: %.Rnw
	${RSCRIPT} ${R_OPTS} -e "library(knitr);purl(\"${@:.R=.Rnw}\")"
%.R: %.Rmd
	${RSCRIPT} ${R_OPTS} -e "library(knitr);purl(\"${@:.R=.Rmd}\")"
%.tex: %.Rnw
	${RSCRIPT} ${R_OPTS} -e "library(knitr);knit('${@:.tex=.Rnw}')"
%.pdf : %.tex
	${LATEXMK} ${LATEXMK_FLAGS} $<
##	${RUBBER} ${RUB_FLAGS} $<
## %.pdf: %.Rnw
## 	${RWEAVE} ${RW_FLAGS} $<
## 	${RUBBER} ${RUB_FLAGS} $<

%.rtf: %.tex
	${LATEX2RTF} ${L2R_FLAGS} ${@:.rtf=}

## wonder if this would cause a conflict with rmarkdown - shouldn't as
## long as R markdown rules come after this and possible override with
## explicit definitions?

%.md: %.Rmd
	${RSCRIPT} ${R_OPTS} -e "library(knitr);knit(\"${@:.md=.Rmd}\")"
%.md: %.rmd
	${RSCRIPT} ${R_OPTS} -e "library(knitr);knit(\"${@:.md=.rmd}\")"

## pandoc pattern rules  ----------------------------------------------

%.pdf: %.md
	${PANDOC} ${PANDOC_OPTS} $< -o $@
%.docx: %.md
	${PANDOC} ${PANDOC_OPTS} $< -o $@
%.html: %.md
	${PANDOC} ${PANDOC_OPTS} $< -o $@
%.tex: %.md
	${PANDOC} ${PANDOC_OPTS} $< -o $@

## stitch an R file using knitr --------------------------------------

## find that rmarkdown seems to be a better option than knitr  
## both on CRAN now so easier to install

RMARKDOWN_PDF_OPTS =  (fig_crop=FALSE, fig_caption = TRUE)

.PHONY: help-stitch
help-stitch:
	@echo ""
	@echo To stitch file \(like RStudio\) just do one of the following:
	@echo make myFile.pdf
	@echo make myFile.docx
	@echo make myFile.html
	@echo NB: This assumes you don\'t have files like myFile.\{Rmd,Rnw,tex\} etc present,
	@echo "    only 'myFile.R' So good practice is to use different"
	@echo "    file (base)names for reports and analysis"

%.pdf: %.R
	${RSCRIPT} ${R_OPTS} -e "library(rmarkdown);render(\"${@:.pdf=.R}\", pdf_document${RMARKDOWN_PDF_OPTS})"
%.html: %.R
	${RSCRIPT} ${R_OPTS} -e "library(rmarkdown);render(\"${@:.html=.R}\", \"html_document\")"
## this borrows line from below
%.docx: %.R
	${RSCRIPT} ${R_OPTS} -e "library(rmarkdown);render(\"${@:.docx=.R}\", \"word_document\")"

## Rmarkdown pattern rules  --------------------------------------------------

## generating pdf, docx, html other from Rmarkdown/sweave
## Note: $< does not appear to work whereas ${@:.pdf=.Rmd} does even
##       though I think they should be identical
.PHONY: help-rmarkdown
help-rmarkdown:
	@echo ""
	@echo You can easily set up a .PHONY target to produce all output
	@echo format files specified at the top of the .Rmd file
	@echo See the file ~/lib/common.mk file and simply
	@echo 1\) set up a phony target with something like
	@echo .PHONY: rmarkdown-all
	@echo rmarkdown-all: myfile.Rmd
	@echo 2\) insert an Rscript command eg.
	@echo '   a\) insert pdf command from ~/lib/common.mk'
	@echo '   b\) replace \"pdf_document\" with \"all\"'

%.pdf: %.Rmd
	${RSCRIPT} ${R_OPTS} -e "library(rmarkdown);render(\"${@:.pdf=.Rmd}\", pdf_document${RMARKDOWN_PDF_OPTS})"
%.pdf: %.rmd
	${RSCRIPT} ${R_OPTS} -e "library(rmarkdown);render(\"${@:.pdf=.rmd}\", pdf_document${RMARKDOWN_PDF_OPTS})"
%.html: %.Rmd
	${RSCRIPT} ${R_OPTS} -e "library(rmarkdown);render(\"${@:.html=.Rmd}\", \"html_document\")"
%.html: %.rmd
	${RSCRIPT} ${R_OPTS} -e "library(rmarkdown);render(\"${@:.html=.rmd}\", \"html_document\")"
%.docx: %.Rmd
	${RSCRIPT} ${R_OPTS} -e "library(rmarkdown);render(\"${@:.docx=.Rmd}\", \"word_document\")"
%.docx: %.rmd
	${RSCRIPT} ${R_OPTS} -e "library(rmarkdown);render(\"${@:.docx=.rmd}\", \"word_document\")"

## uncomment next line if required for debugging latex 
## .PRECIOUS: .tex 

## backup using rsync -------------------------------------------------
.PHONY: help-rsync
help-rsync:
	@echo ""
	@echo Use rsync to backup files to/from local or remote destination
	@echo ""
	@echo "rsync local to remote:"
	@echo $$ make rsynctest
	@echo "  or"
	@echo $$ make rsynccopy
	@echo ""
	@echo "rsync remote to local:"
	@echo $$ make rsynctest2here
	@echo "  or"
	@echo $$ make rsynccopy2here
	@echo ""
	@echo will either run rsync with \'--dry-run\' option to perform a
	@echo trial run with no changes made
	@echo " or"
	@echo copy just those updated files to local/remote destination
	@echo but your can change options with something like
	@echo $$ RSYNC_DESTINATION=~/ownCloud/myProject3 make rsynctest
	@echo $$ RSYNC_DESTINATION=username@remote_host:/home/username/dir1 make rsynctest
	@echo NB: rsync variables \(defaults in brackets\) are
	@echo "    RSYNC_DESTINATION, RSYNC (rsync), RSYNC_FLAGS (-auvtr)"
	@echo "    RSYNC_FILES_LOCAL (*), RSYNC_FILES_REMOTE (*) RSYNC_DRY_RUN (--dry-run)"
	@echo See https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories-on-a-vps


## rsync local to remote
.PHONY: rsynctest
rsynctest:
	${RSYNC} ${RSYNC_DRY_RUN} ${RSYNC_FLAGS} ${RSYNC_FILES_LOCAL} ${RSYNC_DESTINATION}/.

.PHONY: rsynccopy
rsynccopy:
	${RSYNC} ${RSYNC_FLAGS} ${RSYNC_FILES_LOCAL} ${RSYNC_DESTINATION}/.

.PHONY: rsynctest2here
rsynctest2here:
	${RSYNC} ${RSYNC_DRY_RUN} ${RSYNC_FLAGS} ${RSYNC_DESTINATION}/${RSYNC_FILES_REMOTE} .

.PHONY: rsynccopy2here
rsynccopy2here:
	${RSYNC} ${RSYNC_FLAGS} ${RSYNC_DESTINATION}/${RSYNC_FILES_REMOTE} .

## git  -------------------------------------------------

.PHONY: help-git
help-git:
	@echo ""
	@echo Version control using git
	@echo ""
	@echo $$ make git.status
	@echo $$ make git.commit
	@echo "  or"
	@echo $$ make git.fetch
	@echo will either list changes via \'git status\', commit changes or push to remote repository
	@echo " "
	@echo Useful commands:
	@echo $$git remote -v : lists URLs that Git has stored for remotes
	@echo $$git remote add [shortname] [url] : to add remote
	@echo $$ git push [remote-name] [branch-name] : to push repository to remote
	@echo See http://git-scm.com/doc or
	@echo http://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes

.PHONY: git.status
git.status:
	${GIT} status

.PHONY: git.commit
git.commit:
	${GIT} commit ${GIT_FLAGS}

.PHONY: git.push
git.push:
	${GIT} push ${GIT_ORIGIN} ${GIT_REMOTE}


## Course slides using knit/beamer ----------------------------------------

## Course slides, notes, etc etc using knitr
## Based on Douglas Bates lme course notes course code
## but added the slides/article styles as per happymutant website
## basically needs a line at to of file with beamer options
## ~~MY~BEAMER~~OPTIONS~~  which gets changed for each different output type

.PHONY: help-beamer
help-beamer:
	@echo ""  
	@echo Beamer presentations and handouts produced with knitr
	@echo Note that base file has name PRESENTATION-src.Rnw
	@echo " where PRESENTATION is appropriate name for your presentation"
	@echo ""
	@echo Targets that may be produced:
	@echo "   PRESENTATION-Present.pdf: Slides for presentation"
	@echo "   PRESENTATION-Slides.pdf: 1 slide per page without transitions"
	@echo "   PRESENTATION-2a4.pdf: Handouts - 2 slides per A4 page"
	@echo "   PRESENTATION-4a4.pdf: Handouts - 4 slides per A4 page"
	@echo "   PRESENTATION-syntax.R: R syntax file tangled from Rnw using knit"
	@echo "   PRESENTATION-Notes.pdf: Notes in beamer article style"
	@echo ""
	@echo "NB: First line of PRESENTATION-src.Rnw is"
	@echo "\\documentclass[~~MY~BEAMER~~OPTIONS~~]{beamer}"

## produce latex file with knitr but note that it does not have
## document class - perhaps it should and use perl etc to modify it
%-src.tex: %-src.Rnw

## Presentation pdf - produced via R CMD latexmk ...
## %-Slides.pdf requires %-src.Rnw WITHOUT  \documentclass top line
# %-Present.tex: %-src.tex
# 	@echo "\\documentclass[dvipsnames,pdflatex,ignorenonframetext]{beamer}" > $@
# 	@echo "\\input{"$*-src"}" >> $@
# 	@echo "\\end{document}" >> $@

## Presentation pdf - produced via R CMD latexmk ...
## %-Slides.pdf requires %-src.Rnw WITHOUT  \documentclass top line
%-Present.Rnw: %-src.Rnw
	sed -e s/~~MY~BEAMER~~OPTIONS~~/dvipsnames,pdflatex,ignorenonframetext/g $< > $@

## Presentation syntax
%-syntax.R: %-src.Rnw
	R -e 'library(knitr);knit("$<", tangle=TRUE)'
	mv ${<:.Rnw=.R} $@

## Slides - one per page - produced via R CMD latexmk ...
## dropped handout option!
%-Slides.tex: %-Present.tex
	sed -e s/dvipsnames,pdflatex,ignorenonframetext/ignorenonframetext,dvipsnames,pdflatex,handout/g $< > $@

##%-Slides.tex: %-src.tex
##	@echo "\\documentclass[ignorenonframetext,dvipsnames,pdflatex,handout]{beamer}" > $@
##	@echo "\\input{"$*-src"}" >> $@
##	@echo "\\end{document}" >> $@

# A4 paper - 2 per slides page
%-2a4.tex: %-Slides.pdf
	@echo "\\documentclass[a4paper]{article}" > $@
	@echo "\\usepackage{pdfpages}" >> $@
#	@echo "\\usepackage{pgfpages}" >> $@
#	@echo "\\pgfpagesuselayout{2 on 1}[a4paper,border shrink=5mm]" >> $@
	@echo "\\begin{document}" >> $@
	@echo "\\includepdf[nup=1x2,pages=-]{"$*"-Slides.pdf}" >> $@
#	@echo "\\includepdf{"$*"H.pdf}" >> $@
	@echo "\\end{document}" >> $@

# A4 paper - 4 slides per page
%-4a4.tex: %-Slides.pdf
	@echo "\\documentclass[a4paper,landscape]{article}" > $@
	@echo "\\usepackage{pdfpages}" >> $@
	@echo "\\begin{document}" >> $@
	@echo "\\includepdf[nup=2x2,pages=-]{"$*"-Slides.pdf}" >> $@
	@echo "\\end{document}" >> $@

## Beamer style article - if you experience slight clash with todonotes
##                        or wish to add/remove styles modify here
%-Notes.tex: %-src.tex
	@echo "% to use packages uncomment appropriate line by removing %" > $@
	@echo "%\\PassOptionsToPackage{override,tikz}{xcolor}" > $@
	@echo "%\\PassOptionsToPackage{override,xcolor}{tikz}" > $@
	@echo "%\\PassOptionsToPackage{override,xcolor}{todonotes}" > $@
	@echo "%\\PassOptionsToPackage{override,xcolor}{beamer}" > $@
	@echo "\\documentclass[a4paper]{article}" > $@
	@echo "\\usepackage{beamerarticle}" >> $@
	@echo "\\input{"$*-src"}" >> $@
	@echo "\\end{document}" >> $@

## Housekeeping rules ---------------------------------------------------


## housekeeping which needs improving - especially backup (.tgz or
## .zip file?)  but this won't work without extra directories etc
## needs some checking and thought

.PHONY: clean
clean: 
	-rm -f *.pdf *.Rout *.log *.aux *.bbl *~

.PHONY: backup
backup:
	-zip -9 backup/backup-`date +%F`.zip *.R Makefile */*/*.csv *.pdf *.Rnw *.Rmd *.Rout

