# ============================================================================
# Main Analysis Workflow
# ============================================================================
# Project: NYC Rat Sightings Analysis
# Purpose: Complete analysis pipeline from data loading to visualization
# Author: Yashvi Nagda
# Date: March 2025
# ============================================================================

# This script orchestrates the complete analysis workflow by:
# 1. Loading and cleaning the data
# 2. Generating summary statistics
# 3. Creating all visualizations
# 4. Exporting results

# ============================================================================
# Setup
# ============================================================================

# Clear environment
rm(list = ls())

# Load required libraries
library(tidyverse)
library(lubridate)

# Source helper scripts
source("scripts/data_cleaning.R")
source("scripts/visualization_functions.R")

# ============================================================================
# Configuration
# ============================================================================

# File paths
DATA_FILE <- "data/Rat_Sightings.csv"
OUTPUT_DIR <- "output"

# Create output directory if it doesn't exist
if (!dir.exists(OUTPUT_DIR)) {
  dir.create(OUTPUT_DIR, recursive = TRUE)
}

# ============================================================================
# Step 1: Load and Clean Data
# ============================================================================

cat("\n")
cat("============================================\n")
cat("  NYC RAT SIGHTINGS ANALYSIS PIPELINE\n")
cat("============================================\n\n")

cat("STEP 1: Loading and Cleaning Data\n")
cat("-------------------------------------------\n")

# Load and clean the data
rat_data <- load_and_clean_rat_data(DATA_FILE)

# ============================================================================
# Step 2: Generate Summary Statistics
# ============================================================================

cat("\nSTEP 2: Generating Summary Statistics\n")
cat("-------------------------------------------\n")

summarize_data(rat_data)

# Additional custom summaries
cat("Peak Rat Sighting Month:\n")
peak_month <- rat_data %>%
  count(sighting_month) %>%
  arrange(desc(n)) %>%
  slice(1)
print(peak_month)

cat("\nBorough with Most Sightings:\n")
top_borough <- rat_data %>%
  count(Borough) %>%
  arrange(desc(n)) %>%
  slice(1)
print(top_borough)

cat("\nTop 3 Location Types:\n")
top_locations <- rat_data %>%
  count(`Location Type`) %>%
  arrange(desc(n)) %>%
  head(3)
print(top_locations)

# ============================================================================
# Step 3: Generate Visualizations
# ============================================================================

cat("\nSTEP 3: Creating Visualizations\n")
cat("-------------------------------------------\n")

# Generate all plots at once
generate_all_plots(rat_data, output_dir = OUTPUT_DIR)

# ============================================================================
# Step 4: Export Results
# ============================================================================

cat("\nSTEP 4: Exporting Results\n")
cat("-------------------------------------------\n")

# Export cleaned data
export_clean_data(rat_data, output_path = file.path(OUTPUT_DIR, "Rat_Sightings_clean.csv"))

# Create a summary statistics CSV
summary_by_borough_year <- rat_data %>%
  group_by(Borough, sighting_year) %>%
  summarise(
    total_sightings = n(),
    .groups = 'drop'
  ) %>%
  arrange(Borough, sighting_year)

write_csv(summary_by_borough_year, 
          file.path(OUTPUT_DIR, "summary_borough_year.csv"))
cat("Summary statistics exported to:", file.path(OUTPUT_DIR, "summary_borough_year.csv"), "\n")

# Create a summary by location type
summary_by_location <- rat_data %>%
  count(`Location Type`, name = "total_sightings") %>%
  arrange(desc(total_sightings))

write_csv(summary_by_location, 
          file.path(OUTPUT_DIR, "summary_location_type.csv"))
cat("Location summary exported to:", file.path(OUTPUT_DIR, "summary_location_type.csv"), "\n")

# ============================================================================
# Step 5: Final Report
# ============================================================================

cat("\n")
cat("============================================\n")
cat("  ANALYSIS COMPLETE!\n")
cat("============================================\n\n")

cat("Summary of outputs:\n")
cat("  - Cleaned data:", file.path(OUTPUT_DIR, "Rat_Sightings_clean.csv"), "\n")
cat("  - 6 visualization files (PNG + PDF):", OUTPUT_DIR, "\n")
cat("  - Summary statistics CSVs:", OUTPUT_DIR, "\n\n")

cat("Key Findings:\n")
cat("  - Total rat sightings:", nrow(rat_data), "\n")
cat("  - Date range:", min(rat_data$created_date), "to", max(rat_data$created_date), "\n")
cat("  - Borough with most sightings:", top_borough$Borough, 
    "(", format(top_borough$n, big.mark = ","), ")\n")
cat("  - Peak sighting month:", as.character(peak_month$sighting_month), "\n")
cat("  - Most common location:", top_locations$`Location Type`[1], "\n\n")

cat("Next steps:\n")
cat("  - Review visualizations in the '", OUTPUT_DIR, "' folder\n")
cat("  - Open 'analysis/A1_Yn_Rat_Sighting.Rmd' for detailed analysis\n")
cat("  - Share findings with stakeholders\n\n")

cat("============================================\n\n")

# ============================================================================
# Optional: Quick Analysis Functions
# ============================================================================

#' Analyze Sightings by Borough for a Specific Year
#'
#' @param data Cleaned rat sightings data
#' @param year Year to analyze
#' @export
analyze_year <- function(data, year) {
  data %>%
    filter(sighting_year == year) %>%
    group_by(Borough) %>%
    summarise(sightings = n(), .groups = 'drop') %>%
    arrange(desc(sightings))
}

#' Compare Two Boroughs
#'
#' @param data Cleaned rat sightings data
#' @param borough1 First borough name
#' @param borough2 Second borough name
#' @export
compare_boroughs <- function(data, borough1, borough2) {
  data %>%
    filter(Borough %in% c(borough1, borough2)) %>%
    group_by(Borough, sighting_year) %>%
    summarise(sightings = n(), .groups = 'drop') %>%
    pivot_wider(names_from = Borough, values_from = sightings)
}

# ============================================================================
# END OF SCRIPT
# ============================================================================
