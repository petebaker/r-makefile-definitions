## Makefile for readMergeData subdirectory

## include function definitions to find root directory
include ~/lib/r-rules-functions.mk
_ROOT := $(patsubst %/root.mk,%,$(call _find,$(CURDIR),root.mk))

## set up paths to directories comtaining dependencies defined in root.mk 
## if not top level Makefile define RELATIV=.. otherwise RELATIV=.
RELATIV = ../

.PHONY: all
all: all_readMergeData

## include common definitions for directory variables and .R/.Rmd outfiles 
include $(_ROOT)/root.mk

## include targets/dependencies
include module.mk

## local cleanall
.PHONY: cleanall
cleanall: ; rm -f *~ *.Rout *.RData *.pdf *.docx *.html ../data/derived/read_simple_csv.RData

include  ~/lib/r-rules.mk
