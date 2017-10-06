## File: root.mk

## sets up directories for finding dependencies and then defines
## directories as common variables used in all Makefiles at any level
## NB: RELATIV =  ./ or ../ is defined in Makefile
##       However, targets/dependencies are definied in each directory
##       in the file module.mk which is included either in the Makefile
##       in the root directory or the major subdirectories

## used for defining subdirectories and targets
READ_SUB=readMergeData
ANALYSIS_SUB=analysis
REPORTS_SUB=reports

## main (sub)directories where the actual work is done
READ=${RELATIV}${READ_SUB}
ANALYSIS=${RELATIV}${ANALYSIS_SUB}
REPORTS=${RELATIV}${REPORTS_SUB}

## data directories for original and derived data files
DATA=${RELATIV}data
DATA_ORIG=${DATA}/original
DATA_DERIV=${DATA}/derived

## output files for R and Rmd - Rout and/or pdf, html, docx, odt etc
## R_OUT_EXT = Rout
R_OUT_EXT = pdf
## RND_OUT_EXT = html
RMD_OUT_EXT = pdf
