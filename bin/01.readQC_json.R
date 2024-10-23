#what this script does:
# 1. reads multiple fastp.json files
# 2. aggregate them into a list
# 3. Reads though the list, extracting 'summary' statistics and joins them all in one dataframe.
# 4. Calculates the mean for each summary statistic: total.reads, total.bases, ...

#Installation and setup
setwd("/home/gkibet/bioinformatics/github/metagenomics/data/visualization_WWP2/")
lib="/home/gkibet/R/x86_64-pc-linux-gnu-library/4.3"
source("./scripts/functions.R")

requiredCRANPackages= c("tidyverse", "rjson", "readr", "jsonlite", 
                    "xml2", "magrittr","hrbrthemes","openxlsx")

#  CRAN packages will be installed if they are not yet installed.
installNloadCRANpackages(requiredPackages = requiredCRANPackages, lib = lib)

#Read from Sample_data.csv
metadata <- read.csv("./metadata/20240429_Wastewater_Metadata_true.csv", header = T, sep = ",") %>% 
  filter(.,Seqrun %in% c("run01","run02","run03","run04","run05","run06","run07","run08","run09","run10","run11"))
#View(metadata)
shortDate <- gsub("-","",base::Sys.Date())
#shortDate
shortDate="20240429"

# Create input df for filter_Reports() - Must have two columns 'Name' and 'ReportFilePath'
# 'Name' column contains preferred names for the samples from which the report was generated
# 'ReportFilePath' column contains filepaths to the kreports matching the 'Name'
jsonFiles <- metadata %>% select(Name,sampleID,ReportFilePath_kraken2) %>% 
  mutate(QCjsonFilePath = gsub('kreports/kraken2', 'QCreports',
                               gsub('.kraken2_report.txt','.fastp.json', ReportFilePath_kraken2, 
                                      ignore.case = FALSE, perl = FALSE, 
                                      fixed = FALSE, useBytes = FALSE)))
#View(jsonFiles)

# Running the analysis
qcReportsList <- read_jsonQCReports(jsonFilesdf = jsonFiles,idColName="sampleID")
fastp_summary_df <- read_summaryQCreports(qcReportsList)

write.table(fastp_summary_df, file = paste("./plotdata/metrics/",shortDate,"_fastpQC_SummaryStatistics.csv", sep = ""),
            row.names = FALSE, col.names= TRUE, sep = "\t")
write.xlsx(fastp_summary_df, file = paste("./plotdata/metrics/",shortDate,"_fastpQC_SummaryStatistics.xlsx", sep = ""),
           rowNames = FALSE, colNames= TRUE, sep = "\t")

# readCounts <- fastp_summary_df %>% select(sampleID,raw.total_reads, trimmed.total_reads) %>% 
#   mutate(dropped.reads = raw.total_reads - trimmed.total_reads)

