## File:    common.mk - to be included in Makefile(s)
## Purpose: Define gnu make rules for R, knitr, Rmarkdown and Sweave
## Version: 0.2.9004
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
##          On Frid 2015-02-06
##            1) Added Rmarkdown rules
##               run $ make help-rmarkdown
##            2) Added stitch rules
##          Sat 2015-03-28 at 20:48:20
##            1) added version
##            2) added git and rsync targets
##            3) fixed some knitr/rmarkdown targets
##          2015-06-16 at 08:50:37
##            1) Added rmarkdown pdf options to drop pdfcrop etc
##          2015-09-07 at 17:55:27
##            1) fixed 'make help-r' which referred to myFile.R rather
##               than .Rout
##            2) added link to blog site
##          2016-05-19 at 11:58:34
##            1) modified beamer from .Rnw to be more generic
##            2) added beamer example and preamble .Rnw files
##          2016-06-19 at 23:27:34
##            1) added in various 'rmarkdown' outputs like ioslides,
##               slidy, beamer, tufte, rtf, odt
##          2016-06-23 at 16:23:57 (Version 0.2.9004)
##            1) fixed Rscript --vanilla R CMD --vanilla bug for latexmk
##            2) added variables for programs like cat, rm, pdfjam,
##               latexmk to include PROG_OPTS to set options
##               and LATEXMK_PRE which can be prepended to latex
##            3) changed outputting R syntax from .Rmd and .Rnw files
##               to produce -syntax.R to avoid dependency loops where
##               a .tex file then .pdf might be produced instead
##               of using rmarkdown 

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
	@echo make help-stitch
	@echo make help-rmarkdown
	@echo make help-beamer
	@echo make help-git
	@echo make help-rsync

# latex variables ---------------------------------------------------

## can be used to convert simple latex to .rtf file for MS word
LATEX2RTF     = latex2rtf

## cross platform way to run latex but may also run through R
## LATEXMK_PRE   = ${R} CMD ${R_OPTS}
LATEXMK_PRE   =
LATEXMK       = latexmk
LATEXMK_FLAGS = -pdf
## rubber - latexmk alternative on linux systems only
RUBBER    = $(R) CMD rubber
RUB_FLAGS = -d

## specific program variables - may need to redefine on other systems
RM       = rm
RM_OPTS  =
CAT      = cat
CAT_OPTS =
PDFJAM   = pdfjam
PDFJAM_OPTS=

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
R_FLAGS   = CMD BATCH
R_OPTS    = --vanilla
RSCRIPT   = Rscript
RSCRIPT_OPTS = --vanilla
##R_OPTS    = --no-save --no-restore --no-restore-history --no-readline
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

## stitch an R file using knitr --------------------------------------

## I find that rmarkdown seems to be a better option than knitr  
## both on CRAN now so easy to install

RMARKDOWN_PDF_OPTS = (fig_crop=FALSE, fig_caption = TRUE)

.PHONY: help-stitch
help-stitch:
	@echo ""
	@echo To stitch file \(like RStudio\) from a .R file, just do one of the following:
	@echo make myFile.pdf
	@echo make myFile.docx
	@echo make myFile.html
	@echo NB: This assumes you don\'t have files like myFile.\{Rmd,Rnw,tex\} etc present,
	@echo "    only 'myFile.R' So good practice is to use different"
	@echo "    file (base)names for reports and analysis"

%.pdf: %.R
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:.pdf=.R}\", pdf_document${RMARKDOWN_PDF_OPTS})"
%.pdf: %.r
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:.pdf=.r}\", pdf_document${RMARKDOWN_PDF_OPTS})"
%.html: %.R
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:.html=.R}\", \"html_document\")"
%.html: %.r
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:.html=.r}\", \"html_document\")"
## this borrows line from below
%.docx: %.R
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:.docx=.R}\", \"word_document\")"
%.docx: %.r
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:.docx=.r}\", \"word_document\")"

## knit and rmarkdown pattern rules ----------------------------------

## produce R syntax from .Rmd files - Note that .Rnw files in beamer section
## %-syntax.R: %.Rmd
##	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(knitr);purl(\"${@:.R=.Rmd}\")"
## %-syntax.R: %.rmd
##	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(knitr);purl(\"${@:.R=.rmd}\")"

%-syntax.R: %.Rmd
	${RSCRIPT} ${RSCRIPT_OPTS}  -e 'library(knitr);purl("$<", out="$@")'
%-syntax.R: %.rmd
	${RSCRIPT} ${RSCRIPT_OPTS}  -e 'library(knitr);purl("$<", out="$@")'


## wonder if this would cause a conflict with rmarkdown - shouldn't as
## long as R markdown rules come after this and possible override with
## explicit definitions? THIS CONFLICTS BADLY
## %.md: %.Rmd
## 	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(knitr);knit(\"${@:.md=.Rmd}\")"
## %.md: %.rmd
## 	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(knitr);knit(\"${@:.md=.rmd}\")"

## ## pandoc pattern rules 
## %.pdf: %.md
## 	${PANDOC} ${PANDOC_OPTS} $< -o $@
## %.docx: %.md
## 	${PANDOC} ${PANDOC_OPTS} $< -o $@
## %.html: %.md
## 	${PANDOC} ${PANDOC_OPTS} $< -o $@
## %.tex: %.md
# # 	${PANDOC} ${PANDOC_OPTS} $< -o $@

## tex file from .Rnw - obsolete as now use rmarkdown=knit and pandoc
%.tex: %.Rnw
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(knitr);knit('${@:.tex=.Rnw}')"
%.tex: %.rnw
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(knitr);knit('${@:.tex=.rnw}')"

## Not sure if this conflicts  ----- START
##%.pdf : %.tex
##	${LATEXMK_PRE} ${LATEXMK} ${LATEXMK_OPTS} $<
##	${R} CMD ${LATEXMK} ${LATEXMK_FLAGS} $<

## best to go to .pdf directly rather tahn creating .tex file
%.pdf: %.Rnw
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(knitr);knit2pdf('${@:.pdf=.Rnw}')"
%.pdf: %.rnw
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(knitr);knit2pdf('${@:.pdf=.Rnw}')"
## Not sure if this conflicts  ----- END

## Uses latex2rtf but perhaps should use markdown/pandoc as better 
%.rtf: %.tex
	${LATEX2RTF} ${L2R_FLAGS} ${@:.rtf=}

## Rmarkdown pattern rules  --------------------------------------------------

## generating pdf, docx, html other from Rmarkdown/sweave
## Note: $< does not appear to work whereas ${@:.pdf=.Rmd} does even
##       though I think they should be identical

.PHONY: help-rmarkdown
help-rmarkdown:
	@echo ""
	@echo "Using R Markdown/knitr to automatically produce output from .Rmd"
	@echo ''
	@echo Rules to make output using $$ make myFile.XXX:
	@echo "    .pdf (via latex)"
	@echo "    .html"
	@echo "    .docx (Microsoft Word)"
	@echo "    .odt (open/libre office document)"
	@echo "    .rtf (rich text format)"
	@echo "    BASENAME_ioslides.html from BASENAME.Rmd eg $$ make myFile_ioslides.html"
	@echo "    BASENAME_slidy.html from BASENAME.Rmd"
	@echo "    BASENAME_beamer.pdf from BASENAME.Rmd (beamer presentation)"
	@echo "    BASENAME_tufte.pdf from BASENAME.Rmd (tufte beamer handouts)"
	@echo ""
	@echo NB: You can easily set up a .PHONY target in \'Makefile\' to produce all
	@echo "    output format files specified at the top of the .Rmd file"
	@echo "    Set up a phony target with something like"
	@echo "      .PHONY: rmarkdown-all"
	@echo "      rmarkdown-all: myfile.Rmd"
	@echo "    then typing the following at the command prompt"
	@echo '    $$ make rmarkdown-all'
	@echo "    produces all formats defined in YAML header for 'myfile.Rmd'"
	@echo ""
	@echo "   Finally, BASENAME-syntax.R: produces R syntax file tangled from Rnw using knit"


## .pdf from .Rmd (via latex)
%.pdf: %.Rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:.pdf=.Rmd}\", pdf_document${RMARKDOWN_PDF_OPTS})"
%.pdf: %.rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:.pdf=.rmd}\", pdf_document${RMARKDOWN_PDF_OPTS})"
## uncomment next line if required for debugging latex 
## .PRECIOUS: .tex 

## .html from .Rmd
%.html: %.Rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:.html=.Rmd}\", \"html_document\")"
%.html: %.rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:.html=.rmd}\", \"html_document\")"

## .docx from .Rmd
%.docx: %.Rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:.docx=.Rmd}\", \"word_document\")"
%.docx: %.rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:.docx=.rmd}\", \"word_document\")"

## open office/libre office document format
%.odt: %.Rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:.odt=.Rmd}\", \"odt_document\")"
%.odt: %.rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:.odt=.rmd}\", \"odt_document\")"

## rich text format from rmd
%.rtf: %.Rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:.rtf=.Rmd}\", \"rtf_document\")"
%.rtf: %.rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:.rtf=.rmd}\", \"rtf_document\")"

## ioslides presentation
%_ioslides.html: %.Rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:_ioslides.html=.Rmd}\", \"ioslides_presentation\", output_file = \"$@\")"
%_ioslides.html: %.rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:_ioslides.html=.rmd}\", \"ioslides_presentation\", output_file = \"$@\")"

## slidy presentation
%_slidy.html: %.Rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:_slidy.html=.Rmd}\", \"slidy_presentation\", output_file = \"$@\")"
%_slidy.html: %.rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:_slidy.html=.rmd}\", \"slidy_presentation\", output_file = \"$@\")"

## beamer presentation
%_beamer.pdf: %.Rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:_beamer.pdf=.Rmd}\", \"beamer_presentation\", output_file = \"$@\")"
%_beamer.pdf: %.rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:_beamer.pdf=.rmd}\", \"beamer_presentation\", output_file = \"$@\")"

## tufte handout format (NB: first install.packages("tufte", dep=T))
%_tufte.pdf: %.Rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:_tufte.pdf=.Rmd}\", \"tufte_handout\", output_file = \"$@\")"
%_tufte.pdf: %.rmd
	${RSCRIPT} ${RSCRIPT_OPTS} -e "library(rmarkdown);render(\"${@:_tufte.pdf=.rmd}\", \"tufte_handout\", output_file = \"$@\")"

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
BEAMER_LIB = ~/lib/beamerPreamble/
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
	$(CAT) $(CAT_OPTS) $(BEAMER_PRESENT) $< > $@
%_Present.Rnw: %.rnw $(BEAMER_PRESENT)
	$(CAT) $(CAT_OPTS) $(BEAMER_PRESENT) $< > $@
%_Present.pdf: %_Present.Rnw
	${RSCRIPT} ${RSCRIPT_OPTS}  -e "library(knitr);knit2pdf('$<')"

## Beamer presentation with notes pdf (notes show on second screen)
%_Notes.Rnw: %.Rnw $(BEAMER_NOTES)
	$(CAT) $(CAT_OPTS) $(BEAMER_NOTES) $< > $@
%_Notes.Rnw: %.rnw $(BEAMER_NOTES)
	$(CAT) $(CAT_OPTS) $(BEAMER_NOTES) $< > $@
%_Notes.pdf: %_Notes.Rnw
	${RSCRIPT} ${RSCRIPT_OPTS}  -e "library(knitr);knit2pdf('$<')"

## produce Article pdf (slides usually not framed but can be)
%_Article.Rnw: %.Rnw $(BEAMER_ARTICLE)
	$(CAT) $(CAT_OPTS) $(BEAMER_ARTICLE) $< > $@
%_Article.Rnw: %.rnw $(BEAMER_ARTICLE)
	$(CAT) $(CAT_OPTS) $(BEAMER_ARTICLE) $< > $@
%_Article.pdf: %_Article.Rnw
	${RSCRIPT} ${RSCRIPT_OPTS}  -e "library(knitr);knit2pdf('$<')"

## Handout - single slide on a landscape page pdf
%_Handout.Rnw: %.Rnw $(BEAMER_HANDOUT)
	$(CAT) $(CAT_OPTS) $(BEAMER_HANDOUT) $< > $@
%_Handout.rnw: %.rnw $(BEAMER_HANDOUT)
	$(CAT) $(CAT_OPTS) $(BEAMER_HANDOUT) $< > $@
%_Handout.pdf: %_Handout.Rnw
	${RSCRIPT} ${RSCRIPT_OPTS}  -e "library(knitr);knit2pdf('$<')"

## Handouts: various - multiple slides per page using pdfjam - calls
##           latex pgfpages in background
%-4up.pdf: %_Handout.pdf
	$(PDFJAM) $(PDFJAM_OPTS) -o $@ ${PDFJAM_4UP} $<

%-2up.pdf: %_Handout.pdf
	$(PDFJAM) $(PDFJAM_OPTS) -o $@ ${PDFJAM_2UP} $<

%-6up.pdf: %_Handout.pdf
	$(PDFJAM)-slides6up $(PDFJAM_OPTS) -o $@ $(PDFJAM_6UP) $< 

%-3up.pdf: %_Handout.pdf
	$(PDFJAM)-slides3up $(PDFJAM_OPTS) -o $@ $(PDFJAM_3UP) $<

## extract R syntax using knitr::purl ## declared above
%-syntax.R: %.Rnw
	${RSCRIPT} ${RSCRIPT_OPTS}  -e 'library(knitr);purl("$<", out="$@")'
%-syntax.R: %.rnw
	${RSCRIPT} ${RSCRIPT_OPTS}  -e 'library(knitr);purl("$<", out="$@")'

## housekeeping which needs improving - especially backup (.tgz or
## .zip file?)  but this won't work without extra directories etc
## needs some checking and thought

.PHONY: clean
clean: 
	-${RM} ${RM_OPTS} -f *.pdf *.Rout *.log *.aux *.bbl *~

.PHONY: backup
backup:
	-zip -9 backup/backup-`date +%F`.zip *.R Makefile */*/*.csv *.pdf *.Rnw *.Rmd *.Rout
