## File: Makefile   for root directory
## This is a non-recursive Makefile for a small multi-directory project

## include function definitions to find root directory
include ~/lib/r-rules-functions.mk
_ROOT := $(patsubst %/root.mk,%,$(call _find,$(CURDIR),root.mk))

## relative directories?? needed?? base or sub by 1
RELATIV = ./

## include definitions of rules and filename extensions for .R and .Rmd
include root.mk

## all subdirectories
SUBDIRS=$(REPORTS_SUB) $(ANALYSIS_SUB) $(READ_SUB)

## Makefile target
.PHONY: all
all: all_$(READ_SUB)  all_$(ANALYSIS_SUB) all_$(REPORTS_SUB)

## include module.mk files in sub directories
## NB: addsuffix described pp 74 Mecklenburg and used pp 98 Graham-Cummings
##     for non-recursive make
include $(addsuffix /module.mk,$(SUBDIRS))

## clean intermediate files using explicit wildcarding in shell
.PHONY: cleanall
cleanall:
	${RM} */*.Rout */*.pdf */.*.html */*.docx */*.odt data/derived/* *.Rout *.pdf *.html *.odt *.docx

include ~/lib/r-rules.mk

## programs
MAKE=gmake
RM = rm -f

