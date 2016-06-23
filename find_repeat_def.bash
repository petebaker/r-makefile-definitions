#!/bin/bash
#
# Filename: find_repeat_def.bash
# Purpose: Trobleshooting: Find repeated definitions
#
# To make file executable in terminal use:  chmod +x find_repeat_def.bash

# Created at:  Thu Jun 23 14:42:05 2016
# Author:      Peter Baker
# Hostname:    MBS-PU-1NJFVH8
# Directory:   /Users/uqpbake1/Data/scripts/makefile-common/
# Licence:     GPLv3 see <http://www.gnu.org/licenses/>
#
# Platform:     Not specified - linux at least
#
# Based on pp 7-8 of Randal K Michael (2008) Mastering UNIX Shell Scripting
#
# set -n  # Uncomment to check script syntax, without extension
#         # NOTE: Do not forget to put the comment back in or
#         #       the shell script wil not execute
# set -x  # Uncomment to debug this shell script
#
# Change Log: 
#
#
######################################################################
#          Define files and variables here                           #
######################################################################


######################################################################
#          Define functions here                                     #
######################################################################


######################################################################
#          Beginning of MAIN                                         #
######################################################################

grep : common.mk | grep "^%" | sort > all_definitions.txt

grep : common.mk | grep "^%" | sort | uniq -d

## grep : common.mk | grep "^%" | grep \%pdf

