## Makefile created 16 June 2017
## This is a recursive Makefile so beware

##MAKE=make
MAKE=gmake

##RM=/usr/local/opt/coreutils/libexec/gnubin/rm
RM=rm

## define sub-directories
READ=readMergeData
ANALYSIS=analysis
REPORTS=reports
SUBDIRS=$(READ) $(ANALYSIS) $(REPORTS)

.PHONY: all
all: $(SUBDIRS)

.PHONY: $(SUBDIRS)
$(SUBDIRS): ;  $(MAKE) -C $@

.PHONY: cleanall
cleanall:
	${RM} */*.Rout */*.pdf */.*.html */*.docx */*.odt data/derived/*

include ~/lib/r-rules.mk
