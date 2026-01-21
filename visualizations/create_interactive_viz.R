# ============================================================================
# INTERACTIVE PORTFOLIO VISUALIZATION
# ============================================================================
# 
# Author: Victor Gomes
# Purpose: Create complex interactive visualization using plotly
#
# ============================================================================

library(tidyverse)
library(plotly)
library(lubridate)
library(here)
library(htmlwidgets)

# Load data
transactions <- read_csv(here("data", "processed", "retail_customers_only.csv"))
customer_rfm <- read_csv(here("data", "processed", "customer_rfm_scored.csv"))
churn_predictions <- read_csv(here("data", "processed", "churn_predictions.csv"))

cat("\n=== CREATING INTERACTIVE VISUALIZATION ===\n\n")

# ============================================================================
# INTERACTIVE VIZ: Multi-Dimensional Customer Analysis
# ============================================================================

cat("Creating interactive customer analysis dashboard...\n")

# Prepare comprehensive customer data
customer_analysis <- customer_rfm %>%
  left_join(churn_predictions, by = "CustomerID") %>%
  mutate(
    Segment = factor(Segment, levels = c("Champions", "Loyal", "Potential", "At Risk", "Lost")),
    Risk_Category = factor(Risk_Category, 
                           levels = c("Low Risk", "Medium Risk", "High Risk", "Critical Risk"))
  ) %>%
  filter(!is.na(Churn_Probability))

# Segment colors
segment_colors_map <- c(
  "Champions" = "#2ecc71",
  "Loyal" = "#3498db",
  "Potential" = "#f39c12",
  "At Risk" = "#e67e22",
  "Lost" = "#e74c3c"
)

# Create interactive scatter plot
interactive_viz <- plot_ly(
  data = customer_analysis,
  x = ~DaysSinceLastPurchase,
  y = ~TotalSpent,
  size = ~TotalTransactions,
  color = ~Segment,
  colors = segment_colors_map,
  type = "scatter",
  mode = "markers",
  marker = list(
    opacity = 0.7,
    line = list(width = 1, color = "white")
  ),
  text = ~paste0(
    "<b>Customer ID:</b> ", CustomerID, "<br>",
    "<b>Segment:</b> ", Segment, "<br>",
    "<b>Risk:</b> ", Risk_Category, "<br>",
    "<b>Days Since Last Purchase:</b> ", round(DaysSinceLastPurchase, 0), "<br>",
    "<b>Total Spent:</b> £", format(round(TotalSpent, 2), big.mark = ","), "<br>",
    "<b>Total Transactions:</b> ", TotalTransactions, "<br>",
    "<b>Churn Probability:</b> ", percent(Churn_Probability, accuracy = 0.1), "<br>",
    "<b>RFM Score:</b> ", RFM_Total
  ),
  hoverinfo = "text"
) %>%
  layout(
    title = list(
      text = "<b>Interactive Customer Analysis: Behavior, Value & Churn Risk</b><br><sub>Hover over points for details | Bubble size = Transaction count | Color = Segment</sub>",
      font = list(size = 16)
    ),
    xaxis = list(
      title = "<b>Days Since Last Purchase (Recency)</b>",
      gridcolor = "#f0f0f0",
      showline = TRUE,
      linecolor = "#d0d0d0"
    ),
    yaxis = list(
      title = "<b>Total Customer Spending (£)</b>",
      gridcolor = "#f0f0f0",
      showline = TRUE,
      linecolor = "#d0d0d0",
      type = "log"  # Log scale for better visualization
    ),
    hovermode = "closest",
    plot_bgcolor = "white",
    paper_bgcolor = "white",
    legend = list(
      title = list(text = "<b>Customer Segment</b>"),
      bgcolor = "rgba(255, 255, 255, 0.8)",
      bordercolor = "#d0d0d0",
      borderwidth = 1
    ),
    margin = list(t = 80, b = 60, l = 80, r = 20)
  ) %>%
  config(
    displayModeBar = TRUE,
    displaylogo = FALSE,
    modeBarButtonsToRemove = c("lasso2d", "select2d", "autoScale2d"),
    toImageButtonOptions = list(
      format = "png",
      filename = "customer_analysis",
      height = 800,
      width = 1200,
      scale = 2
    )
  )

# Save as HTML
saveWidget(
  interactive_viz,
  file = here("visualizations", "08_interactive_customer_analysis.html"),
  selfcontained = TRUE,
  title = "Interactive Customer Analysis"
)

cat("✓ Interactive visualization created!\n")
cat("  File: visualizations/08_interactive_customer_analysis.html\n")
cat("  Open in browser to view\n\n")

# ============================================================================
# BONUS: Create a second interactive viz - Cohort Retention
# ============================================================================

cat("Creating bonus interactive cohort retention heatmap...\n")

# Calculate cohort retention
cohort_data <- transactions %>%
  filter(!IsReturn) %>%
  group_by(CustomerID) %>%
  mutate(CohortMonth = floor_date(min(InvoiceDate), "month")) %>%
  ungroup() %>%
  mutate(
    OrderMonth = floor_date(InvoiceDate, "month"),
    MonthNumber = interval(CohortMonth, OrderMonth) %/% months(1)
  ) %>%
  group_by(CohortMonth, MonthNumber) %>%
  summarize(Customers = n_distinct(CustomerID), .groups = "drop") %>%
  group_by(CohortMonth) %>%
  mutate(
    CohortSize = Customers[MonthNumber == 0],
    Retention = Customers / CohortSize
  ) %>%
  ungroup()

# Create matrix for heatmap
cohort_matrix <- cohort_data %>%
  select(CohortMonth, MonthNumber, Retention) %>%
  pivot_wider(names_from = MonthNumber, values_from = Retention, values_fill = NA)

# Create interactive heatmap
cohort_heatmap <- plot_ly(
  x = colnames(cohort_matrix)[-1],
  y = format(cohort_matrix$CohortMonth, "%Y-%m"),
  z = as.matrix(cohort_matrix[, -1]),
  type = "heatmap",
  colorscale = list(
    c(0, "#fee5d9"),
    c(0.25, "#fcbba1"),
    c(0.5, "#fc9272"),
    c(0.75, "#fb6a4a"),
    c(1, "#de2d26")
  ),
  text = ~paste0(round(as.matrix(cohort_matrix[, -1]) * 100, 0), "%"),
  hovertemplate = "<b>Cohort:</b> %{y}<br><b>Month:</b> %{x}<br><b>Retention:</b> %{text}<extra></extra>",
  showscale = TRUE,
  colorbar = list(
    title = "Retention<br>Rate",
    tickformat = ".0%"
  )
) %>%
  layout(
    title = list(
      text = "<b>Cohort Retention Analysis</b><br><sub>Percentage of customers still active by months since first purchase</sub>",
      font = list(size = 16)
    ),
    xaxis = list(
      title = "<b>Months Since First Purchase</b>",
      showgrid = FALSE
    ),
    yaxis = list(
      title = "<b>Cohort (First Purchase Month)</b>",
      showgrid = FALSE,
      autorange = "reversed"
    ),
    plot_bgcolor = "white",
    paper_bgcolor = "white",
    margin = list(t = 80, b = 60, l = 100, r = 120)
  ) %>%
  config(
    displayModeBar = TRUE,
    displaylogo = FALSE,
    toImageButtonOptions = list(
      format = "png",
      filename = "cohort_retention",
      height = 800,
      width = 1200,
      scale = 2
    )
  )

# Save cohort heatmap
saveWidget(
  cohort_heatmap,
  file = here("visualizations", "09_interactive_cohort_retention.html"),
  selfcontained = TRUE,
  title = "Interactive Cohort Retention"
)

cat("✓ Bonus interactive cohort visualization created!\n")
cat("  File: visualizations/09_interactive_cohort_retention.html\n\n")

cat("=== INTERACTIVE VISUALIZATIONS COMPLETE ===\n")
cat("  2 interactive HTML files created\n")
cat("  Open them in your browser to explore!\n\n")
