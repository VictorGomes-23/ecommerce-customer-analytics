# E-Commerce Customer Analytics Dashboard

Interactive Shiny dashboard for exploring customer analytics insights from an online retail dataset.

## 🌟 Live Demo

**[→ Launch Live Dashboard](https://victorgomes-23.shinyapps.io/ecommerce-customer-analytics/)**

No installation required! Explore all analyses interactively in your browser.

---

## 📊 Dashboard Features

### 5 Interactive Tabs

1. **Overview** - Business KPIs and key metrics
   - Total Revenue, Customers, Orders, AOV
   - Revenue trends over time
   - Top products and geographic distribution
   - Customer segment breakdown

2. **Customer Segments** - RFM Analysis
   - Segment performance summary table
   - RFM score distributions
   - Revenue contribution by segment
   - Customer Lifetime Value analysis

3. **Churn Analysis** - Predictive Risk Assessment
   - High-risk customer identification
   - Revenue at risk quantification
   - Churn probability distribution
   - Top 20 highest risk customers

4. **Product Performance** - Sales Analytics
   - Top 20 products by revenue
   - Product performance metrics
   - Units sold and pricing analysis
   - Interactive product data table

5. **Cohort Analysis** - Retention Tracking
   - Cohort retention heatmap
   - Average retention rate over time
   - Customer lifecycle visualization

### Interactive Filters

- **Date Range Selector** - Focus on specific time periods
- **Customer Segment Filter** - Analyze specific RFM segments
- **Country Filter** - Geographic analysis
- **Real-time Updates** - All visualizations update based on filter selections

---

## 🛠️ Tech Stack

**Framework:**
- `shiny` - Interactive web application framework
- `shinydashboard` - Dashboard layout and structure
- `shinyWidgets` - Enhanced UI components

**Visualization:**
- `plotly` - Interactive charts with hover tooltips
- `ggplot2` - Static visualizations
- `DT` - Interactive data tables

**Data Processing:**
- `tidyverse` (dplyr, tidyr, readr) - Data manipulation
- `lubridate` - Date/time handling
- `scales` - Number formatting

---

## 💻 Running Locally

### Prerequisites

Install required R packages:
```r
install.packages(c(
  "shiny", "shinydashboard", "shinyWidgets",
  "tidyverse", "lubridate", "scales",
  "plotly", "DT"
))
```

### Data Requirements

Ensure these CSV files are in the `data/` folder:

- `retail_customers_only.csv` - Transaction data
- `customer_rfm_scored.csv` - RFM segmentation results
- `churn_predictions.csv` - Churn risk scores

### Launch the App

**Option 1: Using RStudio**
1. Open `app.R` in RStudio
2. Click the **"Run App"** button
3. Dashboard will open in your browser

**Option 2: Using R Console**
```r
library(shiny)
runApp("path/to/shiny_app")
```

---

## 📂 File Structure
```
shiny_app/
├── app.R                           # Main Shiny application
├── data/                           # Data files
│   ├── retail_customers_only.csv
│   ├── customer_rfm_scored.csv
│   └── churn_predictions.csv
└── README.md                       # This file
```

---

## 🚀 Deployment

This app is deployed on **shinyapps.io** (free tier).

### Deploy Your Own Version

1. **Create shinyapps.io account** at https://www.shinyapps.io/

2. **Configure rsconnect:**
```r
library(rsconnect)
rsconnect::setAccountInfo(
  name = "your-account-name",
  token = "YOUR-TOKEN",
  secret = "YOUR-SECRET"
)
```

3. **Deploy:**
```r
setwd("shiny_app")
rsconnect::deployApp(
  appName = "ecommerce-customer-analytics",
  appTitle = "E-Commerce Customer Analytics Dashboard",
  appFiles = c(
    "app.R",
    "data/retail_customers_only.csv",
    "data/customer_rfm_scored.csv",
    "data/churn_predictions.csv"
  )
)
```

### Deployment Notes

- **Free tier limits:** 5 apps, 25 active hours/month
- **Data size limit:** Keep CSV files under 100MB
- **File paths:** Use relative paths (`data/file.csv`, not `../data/file.csv`)

---

## 📊 Key Metrics Calculated

**Revenue Metrics:**
- Total Revenue
- Revenue per Customer
- Average Order Value
- Revenue by Segment/Country

**Customer Metrics:**
- Total Customers
- Active vs Churned Customers
- Customer Segmentation (Champions, Loyal, At-Risk, Lost)
- Churn Rate & Risk Distribution

**Product Metrics:**
- Total Products & Units Sold
- Top Products by Revenue
- Product Performance Table

**Retention Metrics:**
- Cohort-based Retention Rates
- Customer Lifecycle Analysis
- Retention Heatmaps

---

## 🎨 Dashboard Screenshots

### Overview Tab
![Overview](../visualizations/dashboard_overview.png)

### Churn Analysis Tab
![Churn](../visualizations/dashboard_churn.png)

*(Add screenshots after deployment)*

---

## 🔧 Customization

### Modify Date Range Default

In `app.R`, line ~50:
```r
dateRangeInput(
  "date_range",
  "Date Range:",
  start = max_date - months(6),  # Change default range here
  end = max_date,
  ...
)
```

### Add New Filters

Add filter in sidebar section:
```r
selectInput(
  "new_filter",
  "Filter Name:",
  choices = c("Option 1", "Option 2")
)
```

Then apply filter in `filtered_transactions()` reactive.

### Change Color Scheme

Modify dashboard skin in `ui <- dashboardPage()`:
```r
dashboardPage(
  skin = "blue",  # Options: blue, black, purple, green, red, yellow
  ...
)
```

---

## 🐛 Troubleshooting

**App won't start locally:**
- Check all required packages are installed
- Verify data files exist in `data/` folder
- Check file paths don't use `../`

**Deployment fails:**
- Verify data files are being included in deployment
- Check file sizes (must be under 100MB)
- Run `rsconnect::showLogs()` for detailed errors

**Filters not working:**
- Check filter IDs match those in server logic
- Verify reactive expressions are updating correctly

**Charts not rendering:**
- Ensure filtered data has rows
- Check column names match those in data files
- Verify plotly syntax is correct

---

## 📈 Performance Optimization

For large datasets:
```r
# Sample data for faster loading
transactions <- transactions %>% 
  sample_frac(0.5)  # Use 50% of data
```

For slow filters:
```r
# Add debouncing to prevent excessive updates
filtered_transactions <- debounce(reactive({
  # filter logic
}), 500)  # Wait 500ms after last input change
```

---

## 🤝 Contributing

Improvements welcome! Consider adding:
- Additional analytical views
- More interactive features
- Export functionality (download reports)
- User authentication
- Advanced filtering options

---

## 📝 License

This project is part of the E-Commerce Customer Analytics portfolio project.

---

## 📧 Contact

**Victor Gomes**

- **Live Dashboard:** https://victorgomes-23.shinyapps.io/ecommerce-customer-analytics/
- **GitHub:** https://github.com/VictorGomes-23
- **Email:** your.email@example.com
- **LinkedIn:** linkedin.com/in/your-profile

---

## 🙏 Acknowledgments

- **Dataset:** Online Retail Dataset (UCI Machine Learning Repository)
- **Framework:** RStudio Shiny
- **Deployment:** shinyapps.io

---