# ============================================================================
# VISUALIZATION HELPERS
# ============================================================================
# 
# Author: Victor Gomes
# Purpose: Consistent styling for all portfolio visualizations
#
# ============================================================================

library(tidyverse)
library(scales)

# ============================================================================
# CUSTOM COLOR PALETTE
# ============================================================================

# Primary brand colors
brand_colors <- list(
  primary = "#3498db",      # Blue
  success = "#2ecc71",      # Green
  warning = "#f39c12",      # Orange
  danger = "#e74c3c",       # Red
  info = "#9b59b6",         # Purple
  dark = "#2c3e50",         # Dark gray
  light = "#ecf0f5"         # Light gray
)

# RFM Segment colors
segment_colors <- c(
  "Champions" = "#2ecc71",
  "Loyal" = "#3498db",
  "Potential" = "#f39c12",
  "At Risk" = "#e67e22",
  "Lost" = "#e74c3c"
)

# Sequential color palette (for heatmaps, gradients)
sequential_palette <- c("#fee5d9", "#fcbba1", "#fc9272", "#fb6a4a", "#de2d26")

# Diverging palette (for comparisons)
diverging_palette <- c("#d7191c", "#fdae61", "#ffffbf", "#abd9e9", "#2c7bb6")

# ============================================================================
# CUSTOM GGPLOT2 THEME
# ============================================================================

theme_portfolio <- function(base_size = 12, base_family = "sans") {
  theme_minimal(base_size = base_size, base_family = base_family) +
    theme(
      # Plot styling
      plot.title = element_text(size = rel(1.3), face = "bold", 
                                color = brand_colors$dark, hjust = 0),
      plot.subtitle = element_text(size = rel(1.0), color = "gray40", 
                                   hjust = 0, margin = margin(b = 10)),
      plot.caption = element_text(size = rel(0.8), color = "gray50", 
                                  hjust = 1, margin = margin(t = 10)),
      
      # Axis styling
      axis.title = element_text(size = rel(1.0), face = "bold", 
                                color = brand_colors$dark),
      axis.text = element_text(size = rel(0.9), color = "gray30"),
      axis.line = element_line(color = "gray80", size = 0.5),
      
      # Grid styling
      panel.grid.major = element_line(color = "gray90", size = 0.3),
      panel.grid.minor = element_blank(),
      
      # Legend styling
      legend.title = element_text(size = rel(1.0), face = "bold"),
      legend.text = element_text(size = rel(0.9)),
      legend.position = "right",
      legend.background = element_rect(fill = "white", color = "gray80"),
      legend.key = element_blank(),
      
      # Facet styling
      strip.text = element_text(size = rel(1.0), face = "bold", 
                                color = brand_colors$dark),
      strip.background = element_rect(fill = "gray95", color = "gray80"),
      
      # Background
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "white", color = NA)
    )
}

# Set as default theme
theme_set(theme_portfolio())

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

# Format currency
format_currency <- function(x, prefix = "£") {
  paste0(prefix, format(round(x, 0), big.mark = ","))
}

# Format percentages
format_pct <- function(x, digits = 1) {
  paste0(round(x * 100, digits), "%")
}

# Save high-quality plot
save_portfolio_plot <- function(plot, filename, width = 12, height = 8, dpi = 300) {
  ggsave(
    filename = here::here("visualizations", filename),
    plot = plot,
    width = width,
    height = height,
    dpi = dpi,
    bg = "white"
  )
  cat("✓ Saved:", filename, "\n")
}

cat("✓ Visualization helpers loaded\n")
cat("  Brand colors, custom theme, and helper functions ready\n")

