# ============================================================================
# PORTFOLIO VISUALIZATIONS
# ============================================================================
# 
# Author: Victor Gomes
# Purpose: Create publication-quality visualizations for portfolio
#
# ============================================================================

# Load libraries
library(tidyverse)
library(lubridate)
library(scales)
library(here)
library(patchwork)  # For combining plots

# Load helpers
source(here("visualizations", "visualization_helpers.R"))

# Load data
transactions <- read_csv(here("data", "processed", "retail_customers_only.csv"))
customer_rfm <- read_csv(here("data", "processed", "customer_rfm_scored.csv"))
churn_predictions <- read_csv(here("data", "processed", "churn_predictions.csv"))

cat("\n=== CREATING PORTFOLIO VISUALIZATIONS ===\n\n")

# ============================================================================
# VISUALIZATION 1: Revenue Trends with Annotations
# ============================================================================

cat("Creating Visualization 1: Revenue Trends...\n")

revenue_monthly <- transactions %>%
  filter(!IsReturn) %>%
  mutate(YearMonth = floor_date(InvoiceDate, "month")) %>%
  group_by(YearMonth) %>%
  summarize(
    Revenue = sum(TotalAmount),
    Orders = n_distinct(InvoiceNo),
    Customers = n_distinct(CustomerID),
    .groups = "drop"
  ) %>%
  mutate(
    Revenue_MA = zoo::rollmean(Revenue, k = 3, fill = NA, align = "right"),
    Growth = (Revenue / lag(Revenue) - 1) * 100
  )

# Find peak month
peak_month <- revenue_monthly %>%
  filter(Revenue == max(Revenue, na.rm = TRUE))

viz_1 <- ggplot(revenue_monthly, aes(x = YearMonth)) +
  # Revenue bars
  geom_col(aes(y = Revenue), fill = brand_colors$primary, alpha = 0.7) +
  # Moving average line
  geom_line(aes(y = Revenue_MA), color = brand_colors$danger, 
            size = 1.2, na.rm = TRUE) +
  # Peak annotation
  geom_point(data = peak_month, aes(y = Revenue), 
             color = brand_colors$success, size = 4) +
  annotate("text", x = peak_month$YearMonth, y = peak_month$Revenue * 1.1,
           label = paste0("Peak: ", format_currency(peak_month$Revenue)),
           fontface = "bold", color = brand_colors$success, size = 4) +
  # Labels
  scale_y_continuous(labels = dollar_format(prefix = "£", scale = 1e-3, suffix = "K")) +
  scale_x_date(date_breaks = "2 months", date_labels = "%b %Y") +
  labs(
    title = "Monthly Revenue Trends",
    subtitle = "Bars show monthly revenue | Line shows 3-month moving average",
    x = NULL,
    y = "Revenue (£)",
    caption = "Source: Online Retail Dataset (UCI ML Repository)"
  ) +
  theme_portfolio() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

save_portfolio_plot(viz_1, "01_revenue_trends.png", width = 12, height = 6)

# ============================================================================
# VISUALIZATION 2: Customer Segmentation (RFM)
# ============================================================================

cat("Creating Visualization 2: Customer Segmentation...\n")

segment_summary <- customer_rfm %>%
  group_by(Segment) %>%
  summarize(
    Customers = n(),
    Total_Revenue = sum(TotalSpent),
    Avg_Revenue = mean(TotalSpent),
    .groups = "drop"
  ) %>%
  mutate(
    Revenue_Pct = Total_Revenue / sum(Total_Revenue),
    Segment = factor(Segment, levels = c("Champions", "Loyal", "Potential", "At Risk", "Lost"))
  ) %>%
  arrange(desc(Total_Revenue))

viz_2 <- ggplot(segment_summary, aes(x = Customers, y = Avg_Revenue, 
                                     size = Total_Revenue, color = Segment)) +
  geom_point(alpha = 0.7) +
  geom_text(aes(label = Segment), vjust = -1.5, fontface = "bold", show.legend = FALSE) +
  scale_size_continuous(
    range = c(10, 30),
    labels = dollar_format(prefix = "£", scale = 1e-3, suffix = "K"),
    name = "Total Revenue"
  ) +
  scale_color_manual(values = segment_colors, name = "Segment") +
  scale_y_continuous(labels = dollar_format(prefix = "£")) +
  scale_x_continuous(labels = comma_format()) +
  labs(
    title = "Customer Segmentation: The 80/20 Rule in Action",
    subtitle = "Bubble size represents total revenue contribution by segment",
    x = "Number of Customers",
    y = "Average Revenue per Customer",
    caption = "Champions and Loyal customers drive majority of revenue despite smaller numbers"
  ) +
  theme_portfolio() +
  theme(legend.position = "bottom")

save_portfolio_plot(viz_2, "02_customer_segmentation.png", width = 12, height = 8)

# ============================================================================
# VISUALIZATION 3: Churn Risk Distribution
# ============================================================================

cat("Creating Visualization 3: Churn Risk Distribution...\n")

churn_summary <- churn_predictions %>%
  mutate(
    Risk_Category = factor(Risk_Category, 
                           levels = c("Low Risk", "Medium Risk", "High Risk", "Critical Risk"))
  ) %>%
  group_by(Risk_Category) %>%
  summarize(
    Customers = n(),
    Revenue_at_Risk = sum(Hist_TotalSpent),
    Avg_Churn_Prob = mean(Churn_Probability),
    .groups = "drop"
  )

risk_colors <- c(
  "Low Risk" = "#2ecc71",
  "Medium Risk" = "#f39c12",
  "High Risk" = "#e67e22",
  "Critical Risk" = "#e74c3c"
)

viz_3 <- ggplot(churn_summary, aes(x = Risk_Category, y = Customers, fill = Risk_Category)) +
  geom_col(alpha = 0.8, width = 0.7) +
  geom_text(aes(label = paste0(comma(Customers), " customers\n",
                               format_currency(Revenue_at_Risk, prefix = "£"))),
            vjust = -0.3, fontface = "bold", size = 3.5) +
  scale_fill_manual(values = risk_colors) +
  scale_y_continuous(labels = comma_format(), expand = expansion(mult = c(0, 0.15))) +
  labs(
    title = "Customer Churn Risk Assessment",
    subtitle = "Number of customers and revenue at risk by risk category",
    x = NULL,
    y = "Number of Customers",
    caption = paste0("Total at-risk revenue: ", 
                     format_currency(sum(churn_summary$Revenue_at_Risk[3:4])))
  ) +
  theme_portfolio() +
  theme(legend.position = "none")

save_portfolio_plot(viz_3, "03_churn_risk_distribution.png", width = 10, height = 7)

# ============================================================================
# VISUALIZATION 4: Top Products Performance
# ============================================================================

cat("Creating Visualization 4: Top Products...\n")

top_products <- transactions %>%
  filter(!IsReturn) %>%
  group_by(Description) %>%
  summarize(
    Revenue = sum(TotalAmount),
    Units = sum(Quantity),
    Orders = n_distinct(InvoiceNo),
    Customers = n_distinct(CustomerID),
    .groups = "drop"
  ) %>%
  arrange(desc(Revenue)) %>%
  head(15) %>%
  mutate(
    Description = str_trunc(Description, 40),
    Description = fct_reorder(Description, Revenue)
  )

viz_4 <- ggplot(top_products, aes(x = Revenue, y = Description)) +
  geom_col(fill = brand_colors$success, alpha = 0.8) +
  geom_text(aes(label = paste0(format_currency(Revenue), "\n", 
                               comma(Units), " units")),
            hjust = -0.1, size = 3, fontface = "bold") +
  scale_x_continuous(
    labels = dollar_format(prefix = "£", scale = 1e-3, suffix = "K"),
    expand = expansion(mult = c(0, 0.2))
  ) +
  labs(
    title = "Top 15 Products by Revenue",
    subtitle = "Revenue and units sold for best-performing products",
    x = "Total Revenue",
    y = NULL,
    caption = paste0("Top 15 products represent ", 
                     format_pct(sum(top_products$Revenue) / sum(transactions$TotalAmount[!transactions$IsReturn])),
                     " of total revenue")
  ) +
  theme_portfolio()

save_portfolio_plot(viz_4, "04_top_products.png", width = 12, height = 8)

# ============================================================================
# VISUALIZATION 5: Geographic Revenue Distribution
# ============================================================================

cat("Creating Visualization 5: Geographic Distribution...\n")

country_revenue <- transactions %>%
  filter(!IsReturn) %>%
  group_by(Country) %>%
  summarize(
    Revenue = sum(TotalAmount),
    Customers = n_distinct(CustomerID),
    Orders = n_distinct(InvoiceNo),
    .groups = "drop"
  ) %>%
  arrange(desc(Revenue)) %>%
  mutate(
    Revenue_Pct = Revenue / sum(Revenue),
    Cumulative_Pct = cumsum(Revenue_Pct),
    Country = fct_reorder(Country, Revenue)
  ) %>%
  head(15)

viz_5 <- ggplot(country_revenue, aes(x = Revenue, y = Country)) +
  geom_col(aes(fill = Revenue_Pct), alpha = 0.8) +
  geom_text(aes(label = format_pct(Revenue_Pct, digits = 1)),
            hjust = -0.2, fontface = "bold", size = 3.5) +
  scale_fill_gradient(
    low = "#e3f2fd",
    high = brand_colors$primary,
    labels = percent_format(),
    name = "% of Total\nRevenue"
  ) +
  scale_x_continuous(
    labels = dollar_format(prefix = "£", scale = 1e-3, suffix = "K"),
    expand = expansion(mult = c(0, 0.15))
  ) +
  labs(
    title = "Revenue Distribution by Country",
    subtitle = "Top 15 countries by total revenue with percentage contribution",
    x = "Total Revenue",
    y = NULL,
    caption = paste0("UK represents ", 
                     format_pct(country_revenue$Revenue_Pct[country_revenue$Country == "United Kingdom"]),
                     " of total revenue")
  ) +
  theme_portfolio()

save_portfolio_plot(viz_5, "05_geographic_revenue.png", width = 12, height = 8)

# ============================================================================
# VISUALIZATION 6: RFM Heatmap
# ============================================================================

cat("Creating Visualization 6: RFM Heatmap...\n")

rfm_grid <- customer_rfm %>%
  group_by(R_Score, F_Score) %>%
  summarize(
    Customers = n(),
    Avg_Monetary = mean(M_Score),
    .groups = "drop"
  )

viz_6 <- ggplot(rfm_grid, aes(x = factor(F_Score), y = factor(R_Score), fill = Avg_Monetary)) +
  geom_tile(color = "white", size = 1) +
  geom_text(aes(label = Customers), color = "white", fontface = "bold", size = 4) +
  scale_fill_gradient2(
    low = brand_colors$danger,
    mid = brand_colors$warning,
    high = brand_colors$success,
    midpoint = 3,
    name = "Avg Monetary\nScore"
  ) +
  labs(
    title = "RFM Analysis: Customer Value Matrix",
    subtitle = "Numbers show customer count | Color shows average monetary value",
    x = "Frequency Score (1 = Low, 5 = High)",
    y = "Recency Score (1 = Long ago, 5 = Recent)",
    caption = "Best customers: High Recency + High Frequency + High Monetary (top-right, darker green)"
  ) +
  theme_portfolio() +
  theme(
    panel.grid = element_blank(),
    legend.position = "right"
  )

save_portfolio_plot(viz_6, "06_rfm_heatmap.png", width = 10, height = 8)

# ============================================================================
# VISUALIZATION 7: Customer Lifetime Value Distribution
# ============================================================================

cat("Creating Visualization 7: CLV Distribution...\n")

clv_data <- customer_rfm %>%
  filter(TotalSpent > 0) %>%
  mutate(
    CLV_Category = cut(
      TotalSpent,
      breaks = c(0, 500, 1000, 2000, 5000, Inf),
      labels = c("£0-500", "£500-1K", "£1K-2K", "£2K-5K", "£5K+"),
      include.lowest = TRUE
    )
  )

clv_summary <- clv_data %>%
  group_by(Segment, CLV_Category) %>%
  summarize(Customers = n(), .groups = "drop") %>%
  group_by(Segment) %>%
  mutate(Pct = Customers / sum(Customers))

viz_7 <- ggplot(clv_summary, aes(x = CLV_Category, y = Pct, fill = Segment)) +
  geom_col(position = "dodge", alpha = 0.8) +
  geom_text(aes(label = percent(Pct, accuracy = 1)),
            position = position_dodge(width = 0.9),
            vjust = -0.3, size = 3, fontface = "bold") +
  scale_fill_manual(values = segment_colors, name = "Segment") +
  scale_y_continuous(labels = percent_format(), expand = expansion(mult = c(0, 0.15))) +
  labs(
    title = "Customer Lifetime Value Distribution by Segment",
    subtitle = "Percentage of customers in each CLV bracket by segment",
    x = "Customer Lifetime Value",
    y = "Percentage of Customers",
    caption = "Champions and Loyal customers concentrated in higher CLV brackets"
  ) +
  theme_portfolio() +
  theme(
    legend.position = "bottom",
    axis.text.x = element_text(angle = 0)
  )

save_portfolio_plot(viz_7, "07_clv_distribution.png", width = 12, height = 7)

cat("\n✓ All 7 static visualizations created successfully!\n")
cat("  Files saved in 'visualizations/' folder\n\n")

