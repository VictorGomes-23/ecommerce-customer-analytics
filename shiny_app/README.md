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
```

---

## Testing Checklist

Before considering Week 5 complete, test:

- [ ] All 5 tabs load without errors
- [ ] Date range filter works on all tabs
- [ ] Segment filter correctly filters data
- [ ] Country filter correctly filters data
- [ ] All KPI boxes show realistic values
- [ ] All charts render properly
- [ ] Charts are interactive (hover tooltips work)
- [ ] Tables are sortable and searchable
- [ ] Dashboard works on mobile (resize browser to test)
- [ ] No console errors in browser developer tools

---

## Common Issues & Solutions

**Issue: "Cannot find data file"**
- Solution: Check file paths are correct (`../data/processed/`)

**Issue: "Package not found"**
- Solution: Install missing packages with `install.packages()`

**Issue: "Plot not rendering"**
- Solution: Check that filtered data has rows, add validation

**Issue: "Dashboard is slow"**
- Solution: Add data aggregation, limit rows in tables

---

## Next Steps

After completing Week 5:

**Week 6**: Create static visualization portfolio
**Week 7**: Write comprehensive documentation
**Week 8**: Deploy to shinyapps.io and final polish

---

## GitHub Commit Message
```
Add interactive Shiny dashboard with 5 analytical views

- Built multi-page dashboard with shinydashboard
- Implemented global filters (date, segment, country)
- Created 5 analytical tabs: Overview, Segments, Churn, Products, Cohorts
- Added 8 KPI value boxes with real-time calculations
- Integrated 15+ interactive plotly visualizations
- Implemented responsive design for mobile viewing
- Added custom CSS styling for professional appearance
- Dashboard ready for local testing and deployment