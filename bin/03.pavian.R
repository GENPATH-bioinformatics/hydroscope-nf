#Installation and setup
setwd("/home/gkibet/bioinformatics/github/metagenomics/data/visualization_WWP2/")
#setwd("/home/gkibet/bioinformatics/github/metagenomics/data/20230120_UrbanZooProj_EF_NextSeqHT/visualization/")
lib="/home/gkibet/R/x86_64-pc-linux-gnu-library/4.3"
source("./scripts/functions.R")

## Parsing command line argument
args = commandArgs(trailingOnly=TRUE)
ncores0 = as.numeric(args[1])
print(ncores0)
print(typeof(ncores0))
ncores=ncores0 - 1 #1|16|15
# ncores=18

# The list of all packages to be loaded.
requiredCRANPackages= c("remotes", "BiocManager", 'broom', 'bslib', 'cli', 'FactoMineR', 'formatR', 'highr', 'foreach',
                        'htmlwidgets', 'httpuv', 'isoband', 'tidyverse', 'pkgdown', 'purrr',"openxlsx", 'packrat',
                        'rmarkdown', 'rsconnect', 'shiny', 'shinyWidgets', 'stringi', 'svglite', 'xfun', 'yulab.utils', 
                        'pavian','maptools','doParallel','future','future.apply','parallel','doFuture')
# The two below are used to install the non-CRAN packages from BiocManager and GitHub if not yet installed.
requiredBIOCPackages=c("Rsamtools")
requiredGITHUBPackages = c("fbreitwieser/pavian")

#  CRAN packages will be installed if they are not yet installed.
installNloadCRANpackages(requiredPackages = requiredCRANPackages, lib = lib)
# BiocManager and GitHub packages will be installed using the functions below if they are not yet installed. Uncomment to install.
# installNloadBIOCpackages(requiredPackages = requiredBIOCPackages, lib = lib)
# installNloadGitHubpackages(requiredPackages = requiredGITHUBPackages, lib = lib)
# install.packages("maptools", repos="http://R-Forge.R-project.org")

# To launch shiny app - a shiny App alternative to the code below.
# #Launching Pavian ShinyApp from R, type
# pavian::runApp(port=5000)

#Read from Sample_data.csv
runSelected=c("run01","run02","run03","run04","run05","run06","run07","run08","run09","run10","run11","run12")
# sampleIDsSelected=c("SPL0067","SPL0072","SPL0081")
dataDate="20240506"
metadata <- read.csv(paste("metadata/",dataDate,"_Wastewater_Metadata_true.csv",sep = ""), header = T, sep = ",") %>% 
  filter(.,Seqrun %in% runSelected ) #%>% filter(.,sampleID %in% sampleIDsSelected )
#View(metadata)
shortDate <- gsub("-","",base::Sys.Date())
shortDate="20240503"
#shortDate

# Create input df for filter_Reports() - Must have two columns 'Name' and 'ReportFilePath'
# 'Name' column contains preferred names for the samples from which the report was generated
# 'ReportFilePath' column contains filepaths to the kreports matching the 'Name'
reportFiles <- metadata %>% select(Name,sampleID,ReportFilePath_kraken2,tool) #%>% rename("ReportFilePath" = "ReportFilePath_kraken2")
#reportFilesdf = reportFiles

#taxRanks to keep
filteredTaxRanks = c("D", "K", "P", "C", "O", "F", "G", "S")

#Retain Bacterial taxa only
filteredDomains = c("d_Archaea","d_Eukaryota","d_Viruses")
kreportList <- filter_Reports(reportFilesdf=reportFiles,filteredTaxRanks=filteredTaxRanks,filteredTaxa=filteredDomains,
                              tool="tool",sampleID="Name",ReportFilePath="ReportFilePath_kraken2",nCores=ncores)
saveRDS(kreportList, file = paste("./plotdata/abundance/bacteria/",shortDate,"_bacteriaMergedReads.RData", sep = ""))
# kreportList <- unlist(readRDS("./plotdata/abundance/bacteria/20240502_bacteriaMergedAllreads.RData"), recursive = FALSE)

#Merging samples
cat("\n\tDone filtering Bacterial taxonomic groups...\n",
    "\tWill proceed and write out the output to is: ./plotdata/abundance/bacteria/",shortDate,"*")
bacteriaMergedTaxareads = data.frame()
bacteriaMergedCladereads = data.frame()
bacteriaMergedTaxareads <- merge_reports(kreportList, numeric_col = c("taxonReads"))
bacteriaMergedCladereads <- merge_reports(kreportList, numeric_col = c("cladeReads"))
#Writing output
write.table(bacteriaMergedTaxareads, file = paste("./plotdata/abundance/bacteria/",shortDate,"_bacteriaMergedTaxareads.csv", sep = ""),
            row.names = FALSE, col.names= TRUE, sep = "\t")
write.xlsx(bacteriaMergedTaxareads, file = paste("./plotdata/abundance/bacteria/",shortDate,"_bacteriaMergedTaxareads.xlsx", sep = ""),
           rowNames = FALSE, colNames= TRUE, sep = "\t")
write.table(bacteriaMergedCladereads, file = paste("./plotdata/abundance/bacteria/",shortDate,"_bacteriaMergedCladereads.csv", sep = ""),
            row.names = FALSE, col.names= TRUE, sep = "\t")
write.xlsx(bacteriaMergedCladereads, file = paste("./plotdata/abundance/bacteria/",shortDate,"_bacteriaMergedCladereads.xlsx", sep = ""),
           rowNames = FALSE, colNames= TRUE, sep = "\t")


# #Retain Viral taxa only
Domains = c("d_Archaea","d_Eukaryota","d_Bacteria","d_Virus")

#Taxa to filter
filteredDomains = c("d_Archaea","d_Eukaryota","d_Bacteria") #d_Virus

#taxRanks to keep
filteredTaxRanks = c("D", "K", "P", "C", "O", "F", "G", "S")

# #Filtering Viral reads
kreportList <- filter_Reports(reportFilesdf=reportFiles,filteredTaxRanks=filteredTaxRanks,filteredTaxa=filteredDomains,
                              tool="tooql",sampleID="sampleID",ReportFilePath="ReportFilePath",nCores=ncores)
saveRDS(kreportList, file = paste("./plotdata/abundance/bacteria/",shortDate,"_viralMergedReads.RData", sep = ""))
# kreportList <- unlist(readRDS("./plotdata/abundance/viruses/20240502_viralMergedTaxareads.RData"), recursive = FALSE)

#Merging samples
cat("\n\tDone filtering Viral taxonomic groups...",
    "\n\tWill proceed and write out the output to is: ./plotdata/abundance/viruses/",shortDate,"*")
viralMergedTaxareads = data.frame()
viralMergedCladereads = data.frame()
viralMergedTaxareads <- merge_reports(kreportList, numeric_col = c("taxonReads"))
viralMergedCladereads <- merge_reports(kreportList, numeric_col = c("cladeReads"))
#Writing output
write.table(viralMergedTaxareads, file = paste("./plotdata/abundance/viruses/",shortDate,"_viralMergedTaxareads.csv", sep = ""),
            row.names = FALSE, col.names= TRUE, sep = "\t")
write.xlsx(viralMergedTaxareads, file = paste("./plotdata/abundance/viruses/",shortDate,"_viralMergedTaxareads.xlsx", sep = ""),
           rowNames = FALSE, colNames= TRUE, sep = "\t")
write.table(viralMergedCladereads, file = paste("./plotdata/abundance/viruses/",shortDate,"_viralMergedCladereads.csv", sep = ""),
            row.names = FALSE, col.names= TRUE, sep = "\t")
write.xlsx(viralMergedCladereads, file = paste("./plotdata/abundance/viruses/",shortDate,"_viralMergedCladereads.xlsx", sep = ""),
           rowNames = FALSE, colNames= TRUE, sep = "\t")

# Filtering Phage data minus Viral data 
viralTaxadf <- read.csv("../../docs/ictv/viralTaxa_ictv.tsv", header = T, sep = "\t")
viralTaxa <- as.vector(viralTaxadf$pavian_name)
viralTaxaNoPhage <- filter(viralTaxadf, Group == "virus") %>% pull(pavian_name)
phageTaxa <- filter(viralTaxadf, Group == "phage") %>% pull(pavian_name)

Domains = c("d_Archaea","d_Eukaryota","d_Bacteria")
filteredDomains = c(Domains,viralTaxaNoPhage)

#taxRanks to keep
filteredTaxRanks = c("C","O", "F", "G", "S")

# #Filtering for phage reads
kreportList <- filter_Reports(reportFilesdf=reportFiles,filteredTaxRanks=filteredTaxRanks,filteredTaxa=filteredDomains,
                              tool="tool",sampleID="sampleID",ReportFilePath="ReportFilePath",nCores=ncores)
saveRDS(kreportList, file = paste("./plotdata/abundance/phages/",shortDate,"_phageMergedReads.RData", sep = ""))
# kreportList <- unlist(readRDS("./plotdata/abundance/phages/20240502_phageMergedTaxareads.RData"), recursive = FALSE)

#Merging samples
cat("\n\tDone filtering Phages taxonomic groups...",
    "\n\tWill proceed and write out the output to is: ./plotdata/abundance/phages/",shortDate,"*")
phageMergedTaxareads = data.frame()
phageMergedCladereads = data.frame()
phageMergedTaxareads <- merge_reports(kreportList, numeric_col = c("taxonReads"))
phageMergedCladereads <- merge_reports(kreportList, numeric_col = c("cladeReads"))
#Writing output
write.table(phageMergedTaxareads, file = paste("./plotdata/abundance/phages/",shortDate,"_phageMergedTaxareads.csv", sep = ""),
            row.names = FALSE, col.names= TRUE, sep = "\t")
write.xlsx(phageMergedTaxareads, file = paste("./plotdata/abundance/phages/",shortDate,"_phageMergedTaxareads.xlsx", sep = ""),
           rowNames = FALSE, colNames= TRUE, sep = "\t")
write.table(phageMergedCladereads, file = paste("./plotdata/abundance/phages/",shortDate,"_phageMergedCladereads.csv", sep = ""),
            row.names = FALSE, col.names= TRUE, sep = "\t")
write.xlsx(phageMergedCladereads, file = paste("./plotdata/abundance/phages/",shortDate,"_phageMergedCladereads.xlsx", sep = ""),
           rowNames = FALSE, colNames= TRUE, sep = "\t")


# Filtering Viral data minus phage data
# Taxa to filter
Domains = c("d_Archaea","d_Eukaryota","d_Bacteria") #d_Virus
# phageClass= 'c_Caudoviricetes'
filteredDomains = c(Domains,phageTaxa)

#taxRanks to keep
filteredTaxRanks = c("D", "K", "P", "C", "O", "F", "G", "S")

# #Filtering Viral reads
kreportList <- filter_Reports(reportFilesdf=reportFiles,filteredTaxRanks=filteredTaxRanks,filteredTaxa=filteredDomains,
                              tool="tool",sampleID="sampleID",ReportFilePath="ReportFilePath",nCores=ncores)
saveRDS(kreportList, file = paste("./plotdata/abundance/viruses/",shortDate,"_viralNoPhageMergedReads.RData", sep = ""))
# kreportList <- unlist(readRDS("./plotdata/abundance/viruses/20240502_viralNoPhageMergedTaxareads.RData"), recursive = FALSE)

#Merging samples
cat("\n\tDone filtering Phages taxonomic groups...",
    "\n\tWill proceed and write out the output to is: ./plotdata/abundance/viruses/",shortDate,"*")
viralNoPhageMergedTaxareads = data.frame()
viralNoPhageMergedCladereads = data.frame()
viralNoPhageMergedTaxareads <- merge_reports(kreportList, numeric_col = c("taxonReads"))
viralNoPhageMergedCladereads <- merge_reports(kreportList, numeric_col = c("cladeReads"))

# #Alternative: Filtering phages from ViralMergedData
# viralMergedTaxareads <- read.csv("./plotdata/abundance/viruses/20240112_viralMergedTaxareads.csv", header = T, sep = "\t")
# viralMergedCladereads <- read.csv("./plotdata/abundance/viruses/20240112_viralMergedCladereads.csv", header = T, sep = "\t")
# phageMergedTaxareads <- read.csv("./plotdata/abundance/phages/20240112_phageMergedTaxareads.csv", header = T, sep = "\t")
# phageMergedCladereads <- read.csv("./plotdata/abundance/phages/20240112_phageMergedCladereads.csv", header = T, sep = "\t")
# 
# # Filtering out phages from Viruses:
# viralNoPhageMergedTaxareads <- filter(viralMergedTaxareads, !viralMergedTaxareads$TaxID %in% phageMergedTaxareads$TaxID)
# viralNoPhageMergedCladereads <- filter(viralMergedCladereads, !viralMergedCladereads$TaxID %in% phageMergedCladereads$TaxID)

#Writing output
write.table(viralNoPhageMergedTaxareads, file = paste("./plotdata/abundance/viruses/",shortDate,"_viralNoPhageMergedTaxareads.csv", sep = ""),
            row.names = FALSE, col.names= TRUE, sep = "\t")
write.xlsx(viralNoPhageMergedTaxareads, file = paste("./plotdata/abundance/viruses/",shortDate,"_viralNoPhageMergedTaxareads.xlsx", sep = ""),
           rowNames = FALSE, colNames= TRUE, sep = "\t")
write.table(viralNoPhageMergedCladereads, file = paste("./plotdata/abundance/viruses/",shortDate,"_viralNoPhageMergedCladereads.csv", sep = ""),
            row.names = FALSE, col.names= TRUE, sep = "\t")
write.xlsx(viralNoPhageMergedCladereads, file = paste("./plotdata/abundance/viruses/",shortDate,"_viralNoPhageMergedCladereads.xlsx", sep = ""),
           rowNames = FALSE, colNames= TRUE, sep = "\t")

# # taxRanks to keep
# filteredTaxRanks = c("D", "K", "P", "C", "O", "F", "G", "S")
# 
# # Retain allDomains
# filteredDomains = c("")
# kreportList <- filter_Reports(reportFilesdf=reportFiles,filteredTaxRanks=filteredTaxRanks,filteredTaxa=filteredDomains,
#                               tool="tool",sampleID="sampleID",ReportFilePath="ReportFilePath",nCores=ncores)
# # Merging samples
# allDomainsMergedTaxareads = data.frame()
# allDomainsMergedCladereads = data.frame()
# allDomainsMergedTaxareads <- merge_reports(kreportList, numeric_col = c("taxonReads"))
# allDomainsMergedCladereads <- merge_reports(kreportList, numeric_col = c("cladeReads"))
# # Writing output
# write.table(allDomainsMergedTaxareads, file = paste("./plotdata/abundance/allDomains/",shortDate,"_allDomainsMergedTaxareads.csv", sep = ""),
#             row.names = FALSE, col.names= TRUE, sep = "\t")
# write.xlsx(allDomainsMergedTaxareads, file = paste("./plotdata/abundance/allDomains/",shortDate,"_allDomainsMergedTaxareads.xlsx", sep = ""),
#            rowNames = FALSE, colNames= TRUE, sep = "\t")
# write.table(allDomainsMergedCladereads, file = paste("./plotdata/abundance/allDomains/",shortDate,"_allDomainsMergedCladereads.csv", sep = ""),
#             row.names = FALSE, col.names= TRUE, sep = "\t")
# write.xlsx(allDomainsMergedCladereads, file = paste("./plotdata/abundance/allDomains/",shortDate,"_allDomainsMergedCladereads.xlsx", sep = ""),
#            rowNames = FALSE, colNames= TRUE, sep = "\t")
