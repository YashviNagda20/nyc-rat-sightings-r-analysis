# Scripts Documentation

This folder contains modular R scripts that support the NYC Rat Sightings analysis.

---

## 📁 Scripts Overview

### 1. `data_cleaning.R`

**Purpose**: Data loading, cleaning, and preprocessing functions

**Key Functions**:
- `load_and_clean_rat_data()` - Load CSV and clean data
- `summarize_data()` - Generate quick summary statistics
- `export_clean_data()` - Save cleaned data to CSV

**Usage**:
```r
source("scripts/data_cleaning.R")

# Load and clean data
rat_data <- load_and_clean_rat_data("data/Rat_Sightings.csv")

# View summary
summarize_data(rat_data)

# Export cleaned version
export_clean_data(rat_data, "data/Rat_Sightings_clean.csv")
```

**What it does**:
- Converts date strings to datetime objects
- Creates derived temporal columns (year, month, day, weekday)
- Removes irrelevant columns (school fields, vehicle info, etc.)
- Filters out missing/invalid data
- Provides data quality summary

---

### 2. `visualization_functions.R`

**Purpose**: Reusable plotting functions for creating professional visualizations

**Key Functions**:
- `plot_sightings_by_borough()` - Borough comparison line chart
- `plot_sightings_by_location()` - Location type stacked bar chart
- `plot_seasonal_distribution()` - Monthly/seasonal line chart
- `generate_all_plots()` - Create all 3 visualizations at once
- `theme_rat_sightings()` - Custom ggplot2 theme

**Usage**:
```r
source("scripts/visualization_functions.R")

# Create individual plots
borough_plot <- plot_sightings_by_borough(rat_data, save_plot = TRUE)
location_plot <- plot_sightings_by_location(rat_data, save_plot = TRUE)
seasonal_plot <- plot_seasonal_distribution(rat_data, save_plot = TRUE)

# Or generate all at once
generate_all_plots(rat_data, output_dir = "output")
```

**Output**:
- Each function creates both PNG (high-res) and PDF versions
- Files saved to `output/` directory
- Returns ggplot objects for further customization

---

### 3. `run_analysis.R`

**Purpose**: Complete analysis pipeline from start to finish

**What it does**:
1. ✅ Loads and cleans data
2. ✅ Generates summary statistics
3. ✅ Creates all visualizations
4. ✅ Exports cleaned data and summaries
5. ✅ Prints final report to console

**Usage**:
```r
# Simply run the entire script
source("scripts/run_analysis.R")
```

**Or run it from command line**:
```bash
Rscript scripts/run_analysis.R
```

**Expected Output**:
```
============================================
  NYC RAT SIGHTINGS ANALYSIS PIPELINE
============================================

STEP 1: Loading and Cleaning Data
-------------------------------------------
Loading rat sightings data from: data/Rat_Sightings.csv
Initial rows loaded: 101914
Rows after cleaning: 101234
Data cleaning complete!

STEP 2: Generating Summary Statistics
-------------------------------------------
Total Records: 101234
Date Range: 2010-01-01 to 2017-12-31
...

STEP 3: Creating Visualizations
-------------------------------------------
1. Creating borough plot...
2. Creating location plot...
3. Creating seasonal plot...

STEP 4: Exporting Results
-------------------------------------------
...

============================================
  ANALYSIS COMPLETE!
============================================
```

---

## 🚀 Quick Start Guide

### Option 1: Run Complete Analysis

```r
# Run everything at once
source("scripts/run_analysis.R")
```

### Option 2: Step-by-Step Analysis

```r
# Load libraries
library(tidyverse)
library(lubridate)

# Step 1: Source helper scripts
source("scripts/data_cleaning.R")
source("scripts/visualization_functions.R")

# Step 2: Load and clean data
rat_data <- load_and_clean_rat_data("data/Rat_Sightings.csv")

# Step 3: Explore data
summarize_data(rat_data)
glimpse(rat_data)

# Step 4: Create visualizations
generate_all_plots(rat_data)

# Step 5: Custom analysis
rat_data %>%
  filter(Borough == "BROOKLYN") %>%
  count(sighting_year)
```

---

## 📊 Custom Analysis Examples

### Analyze a Specific Year

```r
source("scripts/run_analysis.R")

# Get sightings by borough for 2016
analyze_year(rat_data, 2016)
```

### Compare Two Boroughs

```r
# Compare Brooklyn vs. Manhattan
compare_boroughs(rat_data, "BROOKLYN", "MANHATTAN")
```

### Filter by Location Type

```r
# Analyze only residential buildings
residential_data <- rat_data %>%
  filter(`Location Type` %in% c("1-2 Family Dwelling", 
                                  "3+ Family Apt. Building"))

# Create custom visualization
plot_sightings_by_borough(residential_data, save_plot = FALSE)
```

---

## 🛠️ Modifying the Scripts

### Adding New Visualizations

1. Open `visualization_functions.R`
2. Add your new function following this template:

```r
plot_my_custom_viz <- function(data, save_plot = TRUE, output_dir = "output") {
  
  # Prepare data
  summary_data <- data %>%
    # Your data transformations here
  
  # Create plot
  p <- ggplot(summary_data, aes(...)) +
    geom_...() +
    labs(title = "My Title", x = "X Label", y = "Y Label") +
    theme_minimal()
  
  # Save if requested
  if (save_plot) {
    ggsave(file.path(output_dir, "my_plot.png"), p, width = 10, height = 6)
  }
  
  return(p)
}
```

### Adding New Data Cleaning Steps

1. Open `data_cleaning.R`
2. Modify the `load_and_clean_rat_data()` function
3. Add your transformations before the `return(rat_data_clean)` line

---

## 📦 Required Packages

Make sure these packages are installed:

```r
install.packages(c("tidyverse", "lubridate", "ggplot2"))
```

Or run:

```r
# Check and install missing packages
required_packages <- c("tidyverse", "lubridate", "ggplot2")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)
```

---

## 🐛 Troubleshooting

### Error: "File not found"
**Solution**: Ensure you're running scripts from the project root directory:
```r
setwd("/path/to/nyc-rat-sightings-r-analysis")
```

### Error: "Function not found"
**Solution**: Make sure to source the required scripts first:
```r
source("scripts/data_cleaning.R")
source("scripts/visualization_functions.R")
```

### Error: "Package not installed"
**Solution**: Install missing packages:
```r
install.packages("tidyverse")
install.packages("lubridate")
```

---

## 📖 Additional Resources

- **Main Analysis**: See `analysis/A1_Yn_Rat_Sighting.Rmd` for detailed narrative
- **Data Documentation**: See `data/README.md` for dataset information
- **Project README**: See root `README.md` for project overview

---

## 🤝 Contributing

To add new analysis scripts:

1. Create a new `.R` file in this folder
2. Follow the existing code structure and documentation style
3. Update this README with script description and usage
4. Test thoroughly before committing

---

**Last Updated**: December 2025  
**Author**: Yashvi Nagda
