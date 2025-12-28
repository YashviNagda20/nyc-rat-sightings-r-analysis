# ============================================================================
# Data Cleaning and Preprocessing Script
# ============================================================================
# Project: NYC Rat Sightings Analysis
# Purpose: Load and clean raw rat sighting data
# Author: Yashvi Nagda
# Date: March 2025
# ============================================================================

# Load required libraries
library(tidyverse)
library(lubridate)

#' Load and Clean Rat Sightings Data
#'
#' This function loads the raw rat sightings CSV file and performs
#' data cleaning operations including:
#' - Converting date fields to proper datetime format
#' - Creating derived temporal features (year, month, day, weekday)
#' - Handling missing values
#' - Filtering out irrelevant columns
#'
#' @param file_path Character string path to the CSV file
#' @return A cleaned tibble with rat sighting data
#' @export
load_and_clean_rat_data <- function(file_path = "data/Rat_Sightings.csv") {
  
  # Print loading message
  cat("Loading rat sightings data from:", file_path, "\n")
  
  # Load the CSV file with proper column types
  rat_data <- read_csv(
    file_path,
    col_types = cols(
      `Created Date` = col_character(),
      `Closed Date` = col_character(),
      `Borough` = col_character(),
      `Complaint Type` = col_character(),
      `Descriptor` = col_character(),
      `Location Type` = col_character(),
      .default = col_guess()
    ),
    na = c("", "NA", "N/A")
  )
  
  cat("Initial rows loaded:", nrow(rat_data), "\n")
  
  # Convert "Created Date" to datetime format
  rat_data <- rat_data %>%
    mutate(created_date = mdy_hms(`Created Date`))
  
  # Extract temporal features
  rat_data <- rat_data %>%
    mutate(
      sighting_year = year(created_date),
      sighting_month = month(created_date, label = TRUE),
      sighting_day = day(created_date),
      sighting_weekday = wday(created_date, label = TRUE)
    )
  
  # Remove irrelevant columns (school-related fields, vehicle info, etc.)
  columns_to_remove <- c(
    "School Name", "School Number", "School Region", 
    "School Code", "School Phone Number", "School Address",
    "School City", "School State", "School Zip",
    "School Not Found", "School or Citywide Complaint",
    "Vehicle Type", "Taxi Company Borough", "Taxi Pick Up Location",
    "Bridge Highway Name", "Bridge Highway Direction", "Road Ramp",
    "Bridge Highway Segment", "Garage Lot Name",
    "Ferry Direction", "Ferry Terminal Name"
  )
  
  # Keep only relevant columns
  rat_data <- rat_data %>%
    select(-any_of(columns_to_remove))
  
  # Filter out records with missing critical data
  rat_data_clean <- rat_data %>%
    filter(
      !is.na(created_date),       # Must have creation date
      !is.na(Borough),             # Must have borough
      Borough != "Unspecified"     # Remove unspecified boroughs
    )
  
  cat("Rows after cleaning:", nrow(rat_data_clean), "\n")
  cat("Data cleaning complete!\n")
  
  return(rat_data_clean)
}


#' Quick Data Summary
#'
#' Generate a quick summary of the rat sightings dataset
#'
#' @param data A cleaned rat sightings tibble
#' @return Prints summary statistics to console
#' @export
summarize_data <- function(data) {
  
  cat("\n========================================\n")
  cat("RAT SIGHTINGS DATA SUMMARY\n")
  cat("========================================\n\n")
  
  cat("Total Records:", nrow(data), "\n")
  cat("Date Range:", min(data$created_date, na.rm = TRUE), "to", 
      max(data$created_date, na.rm = TRUE), "\n\n")
  
  cat("Boroughs:\n")
  print(data %>% count(Borough, sort = TRUE))
  
  cat("\nTop 5 Location Types:\n")
  print(data %>% count(`Location Type`, sort = TRUE) %>% head(5))
  
  cat("\nSightings by Year:\n")
  print(data %>% count(sighting_year, sort = FALSE))
  
  cat("\n========================================\n\n")
}


#' Export Cleaned Data
#'
#' Save cleaned data to a new CSV file
#'
#' @param data Cleaned rat sightings data
#' @param output_path Path where cleaned data should be saved
#' @export
export_clean_data <- function(data, output_path = "data/Rat_Sightings_clean.csv") {
  
  cat("Exporting cleaned data to:", output_path, "\n")
  
  write_csv(data, output_path)
  
  cat("Export complete!\n")
}


# ============================================================================
# Main Execution (if script is run directly)
# ============================================================================

if (!interactive()) {
  # Load and clean data
  rat_data <- load_and_clean_rat_data()
  
  # Show summary
  summarize_data(rat_data)
  
  # Export cleaned data
  export_clean_data(rat_data)
}

# ============================================================================
# END OF SCRIPT
# ============================================================================
