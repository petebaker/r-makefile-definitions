## module.mk for analysis
## NB: assumes R_OUT_EXT set to either Rout, pdf, html, docx, odt etc

.PHONY: all_reports
all_reports: ${REPORTS}/summary_report.${RMD_OUT_EXT} ${REPORTS}/analyse_report.${RMD_OUT_EXT}

## Summarise data given that it is the latest, cleaned version
${REPORTS}/summary_report.${R_OUT_EXT}: ${REPORTS}/${@:.${RMD_OUT_EXT}=.R} ${ANALYSIS}/summary_simple_csv.${R_OUT_EXT}

## Analyse data given that it is the latest, cleaned version
${REPORTS}/analyse_report.${R_OUT_EXT}: ${REPORTS}/${@:.${R_OUT_EXT}=.R} ${ANALYSIS}/analyse_simple_csv.${R_OUT_EXT}
