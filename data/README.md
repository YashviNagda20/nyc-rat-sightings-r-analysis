# Data Documentation

## NYC Rat Sightings Dataset

---

## Overview

This folder contains the rat sighting data from New York City (2010-2017) used for analyzing geographic, temporal, and location-based patterns.

**Dataset Name**: `Rat_Sightings.csv`  
**Source**: NYC Department of Health and Mental Hygiene (via Kaggle)  
**Records**: 101,914 rat sighting reports  
**Time Period**: January 2010 - December 2017  
**File Format**: CSV (Comma-Separated Values)

---

## Data Files

### Sample Dataset (In Repository)
- **File**: `Rat_Sightings_sample.csv`
- **Size**: ~5,000-10,000 records
- **Purpose**: Quick exploration and code testing
- **Location**: Available in this repository

### Full Dataset (External Link)
- **File**: See `DATA_DOWNLOAD.md` for download link
- **Size**: ~101,914 records (exceeds GitHub file limit)
- **Purpose**: Complete analysis reproduction
- **Format**: CSV

---

## Dataset Schema

The dataset contains **52 columns** with comprehensive information about each rat sighting report:

### Core Identification Fields

| Field | Type | Description |
|-------|------|-------------|
| `Unique Key` | Numeric | Unique identifier for each report |
| `Created Date` | DateTime | When the sighting was reported (MM/DD/YYYY HH:MM:SS AM/PM) |
| `Closed Date` | DateTime | When the case was closed (if applicable) |
| `Agency` | Text | Reporting agency (typically "DOHMH") |
| `Agency Name` | Text | Full agency name |

### Complaint Details

| Field | Type | Description |
|-------|------|-------------|
| `Complaint Type` | Text | Type of complaint (typically "Rodent") |
| `Descriptor` | Text | Specific descriptor (typically "Rat Sighting") |
| `Status` | Text | Case status (Assigned, Closed, Pending, etc.) |

### Location Information

| Field | Type | Description |
|-------|------|-------------|
| `Location Type` | Text | Where rat was sighted (21 categories, see below) |
| `Borough` | Text | NYC borough (Manhattan, Brooklyn, Bronx, Queens, Staten Island) |
| `Incident Zip` | Numeric | ZIP code where sighting occurred |
| `Incident Address` | Text | Street address of sighting |
| `Street Name` | Text | Name of street |
| `City` | Text | City name (typically NYC borough names) |
| `Latitude` | Numeric | Geographic latitude |
| `Longitude` | Numeric | Geographic longitude |

### Date/Time Fields

| Field | Type | Description |
|-------|------|-------------|
| `Due Date` | DateTime | Date by which case should be resolved |
| `Resolution Action Updated Date` | DateTime | Last update to resolution |

### Coordinates

| Field | Type | Description |
|-------|------|-------------|
| `X Coordinate (State Plane)` | Numeric | New York State Plane coordinate system X |
| `Y Coordinate (State Plane)` | Numeric | New York State Plane coordinate system Y |

---

## Location Type Categories

The dataset includes **21 distinct location types**:

### Residential (Most Common)
1. **1-2 Family Dwelling** - Single or double-family homes
2. **1-2 Family Mixed Use Building** - Residential with commercial ground floor
3. **3+ Family Apt. Building** - Multi-family apartment buildings
4. **3+ Family Mixed Use Building** - Large mixed-use buildings
5. **Single Room Occupancy (SRO)** - SRO housing

### Commercial
6. **Commercial Building** - Standalone commercial properties
7. **Office Building** - Office buildings
8. **Parking Lot/Garage** - Parking facilities

### Public Spaces
9. **Public Garden** - Parks and gardens
10. **Public Stairs** - Public stairways

### Infrastructure
11. **Catch Basin/Sewer** - Sewer and drainage systems
12. **Construction Site** - Active construction areas
13. **Vacant Building** - Abandoned/vacant structures
14. **Vacant Lot** - Empty land parcels

### Institutional
15. **School/Pre-School** - Educational facilities
16. **Day Care/Nursery** - Childcare facilities
17. **Hospital** - Medical facilities
18. **Government Building** - Government offices
19. **Summer Camp** - Seasonal camp facilities

### Other
20. **Other (Explain Below)** - Miscellaneous locations
21. **NA** - Location type not specified

---

## Borough Information

### Geographic Distribution

| Borough | Approximate Population | Area (sq mi) | Average Annual Sightings |
|---------|----------------------|--------------|-------------------------|
| **Brooklyn** | 2.6M | 70 | 3,500-6,000 |
| **Manhattan** | 1.6M | 23 | 2,500-4,500 |
| **Bronx** | 1.4M | 42 | 2,000-3,500 |
| **Queens** | 2.3M | 109 | 1,500-2,500 |
| **Staten Island** | 475K | 58 | 500-700 |

---

## Data Quality Notes

### Completeness
- **Created Date**: 100% complete
- **Location Type**: ~95% complete (some NA values)
- **Borough**: ~99% complete
- **Closed Date**: ~70% complete (many cases remain pending)
- **Coordinates**: ~98% complete

### Known Issues
1. **Date Format Variations**: Some dates use 12:00:00 AM timestamp for all entries
2. **Pending Cases**: High percentage of cases marked as "pending" without resolution
3. **Missing Geographic Data**: Small percentage (~2%) missing lat/long coordinates
4. **Duplicate Entries**: Minimal but some reports may represent same incident

### Data Cleaning Applied

**Removed Columns**:
- School-related fields (not relevant to analysis)
- Vehicle-related fields (all NA)
- Other sparse categorical fields

**Handled Missing Values**:
- Filtered NA values in key analysis fields
- Excluded records with missing dates or borough information

**Date Processing**:
```r
# Converted string dates to datetime objects
rat_data <- rat_data %>%
  mutate(created_date = mdy_hms(`Created Date`))

# Created derived temporal fields
rat_data <- rat_data %>%
  mutate(
    sighting_year = year(created_date),
    sighting_month = month(created_date, label = TRUE),
    sighting_day = day(created_date),
    sighting_weekday = wday(created_date, label = TRUE)
  )
```

---

## Temporal Patterns

### Yearly Trends
- **2010**: Baseline year, ~10,000 sightings
- **2011-2013**: Relatively stable
- **2014-2016**: Sharp increase across all boroughs
- **2016**: Peak year with ~17,500 total sightings
- **2017**: Decline to ~15,000 (likely due to enhanced pest control)

### Seasonal Patterns
- **Peak Season**: July-August (summer)
- **Low Season**: December-February (winter)
- **Activity Ratio**: Summer months have 2-3x more sightings than winter months

### Weekly Patterns
Data includes weekday information for temporal analysis of reporting patterns.

---

## Data Source & Access

### Original Source
**NYC Open Data Portal**  
Department of Health and Mental Hygiene  
311 Service Requests

### Kaggle Dataset
**Title**: NYC Rat Sightings  
**URL**: https://www.kaggle.com/datasets/new-york-city/nyc-rat-sightings/data  
**License**: Public Domain  
**Last Updated**: 2018 (covers through 2017)

### Download Instructions
See `DATA_DOWNLOAD.md` in this folder for full dataset access.

---

## Usage Examples

### Loading Data in R

```r
library(tidyverse)
library(lubridate)

# Load CSV
rat_data <- read_csv("data/Rat_Sightings.csv",
  col_types = cols(
    `Created Date` = col_character(),
    `Closed Date` = col_character(),
    `Borough` = col_character(),
    .default = col_guess()
  ),
  na = c("", "NA", "N/A")
)

# Convert dates
rat_data <- rat_data %>%
  mutate(created_date = mdy_hms(`Created Date`))

# Create temporal features
rat_data <- rat_data %>%
  mutate(
    sighting_year = year(created_date),
    sighting_month = month(created_date, label = TRUE)
  )
```

### Basic Summary Statistics

```r
# Total sightings by borough
rat_data %>%
  group_by(Borough) %>%
  summarise(total_sightings = n()) %>%
  arrange(desc(total_sightings))

# Monthly distribution
rat_data %>%
  group_by(sighting_month) %>%
  summarise(sightings = n()) %>%
  arrange(sighting_month)
```

---

## Analysis Recommendations

1. **Geographic Analysis**: Focus on borough-level comparisons
2. **Temporal Analysis**: Examine both yearly trends and seasonal patterns
3. **Location Analysis**: Prioritize residential vs. commercial comparisons
4. **Status Analysis**: Investigate resolution patterns (pending vs. closed cases)

---

## Data Limitations

1. **Reporting Bias**: Data reflects reported sightings, not actual rat population
2. **Response Bias**: Higher reports in areas with more civic engagement
3. **Seasonal Reporting**: People may report more when spending time outdoors (summer)
4. **Time Lag**: Some delay between sighting and formal report
5. **Geographic Coverage**: Not all areas equally represented

---

## Citation

If you use this dataset in your research or analysis, please cite:

```
NYC Department of Health and Mental Hygiene. (2018). 
NYC Rat Sightings Dataset (2010-2017). 
Retrieved from Kaggle: https://www.kaggle.com/datasets/new-york-city/nyc-rat-sightings/data
```

---

## Updates & Maintenance

**Dataset Version**: Static (2010-2017)  
**Last Updated**: 2017  
**Note**: This is a historical dataset; for current rat sighting data, visit NYC Open Data Portal

---

**Questions?** Open an issue in the repository or refer to the main README documentation.
