## File: r-rules-functions.mk
## What: include at top of of Makefile so homegrown functions are defined
##       prior to use


## ---------------------------------------------------------------
## multiple targets ----------------------------------------------
## ---------------------------------------------------------------

##
## rules for multiple targets as outlined in Graham-Cumming (2015)
##
## for use see Graham-Cumming (2015) or examples in multiple_targets directory

sp :=
sp +=
sentinel = .sentinel.$(subst $(sp),_,$(subst /,_,$1))
atomic = $(eval $1: $(call sentinel,$1) ; @:)$(call sentinel,$1): \
           $2 ; touch $$@ $(foreach t,$1,$(if $(wildcard $t),,$(shell rm -f\
           $(call sentinel,$1))))

## ---------------------------------------------------------------
## non-recursive make helpers ------------------------------------
## ---------------------------------------------------------------

## definitions for non-recursive make eg finding root.mk etc
## See Cummings-Graham pp114 

_walk = $(if $1,$(wildcard /$(subst $(sp),/,$1)/$2) $(call _walk,$(wordlist 2,$(words $1),x $1),$2))
_find = $(firstword $(call _walk,$(strip $(subst /, ,$1)),$2))
##_ROOT := $(patsubst %/root.mk,%,$(call _find,$(CURDIR),root.mk))

