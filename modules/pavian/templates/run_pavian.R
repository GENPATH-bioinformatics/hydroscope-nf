#!/usr/bin/env Rscript

# Load required libraries
library(pavian)

# Read the input file
input_data <- read.csv("${input_file}", header=TRUE, sep="\t")

# Run Pavian analysis
results <- pavian::analyze_metagenomics(input_data)

# Create output directory
dir.create("pavian_results", showWarnings = FALSE)

# Save results
saveRDS(results, file="pavian_results/pavian_analysis.rds")

# Generate plots
pdf("pavian_results/pavian_plots.pdf")
plot(results)
dev.off()

# Generate report
rmarkdown::render("pavian_report.Rmd", 
                  output_file = "pavian_results/pavian_report.html",
                  params = list(results = results))

print("Pavian analysis completed. Results saved in 'pavian_results' directory.")
