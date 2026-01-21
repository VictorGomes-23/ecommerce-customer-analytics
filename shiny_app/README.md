# E-Commerce Analytics Dashboard

Interactive Shiny dashboard for exploring customer analytics insights.

## Features

- **Overview**: Key business metrics and trends
- **Customer Segments**: RFM analysis and segmentation
- **Churn Analysis**: Risk assessment and predictions
- **Product Performance**: Top sellers and revenue analysis
- **Cohort Analysis**: Customer retention tracking

## Running Locally

1. Ensure all data files are in `../data/processed/`
2. Open `app.R` in RStudio
3. Click "Run App"

## Data Requirements

- `retail_customers_only.csv`
- `customer_rfm_scored.csv`
- `churn_predictions.csv`

## Dependencies
```r
install.packages(c("shiny", "shinydashboard", "shinyWidgets", 
                   "plotly", "DT", "tidyverse", "lubridate", "scales"))
```

## Deployment

Deploy to shinyapps.io:
```r
library(rsconnect)
deployApp(appDir = "shiny_app")
```
