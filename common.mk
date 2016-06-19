## File:    common.mk - to be included in Makefile(s)
## Purpose: Define gnu make rules for R, knitr, Rmarkdown and Sweave
## Version: 0.2.9000
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
##            2015-09-07 at 17:55:27
##            1) fixed 'make help-r' which referred to myFile.R rather than .Rouit
##            2) added link to blog site
##            2016-05-19 at 11:58:34
##            1) modified beamer from .Rnw to be more generic
##            2) added beamer example and preamble .Rnw files

## TODO: 1) proper documentation            2015-02-21 at 23:41:44
##       2) make knit more system independent
##          PARTIALLY DONE 2015-03-29 at 09:37:41
##          DONE 2016-06-19 at 18:45:02
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
	@echo $$ make myFile.Rout
	@echo will produce 'myFile.Rout' using R CMD BATCH --vanilla myFile.R
	@echo but you can change options with something like
	@echo $$ R_OPTS=--no-restore-history make myFile.Rout
	@echo ""
	@echo To stitch file \(like RStudio\) just choose any or all of:
	@echo make myFile.pdf
	@echo make myFile.docx
	@echo make myFile.html
	@echo NB: This assumes you don\'t have files like myFile.\{Rmd,Rnw,tex\} etc present,
	@echo "    only 'myFile.R'"
	@echo "    So good practice is to use different (base)names for reports and analysis"

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
## Not sure if this conflicts  ----- START
%.pdf : %.tex
	${RSCRIPT} ${R_OPTS} ${LATEXMK} ${LATEXMK_FLAGS} $<
## Not sure if this conflicts  ----- END
%.pdf: %.Rnw
	${RSCRIPT} ${R_OPTS} -e "library(knitr);knit2pdf('${@:.pdf=.Rnw}')"

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

## I find that rmarkdown seems to be a better option than knitr  
## both on CRAN now so easy to install

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


## Course slides/presentations using knit/beamer ------------------------

.PHONY: help-beamer
help-beamer:
	@echo ""  
	@echo Beamer presentations, articles and handouts produced with knitr
	@echo ""
	@echo "    The main file has name PRESENTATION.Rnw"
	@echo "    for instance, for myTalk.Rnw, then replace PRESENTATION with myTalk"
	@echo "NB: Do not include \\documentclass[...]{beamer} in main file"
	@echo ""
	@echo Targets that may be produced:
	@echo "   PRESENTATION-Present.pdf: Slides for presentation"
	@echo "   PRESENTATION-Notes.pdf: Slides for presentation with speaker notes"
	@echo "   PRESENTATION-Article.pdf: Article using 'beamerarticle' style"
	@echo "   PRESENTATION-Handout.pdf: 1 slide/page without transitions"
	@echo "   PRESENTATION-2up.pdf: Handouts - 2 per A4 page"
	@echo "   PRESENTATION-3up.pdf:            3 per A4 page"
	@echo "   PRESENTATION-4up.pdf:            4 per A4 page"
	@echo "   PRESENTATION-6up.pdf:            6 per A4 page"
	@echo "   PRESENTATION-syntax.R: R syntax file tangled from Rnw using knit"
	@echo ""
	@echo "NB: Do not put \\documentclass declaration in main .Rnw file"
	@echo "\\documentclass{} declaration obtained from files"
	@echo "      preamble{Present,Article,Notes,Handout}.Rnw"
	@echo "    Preamble files can be set with variables BEAMER_PRESENT etc"
	@echo " eg. $$ BEAMER_PRESENT=~/lib/preamble.Rnw make myTalk_Present.pdf"

## produce latex file with knit and pdf (via pdflatex) with knit2pdf
## but note that it does not have document class - knitr is then
## likely to use article if preamble is not used

## use knitr, latex and pdfjam to produce output  ------------------------

## variables which can be overridden
BEARMER_LIB = ~/lib/beamerPreamble/
##BEAMER_LIB = ""
BEAMER_PRESENT = ${BEAMER_LIB}preamblePresent.Rnw
BEAMER_HANDOUT = ${BEAMER_LIB}preambleHandout.Rnw
BEAMER_ARTICLE = ${BEAMER_LIB}preambleArticle.Rnw
BEAMER_NOTES = ${BEAMER_LIB}preambleNotes.Rnw
PDFJAM_4UP = --nup 2x2 --frame true --landscape --scale 0.92
PDFJAM_2UP = --nup 1x2 --frame true --no-landscape --scale 0.92
PDFJAM_3UP = --no-landscape
PDFJAM_6UP = --no-landscape

## Beamer presentation pdf
%_Present.Rnw: %.Rnw $(BEAMER_PRESENT)
	cat $(BEAMER_PRESENT) $< > $@
%_Present.pdf: %_Present.Rnw
	Rscript --vanilla -e "library(knitr);knit2pdf('$<')"

## Beamer presentation with notes pdf (notes show on second screen)
%_Notes.Rnw: %.Rnw $(BEAMER_NOTES)
	cat $(BEAMER_NOTES) $< > $@
%_Notes.pdf: %_Notes.Rnw
	Rscript --vanilla -e "library(knitr);knit2pdf('$<')"

## produce Article pdf (slides usually not framed but can be)
%_Article.Rnw: %.Rnw $(BEAMER_ARTICLE)
	cat $(BEAMER_ARTICLE) $< > $@
%_Article.pdf: %_Article.Rnw
	Rscript --vanilla -e "library(knitr);knit2pdf('$<')"

## Handout - single slide on a landscape page pdf
%_Handout.Rnw: %.Rnw $(BEAMER_HANDOUT)
	cat $(BEAMER_HANDOUT) $< > $@
%_Handout.pdf: %_Handout.Rnw
	Rscript --vanilla -e "library(knitr);knit2pdf('$<')"

## Handouts: various - multiple slides per page using pdfjam - calls
##           latex pgfpages in background
%-4up.pdf: %_Handout.pdf
	pdfjam -o $@ ${PDFJAM_4UP} $<

%-2up.pdf: %_Handout.pdf
	pdfjam -o $@ ${PDFJAM_2UP} $<

%-6up.pdf: %_Handout.pdf
	pdfjam-slides6up -o $@ $(PDFJAM_6UP) $< 

%-3up.pdf: %_Handout.pdf
	pdfjam-slides3up -o $@ $(PDFJAM_3UP) $<

## extract R syntax using knitr::purl
%-syntax.R: %.Rnw
	Rscript --vanilla -e 'library(knitr);purl("$<", out="$@")'

## housekeeping which needs improving - especially backup (.tgz or
## .zip file?)  but this won't work without extra directories etc
## needs some checking and thought

.PHONY: clean
clean: 
	-rm -f *.pdf *.Rout *.log *.aux *.bbl *~

.PHONY: backup
backup:
	-zip -9 backup/backup-`date +%F`.zip *.R Makefile */*/*.csv *.pdf *.Rnw *.Rmd *.Rout

