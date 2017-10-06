## Makefile for analysis subdirectory

## include function definitions to find root directory
include ~/lib/r-rules-functions.mk
_ROOT := $(patsubst %/root.mk,%,$(call _find,$(CURDIR),root.mk))

## set up paths to directories comtaining dependencies defined in root.mk 
## if not top level Makefile define RELATIV=.. otherwise RELATIV=.
RELATIV = ../

## include common definitions for directory variables and .R/.Rmd outfiles 
include $(_ROOT)/root.mk

.PHONY: all
all: all_analysis

## the include files do the work
include module.mk
include ${READ}/module.mk

## remove intermediate files
.PHONY: cleanall
cleanall:
	rm -fr *~ *.Rout *.pdf *.html *.docx

include ~/lib/r-rules.mk
