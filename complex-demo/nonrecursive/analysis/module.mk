## module.mk for analysis
## NB: assumes R_OUT_EXT set to either Rout, pdf, html, docx, odt etc

.PHONY: all_analysis
all_analysis: ${ANALYSIS}/summary_simple_csv.${R_OUT_EXT} ${ANALYSIS}/analyse_simple_csv.${R_OUT_EXT}

## Summarise data given that it is the latest, cleaned version
${ANALYSIS}/summary_simple_csv.${R_OUT_EXT}: ${ANALYSIS}/${@:.${R_OUT_EXT}=.R} ${READ}/clean_simple_csv.${R_OUT_EXT}

## Analyse data given that it is the latest, cleaned version
${ANALYSIS}/analyse_simple_csv.${R_OUT_EXT}: ${ANALYSIS}/${@:.${R_OUT_EXT}=.R} ${READ}/clean_simple_csv.${R_OUT_EXT}
