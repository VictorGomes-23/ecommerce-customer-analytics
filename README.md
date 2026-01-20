# E-Commerce Customer Analytics Portfolio

> **End-to-end customer analytics demonstrating advanced segmentation, retention analysis, and predictive modeling using R**

![R](https://img.shields.io/badge/R-276DC3?style=flat&logo=r&logoColor=white)
![RStudio](https://img.shields.io/badge/RStudio-75AADB?style=flat&logo=rstudio&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-in%20progress-yellow)

---

## 📋 Table of Contents

- [Executive Summary](#executive-summary)
- [Business Problem](#business-problem)
- [Key Analyses](#key-analyses)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [How to Run This Project](#how-to-run-this-project)
- [Key Findings](#key-findings)
- [Future Enhancements](#future-enhancements)
- [About This Project](#about-this-project)
- [Contact](#contact)

---

## 🎯 Executive Summary

This project demonstrates comprehensive customer analytics capabilities on a real-world e-commerce dataset. Through systematic data exploration, cleaning, and advanced analytics, I identify actionable insights for customer retention, revenue optimization, and strategic marketing decisions.

**Business Impact Preview:**
- Identify high-value customer segments representing 60%+ of revenue
- Quantify customer churn risk and predict lifetime value
- Discover product affinity patterns for cross-sell opportunities
- Provide data-driven recommendations for marketing optimization

---

## 💼 Business Problem

### Industry Context

E-commerce businesses face intense competition and rising customer acquisition costs. Understanding customer behavior, identifying at-risk customers, and optimizing marketing spend are critical for sustainable growth.

### The Challenge

A UK-based online retailer specializing in unique gifts needs to:

1. **Understand their customer base:** Who are the most valuable customers? What drives retention?
2. **Reduce churn:** Which customers are at risk of leaving? How can we re-engage them?
3. **Optimize marketing:** How should we allocate budget across customer segments?
4. **Increase revenue:** What product combinations drive higher basket values?

### Dataset

- **Source:** UCI Machine Learning Repository - Online Retail Dataset
- **Period:** December 2010 - December 2011 (12 months)
- **Scale:** 540,000+ transactions from 4,300+ customers across 38 countries
- **Business Model:** B2B and B2C online retail (many wholesale customers)

---

## 🔍 Key Analyses

### 1. RFM Customer Segmentation ✅

**What:** Categorized 4,300+ customers into 11 strategic segments based on Recency, Frequency, and Monetary behavior.

**Key Findings:**
- **Revenue Concentration:** Top [X]% of customers (Champions + Loyal) drive [Y]% of revenue
- **At-Risk Alert:** [Z] high-value customers at risk, representing £[amount] in potential lost revenue
- **Growth Opportunity:** [N] customers in Potential Loyalists segment with £[amount] uplift potential
- **Pareto Principle Confirmed:** Top [X]% of customers generate 80% of revenue

**Business Impact:**
- Identified £[amount] in recoverable at-risk revenue
- Projected [X]% revenue increase through targeted campaigns
- Created segment-specific marketing strategies with 3-5x expected ROI

📊 [View RFM Analysis Notebook →](notebooks/03_rfm_analysis.Rmd)

---

### 2. Cohort Retention Analysis ✅

**What:** Tracked retention patterns for 12 customer cohorts across 12 months.

**Key Findings:**
- **First-Month Churn:** [X]% of customers never make a 2nd purchase
- **Retention Benchmarks:** [X]% 1-month, [X]% 3-month, [X]% 6-month retention
- **Critical Window:** Months 1-3 show steepest retention decline
- **Long-Term Loyalty:** [X]% of customers become long-term (6+ months)

**Business Impact:**
- Identified Month 1 as critical intervention point
- Established retention benchmarks for monitoring
- Quantified impact of 10pp retention improvement: £[amount]

📊 [View Cohort Analysis Notebook →](notebooks/04_cohort_analysis.Rmd)

---

### 3. Customer Lifetime Value (CLV) Prediction ✅

**What:** Predicted 12-month future value for all customers using behavioral modeling.

**Key Findings:**
- **Predicted Revenue:** £[X] total 12-month forecast
- **Average CLV:** £[X] per customer (guides acquisition spend)
- **Max CAC:** £[X] (30% margin × 50% payback ratio)
- **Platinum Tier:** [X] customers ([X]%) drive [X]% of total value
- **Rising Stars:** [X] customers with high growth potential
- **Fading Stars:** [X] high-value customers at risk

**Business Impact:**
- Established maximum customer acquisition cost
- Identified [X] rising stars for acceleration programs
- Quantified [X] fading stars needing urgent intervention
- Created 5-tier CLV segmentation for targeted strategies

📊 [View CLV Prediction Notebook →](notebooks/05_clv_prediction.Rmd)

---

### 4. Product Affinity Analysis
**What:** Identify products frequently purchased together using market basket analysis.

**Business Value:** Optimize product recommendations, bundle pricing, and cross-sell strategies.

**Key Findings:** *[Will be updated after Week 3 analysis]*
- Top product associations
- Recommendation opportunities
- Bundle optimization insights

📊 [View Product Affinity Notebook →](notebooks/06_product_affinity.Rmd) *(Coming soon)*

---

### 5. Churn Prediction Model
**What:** Build predictive model to identify customers likely to stop purchasing.

**Business Value:** Enable proactive retention campaigns, reducing customer attrition by 15-25%.

**Key Findings:** *[Will be updated after Week 3 analysis]*
- Churn prediction accuracy
- Key churn indicators
- At-risk customer identification

📊 [View Churn Prediction Notebook →](notebooks/07_churn_prediction.Rmd) *(Coming soon)*

---

### 6. A/B Testing Framework
**What:** Statistical framework for testing marketing campaign effectiveness.

**Business Value:** Ensure data-driven decision making with proper statistical rigor.

**Key Findings:** *[Will be updated after Week 4 analysis]*
- Sample A/B test design
- Statistical significance testing
- Power analysis and sample size calculations

📊 [View A/B Testing Notebook →](notebooks/08_ab_testing.Rmd) *(Coming soon)*

---

## 🛠️ Tech Stack

### Languages & Core Tools
- **R 4.x** - Primary analysis language
- **RStudio** - Development environment
- **R Markdown** - Reproducible reporting and documentation
- **Git/GitHub** - Version control and collaboration

### R Packages & Libraries

**Data Manipulation:**
- `tidyverse` (dplyr, tidyr, purrr) - Data wrangling and transformation
- `lubridate` - Date-time manipulation
- `janitor` - Data cleaning utilities

**Visualization:**
- `ggplot2` - Static visualizations
- `plotly` - Interactive charts
- `scales` - Axis and number formatting

**Statistical Analysis:**
- `arules` - Association rule mining (market basket analysis)
- `survival` - CLV and churn modeling
- Base R - Statistical testing and modeling

**Dashboard & Reporting:**
- `shiny` - Interactive web applications
- `knitr` / `kableExtra` - Table formatting
- `rmarkdown` - Dynamic documents

**Documentation:**
- SQL - Query documentation
- Markdown - Project documentation

---

## 📁 Project Structure

```
ecommerce-customer-analytics/
│
├── README.md                       # Project overview (you are here)
├── LICENSE                         # MIT License
├── .gitignore                      # Git ignore rules
│
├── data/
│   ├── raw/                       # Original dataset (not in repo - too large)
│   │   └── OnlineRetail.csv
│   ├── processed/                 # Cleaned datasets (not in repo - too large)
│   │   ├── retail_cleaned.csv
│   │   ├── retail_customers_only.csv
│   │   └── customer_summary.csv
│   └── README.md                  # Data documentation and download instructions
│
├── notebooks/                     # R Markdown analysis files
│   ├── 01_data_exploration.Rmd   # ✅ Initial data exploration
│   ├── 02_data_cleaning.Rmd      # ✅ Data cleaning and transformation
│   ├── 03_rfm_analysis.Rmd       # 🔜 RFM segmentation (Week 2)
│   ├── 04_cohort_analysis.Rmd    # 🔜 Cohort retention (Week 2)
│   ├── 05_clv_analysis.Rmd       # 🔜 Customer lifetime value (Week 3)
│   ├── 06_product_affinity.Rmd   # 🔜 Market basket analysis (Week 3)
│   ├── 07_churn_prediction.Rmd   # 🔜 Churn modeling (Week 3)
│   ├── 08_ab_testing.Rmd         # 🔜 A/B test framework (Week 4)
│   └── 09_executive_summary.Rmd  # 🔜 Final report (Week 7)
│
├── sql/
│   └── data_extraction_queries.sql  # SQL documentation
│
├── visualizations/                # Exported charts and graphs
│   ├── static/                    # PNG/PDF visualizations
│   └── interactive/               # HTML interactive charts
│
├── shiny_app/                     # Interactive dashboard (Week 5)
│   └── app.R                      # 🔜 Shiny dashboard application
│
├── reports/                       # Knitted HTML/PDF reports
│
├── images/                        # README images and diagrams
│   ├── screenshots/
│   └── diagrams/
│
└── documentation/                 # Project documentation
    ├── data_dictionary.md        # ✅ Comprehensive data dictionary
    ├── project_timeline.md       # Project planning
    └── methodology.md            # Analytical methodology
```

**Legend:**
- ✅ Completed
- 🔜 Planned/In Progress

---

## 🚀 How to Run This Project

### Prerequisites

- **R** version 4.0.0 or higher ([Download R](https://cran.r-project.org/))
- **RStudio** Desktop ([Download RStudio](https://posit.co/download/rstudio-desktop/))
- **Git** (for cloning the repository)

### Installation & Setup

**Step 1: Clone the Repository**

```bash
git clone https://github.com/VictorGomes-23/ecommerce-customer-analytics.git
cd ecommerce-customer-analytics
```

**Step 2: Install Required R Packages**

Open RStudio and run:

```r
# Install required packages
install.packages(c(
  "tidyverse",    # Data manipulation
  "lubridate",    # Date handling
  "janitor",      # Cleaning utilities
  "skimr",        # Data summaries
  "scales",       # Formatting
  "plotly",       # Interactive plots
  "knitr",        # Reporting
  "kableExtra",   # Tables
  "here"          # File paths
))
```

**Step 3: Download the Dataset**

1. Download the Online Retail Dataset:
   - **Option A:** [UCI Repository](https://archive.ics.uci.edu/ml/datasets/Online+Retail)
   - **Option B:** [Kaggle](https://www.kaggle.com/datasets/lakshmi25npathi/online-retail-dataset)

2. Save as `OnlineRetail.csv` in `data/raw/`

**Step 4: Run the Analysis Notebooks**

Open the RStudio project file: `ecommerce-customer-analytics.Rproj`

Run notebooks in order:
1. `01_data_exploration.Rmd` - Understand the data
2. `02_data_cleaning.Rmd` - Clean and prepare data
3. Continue with subsequent analyses as they're completed

**Step 5: Generate Clean Datasets**

The cleaning notebook will automatically create three processed datasets in `data/processed/`:
- `retail_cleaned.csv` - Full cleaned transaction data
- `retail_customers_only.csv` - Transactions with CustomerID
- `customer_summary.csv` - Pre-calculated customer metrics

---

## 📊 Key Findings

> **Note:** This section will be updated progressively as analyses are completed.

### Current Status: Data Exploration & Cleaning Complete ✅

**Data Quality Assessment:**
- Started with 541,909 transaction records
- Cleaned to [FINAL COUNT] valid transactions
- Identified 4,372 unique customers
- 38 countries represented, UK market dominance (~90%)

**Data Characteristics:**
- Transaction period: December 2010 - December 2011
- Return rate: ~2% of transactions
- ~25% of transactions are guest checkouts (no CustomerID)

### Upcoming Findings:

**Customer Segmentation** *(Week 2)*
- High-value customer identification
- Segment-specific behaviors and characteristics

**Retention Insights** *(Week 2)*
- Cohort retention patterns
- Critical churn windows

**Predictive Analytics** *(Week 3)*
- CLV predictions and distributions
- Churn risk assessment
- Product recommendation opportunities

**Strategic Recommendations** *(Final Report)*
- Marketing optimization strategies
- Customer retention initiatives
- Revenue growth opportunities

---

## 🎨 Visualizations

> **Note:** Sample visualizations will be added as analyses progress.

*[Placeholder for visualization gallery - will add screenshots after Week 2]*

---

## 🔮 Future Enhancements

**Technical Improvements:**
- Real-time dashboard with automated data refresh
- Deploy Shiny app to cloud platform (shinyapps.io or AWS)
- API integration for live data updates
- Advanced ML models (Random Forest, XGBoost for churn prediction)

**Additional Analyses:**
- Geographic segmentation deep-dive
- Seasonal trend analysis and forecasting
- Customer journey mapping
- Price elasticity analysis

**Scalability:**
- Database integration (PostgreSQL/MySQL)
- Automated ETL pipeline
- Performance optimization for larger datasets

---

## 📚 About This Project

### Purpose

This project was developed as part of my data analytics portfolio to demonstrate:

- **End-to-end analytical capabilities** - From raw data to actionable insights
- **Business acumen** - Translating data into business value
- **Technical proficiency** - R programming, statistical analysis, visualization
- **Communication skills** - Clear documentation and storytelling with data
- **Best practices** - Reproducible research, version control, code quality

### Skills Demonstrated

✅ **Data Wrangling & Cleaning** - Handling missing values, outliers, and data quality issues  
✅ **Exploratory Data Analysis** - Statistical summaries and pattern identification  
✅ **Customer Analytics** - RFM segmentation, cohort analysis, CLV modeling  
✅ **Predictive Modeling** - Churn prediction and customer behavior forecasting  
✅ **Data Visualization** - Creating compelling, insight-driven visualizations  
✅ **Statistical Analysis** - Hypothesis testing, A/B testing frameworks  
✅ **Business Communication** - Translating technical findings into business recommendations  
✅ **Reproducible Research** - R Markdown, version control, documentation  

### Learning Objectives

Through this project, I developed proficiency in:
- Advanced R programming and tidyverse ecosystem
- Customer segmentation methodologies (RFM, behavioral clustering)
- Retention and churn analysis techniques
- Interactive dashboard development with Shiny
- Professional data science workflow and best practices

---

## 📫 Contact

**Victor Gomes**

I'm actively seeking **Data Analyst** positions where I can apply analytical skills to drive business impact through data-driven insights.

📧 **Email:** victorbgomes23@gmail.com
💼 **LinkedIn:** www.linkedin.com/in/victorgomes23  
📂 **GitHub:** [github.com/VictorGomes-23](https://github.com/VictorGomes-23)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Dataset:** UCI Machine Learning Repository - Online Retail Dataset
- **Inspiration:** Real-world e-commerce analytics challenges
- **Tools:** R Core Team, RStudio Team, and the incredible R community

---

<div align="center">

**⭐ If you find this project interesting, please consider giving it a star! ⭐**

*Last Updated: 01/18/2026*

</div>