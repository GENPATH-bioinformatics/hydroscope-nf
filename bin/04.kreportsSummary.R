#what this script does:
# 1. reads multiple kreports files
# 2. aggregate them into a list
# 3. Reads though the list, extracting 'summary' statistics and joins them all in one dataframe.
# 4. Calculates the mean for each summary statistic: total.reads, total.bases, ...

#Installation and setup
setwd("/home/gkibet/bioinformatics/github/metagenomics/data/visualization_WWP2/")
lib="/home/gkibet/R/x86_64-pc-linux-gnu-library/4.3"
source("./scripts/functions.R")

requiredCRANPackages= c("tidyverse", "rjson", "readr", "jsonlite", "data.table","dplyr","RSQLite",
                        "xml2", "magrittr","hrbrthemes","openxlsx","webr")
#requiredGitHubPackages = c("larssnip/microclass","fbreitwieser/pavian")

#  CRAN packages will be installed if they are not yet installed.
installNloadCRANpackages(requiredPackages = requiredCRANPackages, lib = lib)
#  GitHub packages will be installed if they are not yet installed.
# installNloadGitHubpackages(requiredPackages = requiredGitHubPackages, lib = lib)

#Read from Sample_data.csv
metadata <- read.csv("./metadata/20240219_Wastewater_Metadata_true.csv", header = T, sep = ",") %>% 
  filter(.,Seqrun %in% c("run01","run02","run03","run04","run05","run06","run07","run08","run09","run10"))
#View(metadata)
shortDate <- gsub("-","",base::Sys.Date())
#shortDate
shortDate="20240223"

# Create input df for filter_Reports() - Must have two columns 'Name' and 'ReportFilePath'
# 'Name' column contains preferred names for the samples from which the report was generated
# 'ReportFilePath' column contains filepaths to the kreports matching the 'Name'
reportFiles <- metadata %>% select(tool,sampleID,ReportFilePath)
# table(report$taxRank)
#View(reportFiles)
# Running the analysis
kreportsDf <- read_KReports(kreportFilesdf = reportFiles, idColName = "sampleID")
# kreportsDf <- read.csv(file = "./plotdata/abundance/allDomains/20240223_allDomainsMergedReadAbundance.csv",
#                        header = T, sep = "\t")
# View(kreportsList$SPL001)

# Writing output
write.table(kreportsDf, file = paste("./plotdata/abundance/allDomains/",shortDate,"_allDomainsMergedReadAbundance.csv", sep = ""),
            row.names = FALSE, col.names= TRUE, sep = "\t", quote = FALSE)
write.xlsx(kreportsDf, file = paste("./plotdata/abundance/allDomains/",shortDate,"_allDomainsMergedReadAbundance.xlsx", sep = ""),
           rowNames = FALSE, colNames= TRUE)
filePath <- paste("./plotdata/abundance/allDomains/",shortDate,"_allDomainsMergedReadAbundance.csv", sep = "")
# kreportsDfFread <- fread(file = filePath, header = T, sep = "\t", nrows = 139000)

db <- dbConnect(SQLite(), dbname = "./plotdata/sqliteDB/k2reports.sqlite")
dbWriteTable(db, "k2reports", read.csv(file = filePath, header = T, sep = "\t"))
dbDisconnect(db)

# Read the db using:
# db <- src_sqlite("./plotdata/sqliteDB/k2reports.sqlite", create = FALSE)
db <- dbConnect(SQLite(), dbname = "./plotdata/sqliteDB/k2reports.sqlite")
# List tables
dbListTables(db)
k2reports <-  tbl(db, "k2reports")
kreportsDfSelection <- k2reports %>% 
  filter(taxRank %in% c("U","R","D","K")) %>%
  select(name, taxRank, ends_with(c("percentage")), taxLineage) %>%
  collect()
# ,"cladeReads","taxonReads"
filePathSelct <- paste("./plotdata/abundance/allDomains/",shortDate,"_selectTaxaMergedReadAbundance.csv", sep = "")
write.table(kreportsDfSelection, file = filePathSelct, row.names = FALSE, col.names= TRUE, sep = "\t", quote = FALSE)
kreportsDfSelection <- read.csv(file = filePathSelct, header = T, sep = "\t")
kreportsDfSelection <- kreportsDfSelection %>% 
  mutate(mean.percentage = rowMeans(select(kreportsDfSelection, ends_with(".percentage")), na.rm = TRUE)) %>%
  mutate_if(is.numeric, round, 2)
kreportsDfSel <- kreportsDfSelection %>% select(name,taxRank,mean.percentage,taxLineage) %>%
  filter(taxRank %in% c("U", "R", "D", "K"))
kreportsDfSel$taxLineage <- gsub("|d_", ";", gsub("|k_", ";", kreportsDfSel$taxLineage, fixed = T), fixed = T) 
kreportsDfSel01 <- kreportsDfSel %>% separate(taxLineage, into = c('root', 'domains', 'kingdoms'), sep = ";") %>%
  separate(root, into = c("root","cellular"), sep = "\\|r1_") %>%
  separate(domains, into = c("domains","sub_domains"), sep = "\\|d1_") %>% 
  select(-cellular,-sub_domains) #%>% 
kreportsDfSel01 <- kreportsDfSel01 %>% 
  mutate_at(c("domains","kingdoms"), ~ case_when(root == "u_unclassified" ~ "zunclassified", TRUE ~ .)) %>%
  mutate_at(c("kingdoms"), ~ case_when(( !is.na(domains) & is.na(.) ) ~ domains, TRUE ~ .)) %>%
  mutate_at(c("domains","kingdoms"), ~ case_when((root == "r_root" & is.na(.) ) ~ "root", TRUE ~ .)) %>%
  filter(!kingdoms %in% c("root","Eukaryota", "Viruses")) %>% select(kingdoms, domains, mean.percentage) %>%
  group_by(domains,kingdoms)
# plot1 <- 
PieDonut(kreportsDfSel01, aes(domains, kingdoms, count=mean.percentage), title = "Taxonomic Classification: Global Average",
         ratioByGroup = FALSE, explode = NULL, explodeDonut = TRUE)
# par(mfrow = c(1,2), mar = c(0,4,0,4))
plot2 <- with(kreportsDfSel01, donuts(mean.percentage, domains, kingdoms))
cairo_pdf(paste("./plots/abundance/",shortDate,"-_selectTaxaMergedReadAbundance_PieDonut2",".pdf", sep = ""),
          width = 10, height = 10)
PieDonut(kreportsDfSel01, aes(domains, kingdoms, count=mean.percentage), title = "Taxonomic Classification: Global Average",
         ratioByGroup = FALSE)
# with(kreportsDfSel01, donuts(mean.percentage, domains, kingdoms))
dev.off()

# %>% rename_at(.vars = vars(ends_with(".percentage")), .funs = funs(sub("[.]percentage$", "", .)))
# colnames(kreportsDfSelection)