# E-Commerce Customer Analytics Suite

<div align="center">

[![Live Dashboard](https://img.shields.io/badge/🚀_Live_Dashboard-Launch_Now-blue?style=for-the-badge)](https://victorgomes-23.shinyapps.io/ecommerce-customer-analytics/)
[![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)](https://www.r-project.org/)
[![Shiny](https://img.shields.io/badge/Shiny-00A4D8?style=for-the-badge&logo=rstudio&logoColor=white)](https://shiny.posit.co/)
[![GitHub](https://img.shields.io/badge/GitHub-Repository-181717?style=for-the-badge&logo=github)](https://github.com/VictorGomes-23/ecommerce-customer-analytics)

**End-to-end customer analytics project demonstrating advanced data analysis, machine learning, and interactive visualization in R**

[🎯 Live Dashboard](https://victorgomes-23.shinyapps.io/ecommerce-customer-analytics/) • [📊 View Visualizations](#-featured-visualizations) • [📚 Explore Analyses](#-project-analyses) • [🛠️ Tech Stack](#-tech-stack)

</div>

---

## 🎯 Project Overview

This project showcases a **complete data analytics workflow** from raw data to actionable business insights, built entirely in R. It demonstrates skills in data cleaning, statistical analysis, predictive modeling, and interactive dashboard development.

### Business Impact Delivered

- 💰 **Identified £543K in revenue at risk** from customer churn
- 📊 **Segmented 4,372 customers** into actionable marketing groups
- 🎯 **Predicted churn with 78% accuracy** enabling proactive retention
- 📈 **Analyzed 541K+ transactions** to uncover revenue opportunities
- 🔍 **Built interactive dashboard** for real-time business intelligence

### What Makes This Project Stand Out

✅ **Real-world business focus** - Solves actual e-commerce challenges  
✅ **End-to-end workflow** - From data cleaning to deployment  
✅ **Production-ready code** - Clean, documented, reproducible  
✅ **Interactive outputs** - Live dashboard anyone can explore  
✅ **Publication-quality visuals** - Portfolio-ready graphics  
✅ **Statistical rigor** - Proper hypothesis testing and validation

---

## 🚀 Quick Start

### Option 1: Explore the Live Dashboard (Recommended)
**[→ Launch Interactive Dashboard](https://victorgomes-23.shinyapps.io/ecommerce-customer-analytics/)**

No installation required! Interact with all analyses through a professional web interface.

### Option 2: Run Locally
```r
# Clone the repository
git clone https://github.com/VictorGomes-23/ecommerce-customer-analytics.git

# Install required packages
install.packages(c("tidyverse", "shiny", "plotly", "lubridate"))

# Run the Shiny dashboard
shiny::runApp("shiny_app")
```

---

## 📊 Featured Visualizations

### Revenue Trends & Seasonality Analysis
![Revenue Trends](visualizations/01_revenue_trends.png)

**Key Insights:**
- Clear seasonal revenue patterns with peak in November (£685K)
- 3-month moving average reveals underlying growth trend
- 23% revenue increase year-over-year in peak season

**Business Value:** Optimize inventory planning and marketing budget allocation around seasonal patterns

---

### Customer Segmentation Matrix
![Customer Segmentation](visualizations/02_customer_segmentation.png)

**Key Insights:**
- Champions (top 12% of customers) generate 41% of total revenue
- Clear demonstration of Pareto principle in customer value
- Lost customers represent £127K in potential win-back revenue

**Business Value:** Prioritize marketing spend on high-value segments, develop targeted retention campaigns

---

### Churn Risk Assessment
![Churn Risk](visualizations/03_churn_risk_distribution.png)

**Key Insights:**
- 838 customers at high/critical churn risk
- £543K in revenue currently at risk
- Average churn probability: 19.3%

**Business Value:** Enable proactive retention campaigns with ROI of 3.2x for high-risk interventions

---

### Top Products Performance
![Top Products](visualizations/04_top_products.png)

**Key Insights:**
- Top 15 products represent 28% of total revenue
- "World War 2 Gliders" leads with £38.9K revenue
- Strong performance in gift and novelty categories

**Business Value:** Optimize inventory for best-sellers, identify cross-sell opportunities

---

### Geographic Revenue Distribution
![Geographic Revenue](visualizations/05_geographic_revenue.png)

**Key Insights:**
- UK dominates with 82% of total revenue (£7.2M)
- EIRE and Netherlands show strong international presence
- 38 countries with active customers

**Business Value:** Target international expansion, optimize shipping strategies

---

### RFM Customer Value Matrix
![RFM Heatmap](visualizations/06_rfm_heatmap.png)

**Key Insights:**
- Visual representation of customer value across Recency, Frequency, Monetary dimensions
- 724 Champions in top-right quadrant (recent, frequent, high-value)
- Clear identification of at-risk high-value customers

**Business Value:** Precision targeting for marketing campaigns based on customer behavior patterns

---

### Customer Lifetime Value Distribution
![CLV Distribution](visualizations/07_clv_distribution.png)

**Key Insights:**
- Champions predominantly in £2K-5K+ CLV brackets
- 67% of Lost customers have CLV under £500
- Clear segmentation effectiveness validation

**Business Value:** Justify customer acquisition costs, calculate segment-specific marketing budgets

---

### 🎯 Interactive Visualizations

#### Multi-Dimensional Customer Analysis
**[→ Explore Interactive Visualization](visualizations/08_interactive_customer_analysis.html)**

**Features:**
- Hover over 4,372 customers for detailed information
- Filter by segment using interactive legend
- Zoom and pan to explore patterns
- Bubble size represents transaction frequency
- Discover relationships between recency, spending, and churn risk

**Technical Highlights:** Built with Plotly, log-scale transformation for outlier handling, responsive design

---

#### Cohort Retention Heatmap
**[→ Explore Retention Patterns](visualizations/09_interactive_cohort_retention.html)**

**Features:**
- Track 13 monthly cohorts over time
- Hover for exact retention percentages
- Color gradient indicates retention strength (darker = better)
- Download high-resolution PNG from toolbar

**Key Finding:** First-month retention averages 37%, stabilizing at 22% by month 6

---

**[📁 View All Visualizations →](visualizations/)**

---

## 📈 Project Analyses

### 1. 🧹 Data Cleaning & Preparation
**File:** `notebooks/02_data_cleaning.Rmd`

**Challenges Solved:**
- Handled 135,080 missing CustomerIDs (24.9% of data)
- Identified and processed 9,288 returns (-£1.43M impact)
- Removed 1,454 duplicate transactions
- Standardized 38 country names and formats

**Technical Skills:** Data validation, missing value imputation, outlier detection, date parsing

**Result:** Clean dataset of 406,829 valid transactions ready for analysis

---

### 2. 📊 RFM Customer Segmentation
**File:** `notebooks/03_rfm_segmentation.Rmd` | **[View in Dashboard →](https://victorgomes-23.shinyapps.io/ecommerce-customer-analytics/)**

**Methodology:**
- Calculated Recency (days since last purchase), Frequency (transaction count), Monetary (total spend)
- Scored each dimension 1-5 using quintile-based approach
- Segmented customers into 5 actionable groups

**Key Findings:**
- **Champions** (RFM Score 13-15): 512 customers, £3.6M revenue, £7,031 avg spend
- **Loyal** (RFM Score 10-12): 1,247 customers, £2.8M revenue, £2,244 avg spend
- **At Risk** (RFM Score 5-7): 1,183 customers, £1.1M revenue, declining engagement

**Business Recommendations:**
- VIP program for Champions (estimated £180K additional annual revenue)
- Win-back campaign for At Risk segment (£127K revenue recovery potential)
- Upgrade path for Potential customers to Loyal status

**Technical Skills:** Statistical segmentation, quintile analysis, business rule creation

---

### 3. 📅 Cohort Retention Analysis
**File:** `notebooks/04_cohort_analysis.Rmd` | **[View in Dashboard →](https://victorgomes-23.shinyapps.io/ecommerce-customer-analytics/)**

**Methodology:**
- Grouped customers by first purchase month (cohort)
- Tracked purchase behavior over subsequent months
- Calculated retention rates and visualized with heatmap

**Key Findings:**
- Month 0 (acquisition): 100% by definition
- Month 1 retention: 37% average (critical drop-off point)
- Month 6 retention: 22% (stabilization point)
- Best cohort: December 2010 (45% month-1 retention, holiday shoppers)
- Worst cohort: August 2011 (28% month-1 retention, low engagement)

**Business Impact:**
- Identified critical first-month retention window
- Estimated £890K annual revenue impact from 10% retention improvement
- Recommended onboarding email sequence for new customers

**Technical Skills:** Cohort analysis, survival analysis, retention metrics, time-series visualization

---

### 4. 💰 Customer Lifetime Value (CLV) Prediction
**File:** `notebooks/05_clv_prediction.Rmd`

**Methodology:**
- Historical CLV: Sum of all past transactions
- Predictive CLV: Linear regression model using RFM features
- Validation with 80/20 train-test split

**Model Performance:**
- R² = 0.89 (explains 89% of variance)
- RMSE = £412 (prediction error)
- MAE = £287 (average prediction accuracy)

**Key Findings:**
- Average CLV: £1,997 per customer
- Champions average CLV: £7,031 (3.5x overall average)
- Frequency is strongest predictor (β = 0.43)

**Business Applications:**
- Justify customer acquisition costs (max CAC: £400 for positive ROI)
- Prioritize retention efforts by predicted CLV
- Segment-specific marketing budget allocation

**Technical Skills:** Predictive modeling, linear regression, model validation, feature importance

---

### 5. 🛒 Product Affinity Analysis
**File:** `notebooks/06_product_affinity.Rmd`

**Methodology:**
- Market basket analysis using Apriori algorithm
- Calculated support, confidence, and lift metrics
- Identified frequently purchased product combinations

**Key Findings:**
- 247 significant product associations discovered
- Top rule: "Jumbo Bag Red Retrospot" + "Set/6 Red Spotty Paper Cups" (confidence: 0.67)
- Average basket lift: 3.2x (items purchased together 3.2x more than independently)

**Business Recommendations:**
- Product bundling opportunities (estimated £156K additional revenue)
- Strategic product placement for cross-selling
- Recommended items feature for website

**Technical Skills:** Association rule mining, market basket analysis, algorithmic recommendation systems

---

### 6. ⚠️ Churn Prediction Model
**File:** `notebooks/07_churn_prediction.Rmd` | **[View in Dashboard →](https://victorgomes-23.shinyapps.io/ecommerce-customer-analytics/)**

**Methodology:**
- **Temporal split validation** (no data leakage)
  - Historical features: Calculated from data before prediction point
  - Churn labels: Determined from behavior after prediction point
  - 90-day prediction window, 180-day churn definition
- **Logistic regression model** with 18 behavioral features
- **Rigorous validation** using separate test set

**Model Performance:**
- Accuracy: 78.2%
- Precision: 72.4% (of predicted churners, 72.4% actually churned)
- Recall: 68.9% (identified 68.9% of actual churners)
- AUC: 0.847 (excellent discrimination ability)
- F1 Score: 0.706

**Key Predictors:**
1. Recency (days since last purchase): β = 1.87
2. Purchase frequency: β = -0.92
3. Spending trend (recent vs historical): β = -0.64

**Risk Segmentation:**
- **Critical Risk** (>75% churn probability): 187 customers, £156K at risk
- **High Risk** (50-75% probability): 651 customers, £387K at risk
- **Medium Risk** (25-50% probability): 1,124 customers
- **Low Risk** (<25% probability): 2,410 customers

**Business Impact:**
- Proactive retention campaigns targeting 838 high/critical risk customers
- Conservative ROI: 3.2x (save 30% of at-risk customers at £20/customer cost)
- Aggressive ROI: 5.1x (save 50% at £35/customer cost)
- Estimated annual churn prevention value: £271K

**Retention Strategies by Risk:**
- Critical: Personal outreach, 30-40% discount, account manager (£50-75 budget)
- High: Personalized email, 20-25% discount, feedback survey (£25-35 budget)
- Medium: Automated re-engagement, 10-15% discount (£10-15 budget)

**Technical Skills:** Predictive modeling, logistic regression, temporal validation, ROC analysis, business case development

---

### 7. 🧪 A/B Testing Framework
**File:** `notebooks/08_ab_testing.Rmd`

**Test Scenario:**
- **Control (A):** Standard 10% discount email (£2 cost per customer)
- **Treatment (B):** Personalized 15% discount + free shipping (£7 cost per customer)
- **Target:** High and medium churn risk customers
- **Sample Size:** 1,000 customers per group

**Statistical Methodology:**
- Random 50/50 assignment with balance validation
- Two-proportion z-test for conversion rates
- Chi-square test for independence
- Power analysis (achieved 80% power)
- Effect size calculation (Cohen's h)

**Results:**
- Control conversion: 12.3%
- Treatment conversion: 18.7%
- Absolute lift: 6.4 percentage points
- Relative lift: 52% improvement (statistically significant, p < 0.001)

**Financial Analysis:**
- Treatment incremental revenue: £47,200 for full rollout
- Additional cost: £5 per customer × 2,846 eligible customers = £14,230
- Incremental ROI: 3.3x
- **Recommendation:** Roll out Treatment to all eligible customers

**Business Impact:**
- Data-driven decision with statistical confidence
- Expected annual incremental profit: £33K from this campaign alone
- Framework reusable for future marketing tests

**Technical Skills:** Experimental design, hypothesis testing, statistical significance, power analysis, cost-benefit analysis

---

## 🎨 Interactive Dashboard

### [→ Launch Live Dashboard](https://victorgomes-23.shinyapps.io/ecommerce-customer-analytics/)

**5 Interactive Modules:**

#### 📊 Overview
- 8 real-time KPI cards (Revenue, Customers, Orders, AOV, etc.)
- Monthly revenue trend with interactive time series
- Top 10 products bar chart
- Customer segment distribution pie chart
- Revenue by country analysis

#### 👥 Customer Segments
- Detailed segment performance table
- RFM score distribution histograms
- Revenue contribution by segment
- Customer Lifetime Value comparison
- Drill-down capabilities by segment

#### ⚠️ Churn Analysis
- High-risk customer identification (838 customers)
- Revenue at risk quantification (£543K)
- Churn probability distribution
- Risk category breakdown
- Top 20 highest risk customers with action recommendations

#### 📦 Product Performance
- Top 20 products by revenue
- Product performance metrics table
- Interactive data filtering
- Units sold and pricing analysis

#### 📅 Cohort Analysis
- Interactive retention heatmap
- Cohort-by-cohort retention curves
- Hover for detailed percentages
- Export capabilities

**Dashboard Features:**
- **Global Filters:** Date range, customer segment, country
- **Refresh Button:** Update all visualizations
- **Responsive Design:** Works on desktop, tablet, mobile
- **Fast Performance:** <2 second load times
- **Professional UI:** Clean, intuitive interface

**Technical Achievement:**
- Built with Shiny and shinydashboard frameworks
- Plotly integration for interactive charts
- DT package for sortable, searchable tables
- Reactive programming for real-time updates
- Deployed on shinyapps.io for 24/7 availability

---

## 🛠️ Tech Stack

### Core Technologies
| Technology | Purpose | Proficiency Level |
|------------|---------|------------------|
| **R** | Primary analysis language | ⭐⭐⭐⭐⭐ Advanced |
| **RStudio** | Development environment | ⭐⭐⭐⭐⭐ Expert |
| **Shiny** | Interactive web applications | ⭐⭐⭐⭐⭐ Production-ready |
| **R Markdown** | Reproducible reporting | ⭐⭐⭐⭐⭐ Professional |

### Key Packages

**Data Manipulation:**
- `tidyverse` (dplyr, tidyr, purrr) - Data wrangling and transformation
- `lubridate` - Date/time manipulation and cohort analysis
- `janitor` - Data cleaning and validation

**Visualization:**
- `ggplot2` - Publication-quality static graphics
- `plotly` - Interactive visualizations with hover and zoom
- `shinydashboard` - Professional dashboard layouts
- `DT` - Interactive data tables

**Statistical Analysis:**
- `caret` - Machine learning workflows
- `pROC` - ROC curves and model evaluation
- `pwr` - Power analysis for A/B testing
- Base R - Statistical tests and modeling

**Deployment:**
- `rsconnect` - Deploy to shinyapps.io
- `here` - Reproducible file paths
- `renv` - Package version management

---

## 📂 Project Structure
```
ecommerce-customer-analytics/
│
├── README.md                          # You are here
│
├── data/
|   ├── README.md
│   ├── raw/                          # Original dataset (not tracked)
│   └── processed/                    # Cleaned, analysis-ready data
│       ├── retail_customers_only.csv     # Main transaction data
│       ├── customer_rfm_scored.csv       # RFM segmentation
│       ├── churn_predictions.csv         # Churn risk scores
│       └── cohort_data.csv               # Retention analysis
│
├── notebooks/                        # R Markdown analysis files
│   ├── 01_data_exploration.Rmd          # Initial data profiling
│   ├── 02_data_cleaning.Rmd             # Data cleaning pipeline
│   ├── 03_rfm_segmentation.Rmd          # Customer segmentation
│   ├── 04_cohort_analysis.Rmd           # Retention analysis
│   ├── 05_clv_prediction.Rmd            # Lifetime value modeling
│   ├── 06_product_affinity.Rmd          # Market basket analysis
│   ├── 07_churn_prediction.Rmd          # Churn modeling
│   └── 08_ab_testing.Rmd                # A/B test framework
│
├── visualizations/                   # Portfolio-quality graphics
│   ├── 01_revenue_trends.png            # Time series analysis
│   ├── 02_customer_segmentation.png     # RFM bubble chart
│   ├── 03_churn_risk_distribution.png   # Risk assessment
│   ├── 04_top_products.png              # Product rankings
│   ├── 05_geographic_revenue.png        # Geographic analysis
│   ├── 06_rfm_heatmap.png               # Value matrix
│   ├── 07_clv_distribution.png          # CLV by segment
│   ├── 08_interactive_customer_analysis.html  # Plotly viz
│   ├── 09_interactive_cohort_retention.html   # Plotly viz
│   ├── visualization_helpers.R          # Styling functions
│   ├── create_portfolio_visuals.R       # Static viz generator
│   └── create_interactive_viz.R         # Interactive viz generator
│
├── shiny_app/                        # Interactive dashboard
│   ├── app.R                            # Main Shiny application
│   ├── data/                            # Dashboard data files
│   └── www/                             # Static assets (CSS, images)
│
└── scripts/                          # Utility scripts
    └── data_preparation.R               # Data pipeline automation
```

---

## 💼 Skills Demonstrated

### Data Analysis
✅ **Data Cleaning & Preparation** - Handled missing values, outliers, duplicates  
✅ **Exploratory Data Analysis** - Statistical summaries, distributions, relationships  
✅ **Feature Engineering** - Created derived metrics, transformations, interactions  
✅ **Cohort Analysis** - Retention tracking, customer lifecycle analysis  

### Statistical Modeling
✅ **Predictive Modeling** - Logistic regression, model validation, hyperparameter tuning  
✅ **Hypothesis Testing** - A/B testing, significance testing, confidence intervals  
✅ **Power Analysis** - Sample size calculations, effect size determination  
✅ **Model Evaluation** - ROC curves, precision-recall, cross-validation  

### Machine Learning
✅ **Classification** - Churn prediction with 78% accuracy, 0.847 AUC  
✅ **Regression** - CLV prediction with R² = 0.89  
✅ **Association Rules** - Market basket analysis, recommendation systems  
✅ **Temporal Validation** - Proper train-test splits avoiding data leakage  

### Data Visualization
✅ **Static Graphics** - ggplot2 mastery, publication-quality outputs  
✅ **Interactive Visualizations** - Plotly integration, responsive design  
✅ **Dashboard Development** - Shiny applications, real-time updates  
✅ **Visual Design** - Consistent branding, color theory, accessibility  

### Business Intelligence
✅ **KPI Development** - Defined and tracked 15+ business metrics  
✅ **Segmentation Strategy** - Actionable customer groups, targeting recommendations  
✅ **ROI Analysis** - Quantified business impact of interventions  
✅ **Executive Communication** - Translated technical findings to business value  

### Software Engineering
✅ **Reproducible Research** - R Markdown, version control, documentation  
✅ **Code Quality** - Clean, commented, modular code  
✅ **Deployment** - Cloud hosting, production environment  
✅ **Project Management** - Organized structure, clear documentation  

---

## 📊 Key Metrics & Results

### Business Impact
- 💰 **£8.7M** total revenue analyzed
- 👥 **4,372** customers segmented
- 📈 **78% accuracy** in churn prediction
- 🎯 **£543K** revenue at risk identified
- 💵 **3.2x ROI** on retention campaigns
- 📊 **52% lift** in email conversion (A/B test)

### Technical Achievement
- 🔢 **541K+ transactions** processed
- 📅 **13 months** of data analyzed
- 🌍 **38 countries** covered
- 📈 **15+ KPIs** calculated
- 🎨 **9 portfolio visualizations** created
- 💻 **5-tab dashboard** deployed
- ⚙️ **18 predictive features** engineered

### Dataset Details
- **Source:** Online Retail Dataset (UCI Machine Learning Repository)
- **Period:** December 2010 - December 2011
- **Records:** 541,909 transactions
- **Customers:** 4,372 unique
- **Products:** 4,070 unique SKUs
- **Countries:** 38 countries
- **Size:** 45.6 MB raw data

---

## 🎓 Learning Outcomes

### Technical Growth
- Mastered end-to-end data analytics workflow in R
- Built production-ready Shiny applications
- Developed publication-quality data visualizations
- Implemented machine learning models with proper validation
- Created reproducible analysis pipelines

### Business Acumen
- Translated data insights into actionable recommendations
- Quantified financial impact of analytical findings
- Designed A/B tests with statistical rigor
- Developed customer segmentation strategies
- Calculated ROI for retention interventions

### Best Practices
- Version control with Git and GitHub
- Reproducible research with R Markdown
- Clean code principles and documentation
- Proper train-test splits and validation
- Accessibility in data visualization

---

## 🚀 Future Enhancements

### Phase 2: Advanced Analytics
- [ ] Time series forecasting (ARIMA, Prophet) for revenue prediction
- [ ] Customer segmentation with clustering (K-means, hierarchical)
- [ ] Product recommendation engine (collaborative filtering)
- [ ] Survival analysis for detailed churn modeling
- [ ] NLP analysis of product descriptions

### Phase 3: Technical Improvements
- [ ] Real-time dashboard with automated data refresh
- [ ] API integration for live data updates
- [ ] Advanced ML models (Random Forest, XGBoost, neural networks)
- [ ] Database integration (PostgreSQL)
- [ ] Docker containerization for deployment

### Phase 4: Dashboard Enhancements
- [ ] User authentication and personalized views
- [ ] Export functionality (PDF reports, Excel downloads)
- [ ] Email alerts for high-risk customers
- [ ] Mobile app version
- [ ] Advanced filtering and drill-down capabilities

---

## 📝 Documentation

### Analysis Notebooks
Each R Markdown notebook includes:
- Business context and objectives
- Detailed methodology
- Step-by-step code with comments
- Visualizations and interpretations
- Key findings and recommendations
- Session information for reproducibility

### Code Documentation
- Comprehensive inline comments
- Function documentation with examples
- Clear variable naming conventions
- Modular, reusable code structure
- Error handling and validation

---

## 🤝 About This Project

### Purpose
This project was developed as part of my data analytics portfolio to demonstrate:
- End-to-end analytical capabilities
- Business acumen and problem-solving
- Technical proficiency in R ecosystem
- Communication of insights to stakeholders
- Production-ready code and deployment

### Dataset Attribution
**Online Retail Dataset**
- Source: UCI Machine Learning Repository
- Citation: Chen, Daqing. (2015). Online Retail. UCI Machine Learning Repository. https://doi.org/10.24432/C5BW33
- License: Creative Commons Attribution 4.0 International (CC BY 4.0)

### Development Timeline
- **Week 1-2:** Data exploration, cleaning, and preparation
- **Week 3:** RFM segmentation and cohort analysis
- **Week 4:** CLV prediction and product affinity analysis
- **Week 5:** Churn prediction and A/B testing framework
- **Week 6:** Shiny dashboard development
- **Week 7:** Visualization portfolio creation
- **Week 8:** Documentation and deployment

**Total Development Time:** 80+ hours over 8 weeks

---

## 📧 Contact & Connect

**Victor Gomes**

I'm actively seeking **Data Analyst / Business Analyst** positions where I can apply analytical skills to drive business impact through data-driven insights.

### 🔗 Quick Links
- 🚀 **[Live Dashboard](https://victorgomes-23.shinyapps.io/ecommerce-customer-analytics/)** - Explore the interactive app
- 💼 **[LinkedIn](https://www.linkedin.com/in/victor-gomes-your-profile)** - Let's connect professionally
- 📧 **[Email](mailto:your.email@example.com)** - Reach out directly
- 🌐 **[Portfolio](https://your-portfolio.com)** - View other projects
- 📂 **[GitHub](https://github.com/VictorGomes-23)** - Explore my code

### 💬 Let's Talk About
- Data analytics and business intelligence
- R programming and Shiny development
- Customer analytics and retention strategies
- Predictive modeling and machine learning
- Data visualization best practices
- Opportunities to collaborate or contribute

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **UCI Machine Learning Repository** for providing the Online Retail dataset
- **RStudio & Posit** for amazing open-source tools
- **R Community** for excellent packages and documentation
- **shinyapps.io** for free dashboard hosting

---

<div align="center">

### ⭐ Found this project interesting? Give it a star!

**[🚀 Launch Live Dashboard](https://victorgomes-23.shinyapps.io/ecommerce-customer-analytics/)** | **[📊 Explore Code](https://github.com/VictorGomes-23/ecommerce-customer-analytics)**

---

*Built with* ❤️ *and* ☕ *by Victor Gomes | January 2026*

**Open to opportunities in Data Analytics, Business Intelligence, and Data Science**

</div>