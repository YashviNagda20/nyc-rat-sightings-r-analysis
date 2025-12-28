# ============================================================================
# Visualization Functions
# ============================================================================
# Project: NYC Rat Sightings Analysis
# Purpose: Reusable plotting functions for rat sightings data
# Author: Yashvi Nagda
# Date: March 2025
# ============================================================================

library(tidyverse)
library(ggplot2)

#' Plot Rat Sightings by Borough
#'
#' Creates a line plot showing rat sightings trends across NYC boroughs over time
#'
#' @param data Cleaned rat sightings data
#' @param save_plot Logical, whether to save the plot to file
#' @param output_dir Directory where plots should be saved
#' @return A ggplot object
#' @export
plot_sightings_by_borough <- function(data, 
                                      save_plot = TRUE, 
                                      output_dir = "output") {
  
  # Summarize data by borough and year
  sightings_summary <- data %>%
    group_by(Borough, sighting_year) %>%
    summarise(sightings_count = n(), .groups = 'drop') %>%
    arrange(sighting_year, Borough)
  
  # Create the plot
  p <- ggplot(sightings_summary, 
              aes(x = sighting_year, y = sightings_count, 
                  color = Borough, group = Borough)) +
    geom_line(size = 1.2) +
    geom_point(size = 2.5) +
    labs(
      title = "Rat Sightings in NYC by Borough (2010-2017)",
      x = "Year",
      y = "Number of Sightings",
      color = "Borough"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 14),
      axis.title = element_text(size = 12),
      legend.title = element_text(face = "bold")
    ) +
    scale_color_brewer(palette = "Set1")
  
  # Save plot if requested
  if (save_plot) {
    if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)
    
    ggsave(
      filename = file.path(output_dir, "rat_sightings_by_borough.png"),
      plot = p,
      width = 10,
      height = 6,
      dpi = 300
    )
    
    ggsave(
      filename = file.path(output_dir, "rat_sightings_by_borough.pdf"),
      plot = p,
      width = 10,
      height = 6
    )
    
    cat("Borough plot saved to:", output_dir, "\n")
  }
  
  return(p)
}


#' Plot Rat Sightings by Location Type
#'
#' Creates a stacked bar chart showing rat sightings by location type over time
#'
#' @param data Cleaned rat sightings data
#' @param save_plot Logical, whether to save the plot to file
#' @param output_dir Directory where plots should be saved
#' @return A ggplot object
#' @export
plot_sightings_by_location <- function(data, 
                                       save_plot = TRUE, 
                                       output_dir = "output") {
  
  # Summarize data by location type and year
  sightings_by_location <- data %>%
    group_by(`Location Type`, sighting_year) %>%
    summarise(sightings_count = n(), .groups = 'drop') %>%
    arrange(sighting_year, `Location Type`)
  
  # Create the plot
  p <- ggplot(sightings_by_location, 
              aes(x = sighting_year, y = sightings_count, 
                  fill = `Location Type`)) +
    geom_bar(stat = "identity", position = "stack") +
    labs(
      title = "Rat Sightings by Location Type in NYC (2010-2017)",
      x = "Year",
      y = "Number of Sightings",
      fill = "Location Type"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 14),
      axis.title = element_text(size = 12),
      axis.text.x = element_text(angle = 0, hjust = 1),
      legend.title = element_text(face = "bold"),
      legend.text = element_text(size = 8)
    )
  
  # Save plot if requested
  if (save_plot) {
    if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)
    
    ggsave(
      filename = file.path(output_dir, "rat_sightings_by_loc.png"),
      plot = p,
      width = 10,
      height = 6,
      dpi = 300
    )
    
    ggsave(
      filename = file.path(output_dir, "rat_sightings_by_loc.pdf"),
      plot = p,
      width = 10,
      height = 6
    )
    
    cat("Location plot saved to:", output_dir, "\n")
  }
  
  return(p)
}


#' Plot Seasonal Distribution of Rat Sightings
#'
#' Creates a line plot showing seasonal patterns of rat sightings across years
#'
#' @param data Cleaned rat sightings data
#' @param save_plot Logical, whether to save the plot to file
#' @param output_dir Directory where plots should be saved
#' @return A ggplot object
#' @export
plot_seasonal_distribution <- function(data, 
                                       save_plot = TRUE, 
                                       output_dir = "output") {
  
  # Summarize data by month and year
  sightings_by_month <- data %>%
    group_by(sighting_month, sighting_year) %>%
    summarise(sightings_count = n(), .groups = 'drop') %>%
    arrange(sighting_year, sighting_month)
  
  # Create the plot
  p <- ggplot(sightings_by_month, 
              aes(x = sighting_month, y = sightings_count, 
                  color = as.factor(sighting_year), 
                  group = sighting_year)) +
    geom_line(size = 1.2) +
    geom_point(size = 2.5) +
    labs(
      title = "Seasonal Distribution of Rat Sightings in NYC (2010-2017)",
      x = "Month",
      y = "Number of Sightings",
      color = "Year"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 14),
      axis.title = element_text(size = 12),
      axis.text.x = element_text(angle = 0, hjust = 1),
      legend.title = element_text(face = "bold")
    ) +
    scale_color_brewer(palette = "Blues")
  
  # Save plot if requested
  if (save_plot) {
    if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)
    
    ggsave(
      filename = file.path(output_dir, "rat_sightings_by_sea.png"),
      plot = p,
      width = 10,
      height = 6,
      dpi = 300
    )
    
    ggsave(
      filename = file.path(output_dir, "rat_sightings_by_sea.pdf"),
      plot = p,
      width = 10,
      height = 6
    )
    
    cat("Seasonal plot saved to:", output_dir, "\n")
  }
  
  return(p)
}


#' Generate All Visualizations
#'
#' Convenience function to generate all three main visualizations at once
#'
#' @param data Cleaned rat sightings data
#' @param output_dir Directory where plots should be saved
#' @export
generate_all_plots <- function(data, output_dir = "output") {
  
  cat("\n========================================\n")
  cat("GENERATING ALL VISUALIZATIONS\n")
  cat("========================================\n\n")
  
  # Create output directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
    cat("Created output directory:", output_dir, "\n\n")
  }
  
  # Generate plots
  cat("1. Creating borough plot...\n")
  plot_sightings_by_borough(data, save_plot = TRUE, output_dir = output_dir)
  
  cat("\n2. Creating location plot...\n")
  plot_sightings_by_location(data, save_plot = TRUE, output_dir = output_dir)
  
  cat("\n3. Creating seasonal plot...\n")
  plot_seasonal_distribution(data, save_plot = TRUE, output_dir = output_dir)
  
  cat("\n========================================\n")
  cat("ALL VISUALIZATIONS COMPLETE!\n")
  cat("Plots saved to:", output_dir, "\n")
  cat("========================================\n\n")
}


# ============================================================================
# Custom Theme Function (Optional Enhancement)
# ============================================================================

#' Custom NYC Rat Sightings Theme
#'
#' A custom ggplot2 theme for consistent styling across all visualizations
#'
#' @return A ggplot2 theme object
#' @export
theme_rat_sightings <- function() {
  theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 14, hjust = 0),
      plot.subtitle = element_text(size = 11, color = "gray30"),
      axis.title = element_text(size = 12, face = "bold"),
      axis.text = element_text(size = 10),
      legend.title = element_text(face = "bold", size = 11),
      legend.text = element_text(size = 9),
      panel.grid.minor = element_blank(),
      plot.margin = margin(10, 10, 10, 10)
    )
}

# ============================================================================
# END OF SCRIPT
# ============================================================================
