# Portfolio Visualizations

Professional data visualizations showcasing customer analytics insights.

---

## 📊 Static Visualizations (ggplot2)

### 1. Revenue Trends
![Revenue Trends](01_revenue_trends.png)

**Insights:**
- Clear seasonal patterns in revenue
- 3-month moving average shows overall trend
- Peak revenue identified and annotated

**Skills Demonstrated:** Time series visualization, trend analysis, annotations

---

### 2. Customer Segmentation
![Customer Segmentation](02_customer_segmentation.png)

**Insights:**
- Champions and Loyal customers drive majority of revenue
- Clear demonstration of 80/20 principle
- Bubble size represents total revenue contribution

**Skills Demonstrated:** Multi-dimensional visualization, bubble charts, storytelling with data

---

### 3. Churn Risk Distribution
![Churn Risk](03_churn_risk_distribution.png)

**Insights:**
- Clear breakdown of customers by risk level
- Revenue at risk quantified for each category
- Actionable targeting for retention campaigns

**Skills Demonstrated:** Risk assessment visualization, categorical comparisons

---

### 4. Top Products Performance
![Top Products](04_top_products.png)

**Insights:**
- Top 15 products identified with revenue and units
- Clear hierarchy of product performance
- Revenue concentration in top performers

**Skills Demonstrated:** Horizontal bar charts, data labels, ranking visualization

---

### 5. Geographic Revenue Distribution
![Geographic Revenue](05_geographic_revenue.png)

**Insights:**
- UK dominates revenue (>80%)
- Long tail of international markets
- Percentage contributions clearly shown

**Skills Demonstrated:** Geographic analysis, percentage visualization, gradient coloring

---

### 6. RFM Heatmap
![RFM Heatmap](06_rfm_heatmap.png)

**Insights:**
- Visual representation of customer value matrix
- Best customers in top-right quadrant
- Customer count and value combined

**Skills Demonstrated:** Heatmap creation, multi-dimensional analysis, color gradients

---

### 7. Customer Lifetime Value Distribution
![CLV Distribution](07_clv_distribution.png)

**Insights:**
- Champions concentrated in high CLV brackets
- Lost customers predominantly low CLV
- Clear segmentation effectiveness

**Skills Demonstrated:** Grouped bar charts, distribution analysis, segment comparison

---

## 🎯 Interactive Visualizations (Plotly)

### 8. Interactive Customer Analysis
**[Open Interactive Viz](08_interactive_customer_analysis.html)** (Click to explore)

**Features:**
- Hover for detailed customer information
- Filter by segment using legend
- Zoom and pan capabilities
- Bubble size represents transaction count
- Log scale for better visualization of spending patterns

**Insights:**
- Real-time exploration of customer behavior
- Relationship between recency, spending, and churn risk
- Segment clustering patterns visible

**Skills Demonstrated:** Interactive visualization, plotly, multi-dimensional data exploration

---

### 9. Interactive Cohort Retention
**[Open Interactive Viz](09_interactive_cohort_retention.html)** (Click to explore)

**Features:**
- Hover to see exact retention percentages
- Color gradient indicates retention strength
- Downloadable as PNG from toolbar

**Insights:**
- Retention patterns by cohort
- First-month retention critical
- Long-term customer value identification

**Skills Demonstrated:** Cohort analysis, heatmap interaction, retention tracking

---

## 🎨 Visual Design System

### Color Palette

**Primary Colors:**
- Blue (#3498db) - Primary brand color
- Green (#2ecc71) - Success/positive metrics
- Orange (#f39c12) - Warnings/attention
- Red (#e74c3c) - Alerts/negative metrics
- Purple (#9b59b6) - Info/secondary

**Segment Colors:**
- Champions: Green (#2ecc71)
- Loyal: Blue (#3498db)
- Potential: Orange (#f39c12)
- At Risk: Dark Orange (#e67e22)
- Lost: Red (#e74c3c)

### Typography
- **Titles:** Bold, 16pt
- **Subtitles:** Regular, 12pt, gray
- **Axis Labels:** Bold, 10pt
- **Data Labels:** Bold, varying sizes

### Theme Elements
- Clean white background
- Minimal grid lines
- Clear axis labels
- Professional fonts (sans-serif)
- Consistent spacing and margins

---

## 📁 Files in This Directory
```
visualizations/
├── README.md                                    # This file
├── visualization_helpers.R                      # Shared styling functions
├── create_portfolio_visuals.R                   # Static viz generator
├── create_interactive_viz.R                     # Interactive viz generator
├── 01_revenue_trends.png
├── 02_customer_segmentation.png
├── 03_churn_risk_distribution.png
├── 04_top_products.png
├── 05_geographic_revenue.png
├── 06_rfm_heatmap.png
├── 07_clv_distribution.png
├── 08_interactive_customer_analysis.html
└── 09_interactive_cohort_retention.html
```

---

## 🔧 How to Regenerate
```r
# Regenerate all static visualizations
source("visualizations/create_portfolio_visuals.R")

# Regenerate interactive visualizations
source("visualizations/create_interactive_viz.R")
```

---

## 📊 Technical Details

**Static Visualizations:**
- Created with ggplot2
- 300 DPI for print quality
- 12" x 8" (or 12" x 6") dimensions
- PNG format
- White background for versatility

**Interactive Visualizations:**
- Created with plotly
- Self-contained HTML files
- Responsive design
- Download as PNG option included
- Optimized for web viewing

---

**All visualizations created by Victor Gomes**  
**Date:** January 2026  
**Tools:** R, ggplot2, plotly