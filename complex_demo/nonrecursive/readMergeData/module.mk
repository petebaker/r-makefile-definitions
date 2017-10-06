## module.mk for readMerge
## NB: assumes R_OUT_EXT set to either Rout, pdf, html, docx, odt etc

.PHONY: all_readMergeData
all_readMergeData: ${READ}/clean_simple_csv.${R_OUT_EXT}

## Clean data and store for analysis
${READ}/clean_simple_csv.${R_OUT_EXT}: ${READ}/${@:.${R_OUT_EXT}=.R} ${READ}/read_simple_csv.${R_OUT_EXT}

## Read data and store for cleaning
${READ}/read_simple_csv.${R_OUT_EXT}: ${READ}/${@:.${R_OUT_EXT}=.R} ${DATA_ORIG}/simple.csv
