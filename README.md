# 🐀 NYC Rat Sightings Analysis: Data-Driven Insights Using R

> **R-Based Data Analysis**: Comprehensive examination of **101,914 rat sighting reports** across New York City boroughs (2010-2017) to identify geographic, temporal, and location-based patterns using tidyverse and ggplot2.

[![R](https://img.shields.io/badge/R-276DC3?style=flat&logo=r&logoColor=white)](https://www.r-project.org/)
[![tidyverse](https://img.shields.io/badge/tidyverse-1.3.2-blue)](https://www.tidyverse.org/)
[![ggplot2](https://img.shields.io/badge/ggplot2-Visualization-green)](https://ggplot2.tidyverse.org/)

## 🎯 Project Overview

**Context**: Individual data analysis assignment (Hult International Business School)

**Research Questions**:
1. Which areas experience the most rat sightings?
2. How do rat sightings vary seasonally throughout the year?
3. What are the patterns of rat sightings by location type?

**Dataset**: 101,914 rat sighting records from NYC Department of Health (2010-2017)

**Tools**: R, tidyverse, ggplot2, lubridate, R Markdown

## 📊 Key Findings

### 🗺️ Geographic Distribution

**Borough Rankings** (2010-2017):
1. **Brooklyn**: Highest and fastest-growing rat sightings
   - 2016 Peak: ~6,000 sightings
   - Nearly doubled from 3,300 (2013) to 6,000 (2016)
2. **Manhattan**: Second-highest, consistent ~3,000-4,500 sightings
3. **Bronx**: Third-highest, growing from ~2,000 to 3,500
4. **Queens**: Moderate levels, ~1,500-2,500 sightings
5. **Staten Island**: Lowest and most stable, ~500-700 sightings

**Trend**: All boroughs (except Staten Island) experienced sharp increases from 2013-2016, with a decline in 2017 likely due to enhanced pest control efforts.

### 📅 Seasonal Patterns

**Peak Months**: July and August consistently show highest sightings
- **2016 July**: Record high of 2,200+ sightings
- **Summer (Jun-Aug)**: Average 1,500-2,200 sightings per month
- **Winter (Dec-Feb)**: Lowest activity, 500-800 sightings per month

**Seasonal Insight**: Warm weather months account for disproportionately high rat activity, indicating the need for intensified pest control measures during summer.

### 🏠 Location Type Analysis

**Most Affected Locations**:
1. **1-2 Family Dwellings**: Consistently highest across all years
2. **3+ Family Apartment Buildings**: Second-highest, major residential impact
3. **3+ Family Mixed Use Buildings**: Significant contributor
4. **Commercial Buildings**: Notable but lower than residential

**2016 Peak**: Approximately 17,500 total sightings, with residential buildings (single-family homes and multi-family apartments) accounting for the majority.

**Finding**: Residential areas—particularly multi-family residences—are hardest hit by rat infestations, with most cases labeled as "pending" with limited follow-up action.

## 🔬 Methodology

### Data Processing

**Data Source**: `Rat_Sightings.csv` from Kaggle (NYC Department of Health data)

**Data Cleaning Steps**:
1. Removed irrelevant columns: "school not found", "vehicle type", school-related fields
2. Filtered out NA values to maintain data quality
3. Converted date fields using `lubridate::mdy_hms()`
4. Created derived columns:
   - `sighting_year`: Extracted year from date
   - `sighting_month`: Extracted month (labeled)
   - `sighting_day`: Extracted day
   - `sighting_weekday`: Extracted weekday (labeled)

**Final Dataset**: 101,914 clean records ready for analysis

### Analysis Approach

**R Packages Used**:
```r
library(tidyverse)    # Data manipulation and visualization
library(lubridate)    # Date/time handling
library(ggplot2)      # Advanced visualizations
```

**Visualization Principles Applied**:
- **CRAP Principles**: Contrast, Repetition, Alignment, Proximity
- **Healy's Guidelines**: Honest data presentation, minimal chartjunk, appropriate detail
- **Cairo's Virtues**: Truthful, functional, beautiful, insightful design

## 📈 Visualizations

### 1. Rat Sightings by Borough (2010-2017)

**Type**: Multi-line plot  
**Key Insight**: Brooklyn's rat problem significantly worsened over time, nearly doubling from 2013 to peak in 2016.

**Code Snippet**:
```r
sightings_summary <- rat_data %>%
  group_by(Borough, sighting_year) %>%
  summarise(sightings_count = n(), .groups = 'drop') %>%
  arrange(sighting_year, Borough)

ggplot(sightings_summary, 
       aes(x = sighting_year, y = sightings_count, 
           color = Borough, group = Borough)) +
  geom_line() +
  geom_point() +
  labs(title = "Rat Sightings in NYC by Borough (2010-2017)",
       x = "Year", y = "Number of Sightings") +
  theme_minimal()
```

### 2. Rat Sightings by Location Type (2010-2017)

**Type**: Stacked bar chart  
**Key Insight**: Residential buildings (1-2 family dwellings and apartment buildings) consistently account for the majority of sightings.

**Code Snippet**:
```r
ggplot(sightings_by_location, 
       aes(x = sighting_year, y = sightings_count, 
           fill = `Location Type`)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Rat Sightings by Location Type in NYC (2010-2017)",
       x = "Year", y = "Number of Sightings") +
  theme_minimal()
```

### 3. Seasonal Distribution (2010-2017)

**Type**: Multi-line seasonal plot  
**Key Insight**: Clear summer peaks across all years, with July-August showing 2-3x higher sightings than winter months.

**Code Snippet**:
```r
ggplot(sightings_by_month, 
       aes(x = sighting_month, y = sightings_count, 
           color = sighting_year, group = sighting_year)) +
  geom_line() +
  geom_point() +
  labs(title = "Seasonal Distribution of Rat Sightings in NYC (2010-2017)",
       x = "Month", y = "Number of Sightings") +
  theme_minimal()
```

## 💡 Strategic Insights

### For NYC Public Health Officials

1. **Geographic Prioritization**: Focus resources on Brooklyn, followed by Manhattan and the Bronx
2. **Seasonal Planning**: Intensify pest control efforts May-September (peak activity period)
3. **Residential Focus**: Target multi-family dwellings with education and intervention programs
4. **Follow-up Systems**: Address high volume of "pending" cases lacking resolution

### For Urban Planners

1. **Building Code Enforcement**: Strengthen requirements for rat-proofing residential buildings
2. **Waste Management**: Enhance trash collection frequency during summer months
3. **Public Awareness**: Launch seasonal campaigns about proper waste disposal
4. **Data-Driven Allocation**: Use sighting patterns to optimize exterminator deployment

## 📁 Repository Structure

```
nyc-rat-sightings-r-analysis/
├── README.md                           # This file
├── analysis/
│   ├── A1_Yn_Rat_Sighting.Rmd         # R Markdown analysis notebook
│   └── A1_Yn_Rat_Sighting.pdf         # Compiled PDF report
├── data/
│   ├── README.md                       # Data documentation
│   ├── Rat_Sightings_sample.csv       # Sample dataset (in repo)
│   └── DATA_DOWNLOAD.md                # Link to full dataset
├── output/
│   ├── rat_sightings_by_borough.png
│   ├── rat_sightings_by_borough.pdf
│   ├── rat_sightings_by_loc.png
│   ├── rat_sightings_by_loc.pdf
│   ├── rat_sightings_by_sea.png
│   └── rat_sightings_by_sea.pdf
└── scripts/
    └── data_cleaning.R                 # Data preprocessing script
```

## 🛠️ Technical Implementation

### Data Transformation

**Date Parsing**:
```r
rat_data <- rat_data %>%
  mutate(created_date = mdy_hms(`Created Date`))
```

**Feature Engineering**:
```r
rat_data <- rat_data %>%
  mutate(
    sighting_year = year(created_date),
    sighting_month = month(created_date, label = TRUE),
    sighting_day = day(created_date),
    sighting_weekday = wday(created_date, label = TRUE)
  )
```

### Visualization Best Practices

**Applied Design Principles**:
- ✅ Color differentiation for categorical variables (boroughs, years)
- ✅ Consistent themes across all visualizations (`theme_minimal()`)
- ✅ Clear axis labels and titles
- ✅ Appropriate chart types for each analysis question
- ✅ Multiple export formats (PNG and PDF)

## 🎓 Skills Demonstrated

### Technical Skills
- **R Programming**: Data manipulation with tidyverse/dplyr
- **Data Visualization**: Professional ggplot2 charts
- **Time Series Analysis**: Temporal pattern identification
- **Data Cleaning**: Handling missing values, type conversions
- **Reproducible Research**: R Markdown documentation

### Analytical Skills
- **Exploratory Data Analysis**: Pattern discovery across multiple dimensions
- **Geographic Analysis**: Borough-level comparison
- **Temporal Analysis**: Seasonal trend identification
- **Categorical Analysis**: Location type segmentation
- **Data Interpretation**: Actionable insights from visualizations

### Professional Skills
- **Report Writing**: Clear, structured analysis documentation
- **Data Storytelling**: Connecting findings to real-world implications
- **Visualization Design**: Following established design principles
- **Critical Thinking**: Questioning initial assumptions about "mundane" data

## 📊 Dataset Information

**Source**: NYC Department of Health and Mental Hygiene (via Kaggle)

**Time Period**: 2010-2017 (7 years)

**Records**: 101,914 rat sighting reports

**Key Fields**:
- Created Date / Closed Date
- Borough (5 NYC boroughs)
- Location Type (21 categories)
- Incident Address / Zip Code
- Status (Pending, Closed, etc.)
- Descriptor (primarily "Rat Sighting")

## 🚀 Reproduction Instructions

### Prerequisites
```r
install.packages("tidyverse")
install.packages("lubridate")
install.packages("rmarkdown")
```

### Running the Analysis
1. Clone this repository
2. Download the full dataset (see `data/DATA_DOWNLOAD.md`)
3. Place CSV file in `data/` folder
4. Open `analysis/A1_Yn_Rat_Sighting.Rmd` in RStudio
5. Click "Knit" to generate the report

### Expected Output
- PDF report with analysis and visualizations
- 6 visualization files (PNG and PDF formats) in `output/` folder

## 🔗 References

1. **Kaggle Dataset**: NYC Rat Sightings Data. Retrieved from https://www.kaggle.com/datasets/new-york-city/nyc-rat-sightings/data

2. **ChatGPT** (2024). Claude 3.5 Sonnet [Large language model]. Used for code assistance and debugging.

3. **Anthropic** (2024). Claude 3.5 Sonnet [Large language model]. Used for analysis support.

4. **Wickham, H., & Grolemund, G.** (2017). *R for Data Science*. O'Reilly Media.

## 📄 License

This project is available for educational and portfolio purposes. Please credit if you use any analysis or code from this repository.

---

## 🎓 Academic Context

**Institution**: Hult International Business School  
**Course**: Data Mining & Visualization  
**Assignment**: A1 - Individual Data Analysis Project  
**Date**: March 2025  
**Student**: Yashvi Nagda

---

**⭐ If you found this analysis interesting, please star the repository!**

*This project demonstrates professional-level R programming and data visualization skills applied to urban public health data analysis.*

*Last Updated: December 2025*
