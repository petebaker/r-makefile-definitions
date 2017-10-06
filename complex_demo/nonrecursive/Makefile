## File: Makefile   for root directory
## This is a non-recursive Makefile for a small multi-directory project

## include function definitions to find root directory
include ~/lib/r-rules-functions.mk
_ROOT := $(patsubst %/root.mk,%,$(call _find,$(CURDIR),root.mk))

## relative directories?? needed?? base or sub by 1
RELATIV = ./

## include definitions of rules and filename extensions for .R and .Rmd
include root.mk

## all subdirectories - note order reports, analyses and read
SUBDIRS=$(REPORTS) $(ANALYSIS)  $(READ)

## include module.mk files in sub directories
## NB: addsuffix described pp 74 Mecklenburg and used pp 98 Graham-Cummings
##     for non-recursive make
include $(addsuffix /module.mk,$(SUBDIRS))

## Makefile target
.PHONY: all
all: all-$(SUBDIRS)

## clean intermediate files using explicit woldcarding in shell
.PHONY: cleanall
cleanall:
	${RM} */*.Rout */*.pdf */.*.html */*.docx */*.odt data/derived/* *.Rout *.pdf *.html *.odt *.docx

include ~/lib/r-rules.mk

## programs
MAKE=gmake
RM = rm -f

