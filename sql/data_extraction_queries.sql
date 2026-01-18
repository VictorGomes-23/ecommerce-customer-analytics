/*
=============================================================================
E-COMMERCE CUSTOMER ANALYTICS - SQL EXTRACTION QUERIES
=============================================================================

Purpose: Document SQL queries for extracting and analyzing e-commerce data
Database: PostgreSQL (adaptable to MySQL, SQL Server, Oracle)
Schema: ecommerce_retail (Normalized design)
Author: Victor Gomes
Date: January 2025

This file demonstrates:
1. Normalized database schema design for e-commerce analytics
2. Data extraction queries from production database
3. Data quality validation and integrity checks
4. Pre-aggregation queries for analytical efficiency
5. Advanced SQL techniques (CTEs, window functions, self-joins)
6. Performance optimization strategies

NOTE: These queries assume PostgreSQL syntax. Minor adjustments needed for:
- MySQL: Use LIMIT instead of FETCH, DATE_FORMAT instead of TO_CHAR
- SQL Server: Use TOP instead of LIMIT, CONVERT for dates
- Oracle: Use ROWNUM, different date functions

=============================================================================
TABLE OF CONTENTS
=============================================================================

SECTION 1: Normalized Schema Definition
SECTION 2: Basic Data Extraction Queries
SECTION 3: Data Quality Validation Queries
SECTION 4: Customer-Level Aggregations
SECTION 5: Product Performance Queries
SECTION 6: Time-Series Analysis Queries
SECTION 7: Advanced Analytics Queries
SECTION 8: Performance Optimization
SECTION 9: Data Export Queries

=============================================================================
*/


/*
=============================================================================
SECTION 1: NORMALIZED SCHEMA DEFINITION
=============================================================================

Design Philosophy:
- Normalized structure (3NF) to reduce redundancy and improve data integrity
- Separate dimension tables (customers, products, countries) from fact table
- Foreign key relationships ensure referential integrity
- Indexes on frequently queried columns for performance
- Appropriate data types and constraints for data quality

Business Benefits:
- Easier updates (change country name in one place)
- Better data consistency
- Efficient storage
- Supports multiple fact tables (could add orders, shipments, etc.)

=============================================================================
*/

-- ----------------------------------------------------------------
-- DIMENSION TABLE: countries
-- Purpose: Lookup table for country information
-- ----------------------------------------------------------------

CREATE TABLE countries (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE,
    country_code CHAR(2),  -- ISO 3166-1 alpha-2 code
    region VARCHAR(50),     -- Geographic region (e.g., Europe, Asia)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for frequent lookups
CREATE INDEX idx_countries_name ON countries(country_name);

COMMENT ON TABLE countries IS 'Dimension table storing country information';


-- ----------------------------------------------------------------
-- DIMENSION TABLE: customers
-- Purpose: Store customer master data
-- ----------------------------------------------------------------

CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    country_id INTEGER REFERENCES countries(country_id),
    first_purchase_date DATE,           -- Denormalized for performance
    last_purchase_date DATE,             -- Denormalized for performance
    total_purchases INTEGER DEFAULT 0,   -- Denormalized for performance
    is_active BOOLEAN DEFAULT TRUE,
    customer_type VARCHAR(20),           -- B2B, B2C, Wholesale
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for analytical queries
CREATE INDEX idx_customers_country ON customers(country_id);
CREATE INDEX idx_customers_first_purchase ON customers(first_purchase_date);
CREATE INDEX idx_customers_last_purchase ON customers(last_purchase_date);

COMMENT ON TABLE customers IS 'Dimension table storing customer information';


-- ----------------------------------------------------------------
-- DIMENSION TABLE: products
-- Purpose: Product catalog and master data
-- ----------------------------------------------------------------

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    stock_code VARCHAR(20) NOT NULL UNIQUE,
    description VARCHAR(255),
    category VARCHAR(100),               -- Product category
    unit_price DECIMAL(10,2),           -- Current price
    is_active BOOLEAN DEFAULT TRUE,
    is_admin_item BOOLEAN DEFAULT FALSE, -- POST, D, M, etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for frequent queries
CREATE INDEX idx_products_stock_code ON products(stock_code);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_active ON products(is_active);

COMMENT ON TABLE products IS 'Dimension table storing product catalog';


-- ----------------------------------------------------------------
-- FACT TABLE: transactions
-- Purpose: Core transactional data (grain: one row per line item)
-- ----------------------------------------------------------------

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    invoice_no VARCHAR(20) NOT NULL,
    customer_id VARCHAR(20) REFERENCES customers(customer_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    invoice_date TIMESTAMP NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    is_return BOOLEAN GENERATED ALWAYS AS (quantity < 0) STORED,
    is_cancellation BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Performance indexes for analytical queries
CREATE INDEX idx_transactions_invoice ON transactions(invoice_no);
CREATE INDEX idx_transactions_customer ON transactions(customer_id);
CREATE INDEX idx_transactions_product ON transactions(product_id);
CREATE INDEX idx_transactions_date ON transactions(invoice_date);
CREATE INDEX idx_transactions_composite_customer_date ON transactions(customer_id, invoice_date);

-- Constraints
ALTER TABLE transactions ADD CONSTRAINT chk_quantity_not_zero CHECK (quantity != 0);
ALTER TABLE transactions ADD CONSTRAINT chk_unit_price_positive CHECK (unit_price >= 0);

COMMENT ON TABLE transactions IS 'Fact table storing all transaction line items';


-- ----------------------------------------------------------------
-- Table Partitioning Strategy (for large-scale production)
-- Purpose: Improve query performance on time-series data
-- Note: Implemented if table grows beyond millions of rows
-- ----------------------------------------------------------------

/*
-- Partition transactions by month for better performance
CREATE TABLE transactions_partitioned (
    LIKE transactions INCLUDING ALL
) PARTITION BY RANGE (invoice_date);

-- Create partitions for each month
CREATE TABLE transactions_2010_12 PARTITION OF transactions_partitioned
    FOR VALUES FROM ('2010-12-01') TO ('2011-01-01');

CREATE TABLE transactions_2011_01 PARTITION OF transactions_partitioned
    FOR VALUES FROM ('2011-01-01') TO ('2011-02-01');

-- Continue for all months...
*/


/*
=============================================================================
SECTION 2: BASIC DATA EXTRACTION QUERIES
=============================================================================

Purpose: Fundamental queries to extract transaction data for analysis
Use Case: Daily/weekly data pulls for R analysis
Frequency: As needed for analytics refresh

=============================================================================
*/

-- ----------------------------------------------------------------
-- QUERY 2.1: Complete Transaction Dataset (Denormalized)
-- Purpose: Extract all transaction data with dimension details
-- Use Case: Initial data pull for comprehensive analysis in R
-- ----------------------------------------------------------------

SELECT 
    t.invoice_no AS "InvoiceNo",
    p.stock_code AS "StockCode",
    p.description AS "Description",
    t.quantity AS "Quantity",
    t.invoice_date AS "InvoiceDate",
    t.unit_price AS "UnitPrice",
    t.customer_id AS "CustomerID",
    co.country_name AS "Country"
FROM transactions t
INNER JOIN products p ON t.product_id = p.product_id
LEFT JOIN customers c ON t.customer_id = c.customer_id
LEFT JOIN countries co ON c.country_id = co.country_id
WHERE t.invoice_date BETWEEN '2010-12-01' AND '2011-12-09'
ORDER BY t.invoice_date, t.invoice_no;

-- Expected output: ~540,000 rows matching CSV structure


-- ----------------------------------------------------------------
-- QUERY 2.2: Customer Transactions Only
-- Purpose: Extract only transactions with valid customer IDs
-- Use Case: Customer behavior analysis (RFM, cohort, CLV)
-- ----------------------------------------------------------------

SELECT 
    t.invoice_no,
    t.customer_id,
    p.stock_code,
    p.description,
    t.quantity,
    t.invoice_date,
    t.unit_price,
    t.total_amount,
    co.country_name
FROM transactions t
INNER JOIN products p ON t.product_id = p.product_id
INNER JOIN customers c ON t.customer_id = c.customer_id  -- INNER JOIN excludes NULLs
INNER JOIN countries co ON c.country_id = co.country_id
WHERE t.invoice_date BETWEEN '2010-12-01' AND '2011-12-09'
ORDER BY t.customer_id, t.invoice_date;

-- Expected output: ~75% of total transactions


-- ----------------------------------------------------------------
-- QUERY 2.3: Valid Sales Only (Exclude Returns and Admin Items)
-- Purpose: Extract clean sales data for revenue analysis
-- Use Case: Revenue reporting, product performance
-- ----------------------------------------------------------------

SELECT 
    t.invoice_no,
    t.customer_id,
    p.stock_code,
    p.description,
    p.category,
    t.quantity,
    t.invoice_date,
    t.unit_price,
    t.total_amount
FROM transactions t
INNER JOIN products p ON t.product_id = p.product_id
WHERE t.invoice_date BETWEEN '2010-12-01' AND '2011-12-09'
    AND t.quantity > 0                -- Exclude returns
    AND NOT t.is_cancellation         -- Exclude cancellations
    AND NOT p.is_admin_item           -- Exclude POST, D, M, etc.
ORDER BY t.invoice_date;


-- ----------------------------------------------------------------
-- QUERY 2.4: Date Range Filtered Extract
-- Purpose: Extract data for specific time period
-- Use Case: Monthly/quarterly analysis
-- Parameters: Adjust dates as needed
-- ----------------------------------------------------------------

SELECT 
    t.invoice_no,
    t.customer_id,
    p.stock_code,
    t.quantity,
    t.invoice_date,
    t.total_amount
FROM transactions t
INNER JOIN products p ON t.product_id = p.product_id
WHERE t.invoice_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '3 months')
    AND t.invoice_date < DATE_TRUNC('month', CURRENT_DATE)
ORDER BY t.invoice_date;

-- Use case: Rolling 3-month window for trending analysis


/*
=============================================================================
SECTION 3: DATA QUALITY VALIDATION QUERIES
=============================================================================

Purpose: Identify data quality issues and integrity violations
Use Case: Pre-analysis data validation, monitoring data pipelines
Frequency: Run before each major analysis or as automated checks

=============================================================================
*/

-- ----------------------------------------------------------------
-- QUERY 3.1: Missing Customer IDs
-- Purpose: Count transactions without customer association
-- Business Impact: Cannot perform customer-level analysis on these
-- ----------------------------------------------------------------

SELECT 
    COUNT(*) AS missing_customer_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM transactions), 2) AS missing_pct
FROM transactions
WHERE customer_id IS NULL;

-- Expected result: ~25% missing (guest checkouts)


-- ----------------------------------------------------------------
-- QUERY 3.2: Missing or Invalid Product Descriptions
-- Purpose: Identify products needing catalog cleanup
-- ----------------------------------------------------------------

SELECT 
    p.stock_code,
    p.description,
    p.is_admin_item,
    COUNT(t.transaction_id) AS transaction_count
FROM products p
LEFT JOIN transactions t ON p.product_id = t.product_id
WHERE p.description IS NULL 
   OR p.description = ''
   OR LENGTH(TRIM(p.description)) < 3
GROUP BY p.stock_code, p.description, p.is_admin_item
ORDER BY transaction_count DESC;


-- ----------------------------------------------------------------
-- QUERY 3.3: Duplicate Transaction Detection
-- Purpose: Find potential duplicate records
-- Action: Investigate and deduplicate if confirmed errors
-- ----------------------------------------------------------------

SELECT 
    invoice_no,
    customer_id,
    product_id,
    invoice_date,
    quantity,
    unit_price,
    COUNT(*) AS duplicate_count
FROM transactions
GROUP BY invoice_no, customer_id, product_id, invoice_date, quantity, unit_price
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- ----------------------------------------------------------------
-- QUERY 3.4: Invalid Price Detection
-- Purpose: Find transactions with problematic pricing
-- ----------------------------------------------------------------

SELECT 
    t.transaction_id,
    t.invoice_no,
    p.stock_code,
    p.description,
    t.unit_price,
    p.is_admin_item
FROM transactions t
INNER JOIN products p ON t.product_id = p.product_id
WHERE t.unit_price <= 0 
    AND NOT p.is_admin_item  -- Admin items may have zero price
ORDER BY t.unit_price;


-- ----------------------------------------------------------------
-- QUERY 3.5: Date Range Anomalies
-- Purpose: Ensure all dates fall within expected range
-- ----------------------------------------------------------------

SELECT 
    MIN(invoice_date) AS earliest_transaction,
    MAX(invoice_date) AS latest_transaction,
    COUNT(CASE WHEN invoice_date < '2010-12-01' THEN 1 END) AS before_range,
    COUNT(CASE WHEN invoice_date > '2011-12-09' THEN 1 END) AS after_range
FROM transactions;


-- ----------------------------------------------------------------
-- QUERY 3.6: Referential Integrity Check
-- Purpose: Find orphaned records (foreign key violations)
-- Note: Should return 0 rows if constraints are enforced
-- ----------------------------------------------------------------

-- Transactions without valid customer (should be NULL, not invalid ID)
SELECT COUNT(*)
FROM transactions t
LEFT JOIN customers c ON t.customer_id = c.customer_id
WHERE t.customer_id IS NOT NULL 
    AND c.customer_id IS NULL;

-- Transactions without valid product (should never happen)
SELECT COUNT(*)
FROM transactions t
LEFT JOIN products p ON t.product_id = p.product_id
WHERE p.product_id IS NULL;


-- ----------------------------------------------------------------
-- QUERY 3.7: Return Rate Validation
-- Purpose: Calculate and validate return patterns
-- ----------------------------------------------------------------

SELECT 
    COUNT(CASE WHEN quantity < 0 THEN 1 END) AS return_line_items,
    COUNT(CASE WHEN quantity > 0 THEN 1 END) AS sale_line_items,
    ROUND(100.0 * COUNT(CASE WHEN quantity < 0 THEN 1 END) / 
          COUNT(CASE WHEN quantity > 0 THEN 1 END), 2) AS return_rate_pct,
    SUM(CASE WHEN quantity < 0 THEN total_amount ELSE 0 END) AS return_value,
    SUM(CASE WHEN quantity > 0 THEN total_amount ELSE 0 END) AS sales_value
FROM transactions;


/*
=============================================================================
SECTION 4: CUSTOMER-LEVEL AGGREGATIONS
=============================================================================

Purpose: Pre-calculate customer metrics for RFM analysis, CLV, and segmentation
Use Case: Foundation for customer analytics in R
Frequency: Daily/weekly refresh

These queries form the basis of customer_summary.csv

=============================================================================
*/

-- ----------------------------------------------------------------
-- QUERY 4.1: Comprehensive Customer Summary (RFM Foundation)
-- Purpose: Calculate all key customer metrics in one query
-- Use Case: Direct input for RFM segmentation and CLV modeling
-- ----------------------------------------------------------------

SELECT 
    c.customer_id,
    
    -- Temporal metrics
    c.first_purchase_date,
    c.last_purchase_date,
    CURRENT_DATE - c.last_purchase_date AS days_since_last_purchase,  -- Recency
    c.last_purchase_date - c.first_purchase_date AS customer_lifetime_days,
    
    -- Transaction counts (Frequency)
    COUNT(DISTINCT CASE WHEN t.quantity > 0 THEN t.invoice_no END) AS total_purchases,
    COUNT(DISTINCT CASE WHEN t.quantity < 0 THEN t.invoice_no END) AS total_returns,
    
    -- Item quantities
    SUM(CASE WHEN t.quantity > 0 THEN t.quantity ELSE 0 END) AS total_items_purchased,
    SUM(CASE WHEN t.quantity < 0 THEN ABS(t.quantity) ELSE 0 END) AS total_items_returned,
    
    -- Monetary metrics (Monetary)
    SUM(CASE WHEN t.quantity > 0 THEN t.total_amount ELSE 0 END) AS total_spent,
    SUM(CASE WHEN t.quantity < 0 THEN ABS(t.total_amount) ELSE 0 END) AS total_return_value,
    SUM(t.total_amount) AS net_revenue,  -- Includes returns (negative)
    
    -- Calculated metrics
    ROUND(
        SUM(CASE WHEN t.quantity > 0 THEN t.total_amount ELSE 0 END)::NUMERIC / 
        NULLIF(COUNT(DISTINCT CASE WHEN t.quantity > 0 THEN t.invoice_no END), 0), 
        2
    ) AS average_order_value,
    
    -- Return behavior
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN t.quantity < 0 THEN t.invoice_no END)::NUMERIC / 
        NULLIF(COUNT(DISTINCT CASE WHEN t.quantity > 0 THEN t.invoice_no END), 0),
        2
    ) AS return_rate_pct,
    
    -- Geographic
    co.country_name AS primary_country
    
FROM customers c
INNER JOIN transactions t ON c.customer_id = t.customer_id
LEFT JOIN countries co ON c.country_id = co.country_id
GROUP BY c.customer_id, c.first_purchase_date, c.last_purchase_date, co.country_name
ORDER BY total_spent DESC;

-- Output: One row per customer with complete metrics


-- ----------------------------------------------------------------
-- QUERY 4.2: Customer Segmentation Prep (RFM Scores)
-- Purpose: Calculate RFM scores (1-5 scale) for segmentation
-- Use Case: Direct customer segmentation without R processing
-- ----------------------------------------------------------------

WITH customer_metrics AS (
    SELECT 
        customer_id,
        CURRENT_DATE - MAX(invoice_date) AS recency_days,
        COUNT(DISTINCT invoice_no) AS frequency,
        SUM(total_amount) AS monetary
    FROM transactions
    WHERE quantity > 0  -- Exclude returns
    GROUP BY customer_id
),
rfm_scores AS (
    SELECT 
        customer_id,
        recency_days,
        frequency,
        monetary,
        -- R score: Lower recency is better (5 = most recent)
        NTILE(5) OVER (ORDER BY recency_days) AS r_score,
        -- F score: Higher frequency is better
        NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,
        -- M score: Higher monetary is better
        NTILE(5) OVER (ORDER BY monetary DESC) AS m_score
    FROM customer_metrics
)
SELECT 
    customer_id,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    -- Combined RFM score (concatenated)
    CONCAT(r_score, f_score, m_score) AS rfm_segment,
    -- Total score (simple sum)
    r_score + f_score + m_score AS rfm_total_score
FROM rfm_scores
ORDER BY rfm_total_score DESC;


-- ----------------------------------------------------------------
-- QUERY 4.3: Customer Cohort Assignment
-- Purpose: Assign customers to cohorts by first purchase month
-- Use Case: Cohort analysis foundation
-- ----------------------------------------------------------------

SELECT 
    customer_id,
    first_purchase_date,
    DATE_TRUNC('month', first_purchase_date) AS cohort_month,
    TO_CHAR(first_purchase_date, 'YYYY-MM') AS cohort_label
FROM customers
WHERE first_purchase_date IS NOT NULL
ORDER BY cohort_month, customer_id;


-- ----------------------------------------------------------------
-- QUERY 4.4: Customer Activity Status
-- Purpose: Classify customers by activity status
-- Use Case: Churn identification and re-engagement targeting
-- ----------------------------------------------------------------

SELECT 
    customer_id,
    last_purchase_date,
    CURRENT_DATE - last_purchase_date AS days_inactive,
    CASE 
        WHEN CURRENT_DATE - last_purchase_date <= 30 THEN 'Active'
        WHEN CURRENT_DATE - last_purchase_date <= 90 THEN 'At Risk'
        WHEN CURRENT_DATE - last_purchase_date <= 180 THEN 'Lapsing'
        ELSE 'Churned'
    END AS activity_status
FROM customers
ORDER BY days_inactive;


/*
=============================================================================
SECTION 5: PRODUCT PERFORMANCE QUERIES
=============================================================================

Purpose: Analyze product sales, popularity, and profitability
Use Case: Product recommendations, inventory optimization, pricing strategy

=============================================================================
*/

-- ----------------------------------------------------------------
-- QUERY 5.1: Top Selling Products by Revenue
-- Purpose: Identify highest revenue-generating products
-- Use Case: Inventory prioritization, marketing focus
-- ----------------------------------------------------------------

SELECT 
    p.stock_code,
    p.description,
    p.category,
    COUNT(DISTINCT t.invoice_no) AS times_purchased,
    SUM(t.quantity) AS total_units_sold,
    SUM(t.total_amount) AS total_revenue,
    ROUND(AVG(t.unit_price), 2) AS avg_unit_price,
    COUNT(DISTINCT t.customer_id) AS unique_customers,
    ROUND(SUM(t.total_amount)::NUMERIC / SUM(t.quantity), 2) AS avg_revenue_per_unit
FROM transactions t
INNER JOIN products p ON t.product_id = p.product_id
WHERE t.quantity > 0  -- Sales only
    AND NOT p.is_admin_item
GROUP BY p.stock_code, p.description, p.category
HAVING SUM(t.quantity) > 10  -- Minimum volume threshold
ORDER BY total_revenue DESC
LIMIT 50;


-- ----------------------------------------------------------------
-- QUERY 5.2: Product Performance by Category
-- Purpose: Compare performance across product categories
-- Use Case: Category management, assortment planning
-- ----------------------------------------------------------------

SELECT 
    p.category,
    COUNT(DISTINCT p.product_id) AS products_in_category,
    SUM(t.quantity) AS total_units_sold,
    SUM(t.total_amount) AS total_revenue,
    ROUND(AVG(t.total_amount), 2) AS avg_transaction_value,
    COUNT(DISTINCT t.customer_id) AS unique_customers
FROM transactions t
INNER JOIN products p ON t.product_id = p.product_id
WHERE t.quantity > 0
    AND p.category IS NOT NULL
GROUP BY p.category
ORDER BY total_revenue DESC;


-- ----------------------------------------------------------------
-- QUERY 5.3: Product Return Analysis
-- Purpose: Identify products with high return rates
-- Use Case: Quality issues, product fit problems
-- ----------------------------------------------------------------

SELECT 
    p.stock_code,
    p.description,
    COUNT(CASE WHEN t.quantity > 0 THEN 1 END) AS units_sold,
    COUNT(CASE WHEN t.quantity < 0 THEN 1 END) AS units_returned,
    ROUND(
        100.0 * COUNT(CASE WHEN t.quantity < 0 THEN 1 END)::NUMERIC / 
        NULLIF(COUNT(CASE WHEN t.quantity > 0 THEN 1 END), 0),
        2
    ) AS return_rate_pct,
    SUM(CASE WHEN t.quantity < 0 THEN ABS(t.total_amount) ELSE 0 END) AS return_value
FROM transactions t
INNER JOIN products p ON t.product_id = p.product_id
GROUP BY p.stock_code, p.description
HAVING COUNT(CASE WHEN t.quantity > 0 THEN 1 END) >= 50  -- Minimum volume
ORDER BY return_rate_pct DESC
LIMIT 30;


/*
=============================================================================
SECTION 6: TIME-SERIES ANALYSIS QUERIES
=============================================================================

Purpose: Analyze trends, seasonality, and temporal patterns
Use Case: Forecasting, capacity planning, marketing timing

=============================================================================
*/

-- ----------------------------------------------------------------
-- QUERY 6.1: Daily Revenue Trends
-- Purpose: Track daily sales performance
-- Use Case: Identify sales patterns, anomalies
-- ----------------------------------------------------------------

SELECT 
    DATE(invoice_date) AS transaction_date,
    COUNT(DISTINCT invoice_no) AS transactions,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(CASE WHEN quantity > 0 THEN quantity ELSE 0 END) AS units_sold,
    SUM(CASE WHEN quantity > 0 THEN total_amount ELSE 0 END) AS daily_revenue,
    ROUND(AVG(CASE WHEN quantity > 0 THEN total_amount END), 2) AS avg_transaction_value
FROM transactions
GROUP BY DATE(invoice_date)
ORDER BY transaction_date;


-- ----------------------------------------------------------------
-- QUERY 6.2: Monthly Revenue with Year-over-Year Comparison
-- Purpose: Track monthly performance and growth
-- Use Case: Executive reporting, trend analysis
-- ----------------------------------------------------------------

SELECT 
    TO_CHAR(invoice_date, 'YYYY-MM') AS year_month,
    EXTRACT(YEAR FROM invoice_date) AS year,
    EXTRACT(MONTH FROM invoice_date) AS month,
    COUNT(DISTINCT invoice_no) AS transactions,
    SUM(CASE WHEN quantity > 0 THEN total_amount ELSE 0 END) AS monthly_revenue,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(
        SUM(CASE WHEN quantity > 0 THEN total_amount ELSE 0 END)::NUMERIC / 
        COUNT(DISTINCT invoice_no),
        2
    ) AS avg_order_value
FROM transactions
GROUP BY TO_CHAR(invoice_date, 'YYYY-MM'), 
         EXTRACT(YEAR FROM invoice_date), 
         EXTRACT(MONTH FROM invoice_date)
ORDER BY year_month;


-- ----------------------------------------------------------------
-- QUERY 6.3: Day of Week and Hour of Day Patterns
-- Purpose: Identify peak shopping times
-- Use Case: Staffing optimization, promotional timing
-- ----------------------------------------------------------------

SELECT 
    TO_CHAR(invoice_date, 'Day') AS day_of_week,
    EXTRACT(HOUR FROM invoice_date) AS hour_of_day,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN quantity > 0 THEN total_amount ELSE 0 END) AS revenue
FROM transactions
WHERE quantity > 0
GROUP BY TO_CHAR(invoice_date, 'Day'), EXTRACT(HOUR FROM invoice_date)
ORDER BY day_of_week, hour_of_day;


-- ----------------------------------------------------------------
-- QUERY 6.4: Seasonality Analysis by Quarter
-- Purpose: Identify seasonal patterns
-- Use Case: Inventory planning, marketing calendar
-- ----------------------------------------------------------------

SELECT 
    EXTRACT(YEAR FROM invoice_date) AS year,
    EXTRACT(QUARTER FROM invoice_date) AS quarter,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(CASE WHEN quantity > 0 THEN total_amount ELSE 0 END) AS revenue,
    ROUND(AVG(CASE WHEN quantity > 0 THEN total_amount END), 2) AS avg_transaction_value
FROM transactions
GROUP BY EXTRACT(YEAR FROM invoice_date), EXTRACT(QUARTER FROM invoice_date)
ORDER BY year, quarter;


/*
=============================================================================
SECTION 7: ADVANCED ANALYTICS QUERIES
=============================================================================

Purpose: Complex analytical queries using CTEs, window functions, self-joins
Use Case: Advanced segmentation, predictive analytics preparation

=============================================================================
*/

-- ----------------------------------------------------------------
-- QUERY 7.1: Cohort Retention Analysis
-- Purpose: Calculate month-over-month customer retention by cohort
-- Use Case: Retention metrics, churn analysis
-- ----------------------------------------------------------------

WITH customer_cohorts AS (
    -- Assign each customer to their first purchase month cohort
    SELECT 
        customer_id,
        DATE_TRUNC('month', first_purchase_date) AS cohort_month
    FROM customers
    WHERE first_purchase_date IS NOT NULL
),
customer_activity AS (
    -- Get all customer purchase months
    SELECT DISTINCT
        t.customer_id,
        DATE_TRUNC('month', t.invoice_date) AS activity_month
    FROM transactions t
    WHERE t.quantity > 0
),
cohort_activity AS (
    -- Join cohorts with their activity months
    SELECT 
        cc.cohort_month,
        ca.activity_month,
        COUNT(DISTINCT cc.customer_id) AS active_customers,
        EXTRACT(MONTH FROM AGE(ca.activity_month, cc.cohort_month)) AS months_since_cohort
    FROM customer_cohorts cc
    INNER JOIN customer_activity ca ON cc.customer_id = ca.customer_id
    GROUP BY cc.cohort_month, ca.activity_month
)
SELECT 
    TO_CHAR(cohort_month, 'YYYY-MM') AS cohort,
    months_since_cohort AS month_number,
    active_customers,
    -- Calculate retention rate relative to cohort size
    ROUND(
        100.0 * active_customers::NUMERIC / 
        FIRST_VALUE(active_customers) OVER (
            PARTITION BY cohort_month 
            ORDER BY months_since_cohort
        ),
        2
    ) AS retention_rate_pct
FROM cohort_activity
ORDER BY cohort_month, months_since_cohort;


-- ----------------------------------------------------------------
-- QUERY 7.2: Customer Purchase Sequence with Running Totals
-- Purpose: Track individual customer journey with cumulative metrics
-- Use Case: CLV calculation, customer journey analysis
-- ----------------------------------------------------------------

SELECT 
    customer_id,
    invoice_no,
    invoice_date,
    total_amount AS order_value,
    -- Sequential numbering of purchases per customer
    ROW_NUMBER() OVER (
        PARTITION BY customer_id 
        ORDER BY invoice_date
    ) AS purchase_number,
    -- Running total of customer spend
    SUM(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY invoice_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_spend,
    -- Days since previous purchase
    COALESCE(
        EXTRACT(DAY FROM invoice_date - LAG(invoice_date) OVER (
            PARTITION BY customer_id 
            ORDER BY invoice_date
        )),
        0
    ) AS days_since_last_purchase,
    -- Moving average of last 3 purchases
    ROUND(
        AVG(total_amount) OVER (
            PARTITION BY customer_id 
            ORDER BY invoice_date
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moving_avg_order_value
FROM transactions
WHERE quantity > 0  -- Sales only
    AND customer_id IS NOT NULL
ORDER BY customer_id, invoice_date;


-- ----------------------------------------------------------------
-- QUERY 7.3: Market Basket Analysis (Product Affinity)
-- Purpose: Find products frequently purchased together
-- Use Case: Product recommendations, bundle pricing
-- ----------------------------------------------------------------

WITH product_pairs AS (
    -- Self-join to find products in same transaction
    SELECT 
        t1.invoice_no,
        p1.stock_code AS product_a,
        p1.description AS description_a,
        p2.stock_code AS product_b,
        p2.description AS description_b
    FROM transactions t1
    INNER JOIN transactions t2 ON t1.invoice_no = t2.invoice_no
    INNER JOIN products p1 ON t1.product_id = p1.product_id
    INNER JOIN products p2 ON t2.product_id = p2.product_id
    WHERE t1.product_id < t2.product_id  -- Avoid duplicates and self-pairs
        AND t1.quantity > 0 
        AND t2.quantity > 0
        AND NOT p1.is_admin_item
        AND NOT p2.is_admin_item
)
SELECT 
    product_a,
    description_a,
    product_b,
    description_b,
    COUNT(DISTINCT invoice_no) AS times_bought_together,
    -- Support: percentage of all transactions containing this pair
    ROUND(
        100.0 * COUNT(DISTINCT invoice_no)::NUMERIC / 
        (SELECT COUNT(DISTINCT invoice_no) FROM transactions),
        4
    ) AS support_pct
FROM product_pairs
GROUP BY product_a, description_a, product_b, description_b
HAVING COUNT(DISTINCT invoice_no) >= 20  -- Minimum support threshold
ORDER BY times_bought_together DESC
LIMIT 100;


-- ----------------------------------------------------------------
-- QUERY 7.4: Customer Segmentation using Percentiles
-- Purpose: Identify high-value customers (top 20% by spend)
-- Use Case: VIP program targeting, retention focus
-- ----------------------------------------------------------------

WITH customer_spend AS (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent,
        COUNT(DISTINCT invoice_no) AS purchase_count
    FROM transactions
    WHERE quantity > 0
        AND customer_id IS NOT NULL
    GROUP BY customer_id
),
spend_percentiles AS (
    SELECT 
        customer_id,
        total_spent,
        purchase_count,
        NTILE(5) OVER (ORDER BY total_spent DESC) AS spend_quintile,
        PERCENT_RANK() OVER (ORDER BY total_spent DESC) AS spend_percentile
    FROM customer_spend
)
SELECT 
    customer_id,
    total_spent,
    purchase_count,
    spend_quintile,
    ROUND(spend_percentile * 100, 2) AS percentile_rank,
    CASE 
        WHEN spend_quintile = 1 THEN 'VIP (Top 20%)'
        WHEN spend_quintile = 2 THEN 'High Value'
        WHEN spend_quintile = 3 THEN 'Medium Value'
        WHEN spend_quintile = 4 THEN 'Low Value'
        ELSE 'Minimal Spend'
    END AS customer_segment
FROM spend_percentiles
ORDER BY total_spent DESC;


-- ----------------------------------------------------------------
-- QUERY 7.5: Next Purchase Prediction Prep
-- Purpose: Calculate features for predictive modeling
-- Use Case: Churn prediction, next purchase timing
-- ----------------------------------------------------------------

WITH customer_purchase_history AS (
    SELECT 
        customer_id,
        invoice_date,
        total_amount,
        LAG(invoice_date) OVER (PARTITION BY customer_id ORDER BY invoice_date) AS prev_purchase_date,
        LEAD(invoice_date) OVER (PARTITION BY customer_id ORDER BY invoice_date) AS next_purchase_date
    FROM transactions
    WHERE quantity > 0 AND customer_id IS NOT NULL
)
SELECT 
    customer_id,
    invoice_date,
    total_amount,
    -- Days between purchases (purchase interval)
    EXTRACT(DAY FROM invoice_date - prev_purchase_date) AS days_since_prev_purchase,
    EXTRACT(DAY FROM next_purchase_date - invoice_date) AS days_until_next_purchase,
    -- Average inter-purchase interval per customer
    AVG(EXTRACT(DAY FROM invoice_date - prev_purchase_date)) OVER (
        PARTITION BY customer_id
    ) AS avg_purchase_interval_days
FROM customer_purchase_history
WHERE prev_purchase_date IS NOT NULL  -- Exclude first purchase
ORDER BY customer_id, invoice_date;


/*
=============================================================================
SECTION 8: PERFORMANCE OPTIMIZATION
=============================================================================

Purpose: Improve query performance for production environments
Use Case: Large-scale analytics, real-time dashboards

=============================================================================
*/

-- ----------------------------------------------------------------
-- Index Recommendations
-- Purpose: Speed up frequently used queries
-- ----------------------------------------------------------------

-- Already created in schema definition, but documented here for reference:

-- Customer dimension indexes
CREATE INDEX IF NOT EXISTS idx_customers_country ON customers(country_id);
CREATE INDEX IF NOT EXISTS idx_customers_first_purchase ON customers(first_purchase_date);
CREATE INDEX IF NOT EXISTS idx_customers_last_purchase ON customers(last_purchase_date);

-- Product dimension indexes
CREATE INDEX IF NOT EXISTS idx_products_stock_code ON products(stock_code);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);

-- Transaction fact table indexes (most critical for performance)
CREATE INDEX IF NOT EXISTS idx_transactions_customer ON transactions(customer_id);
CREATE INDEX IF NOT EXISTS idx_transactions_product ON transactions(product_id);
CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions(invoice_date);
CREATE INDEX IF NOT EXISTS idx_transactions_composite ON transactions(customer_id, invoice_date);

-- Covering index for common analytical queries
CREATE INDEX IF NOT EXISTS idx_transactions_analytics ON transactions(
    customer_id, 
    invoice_date, 
    quantity, 
    total_amount
) WHERE quantity > 0;  -- Partial index for sales only


-- ----------------------------------------------------------------
-- Query Optimization Examples
-- ----------------------------------------------------------------

-- INEFFICIENT: Using SELECT * when only specific columns needed
-- Pulls unnecessary data, slower network transfer
/*
SELECT * 
FROM transactions 
WHERE invoice_date >= '2011-01-01';
*/

-- OPTIMIZED: Select only required columns
SELECT 
    invoice_no,
    customer_id,
    invoice_date,
    total_amount
FROM transactions 
WHERE invoice_date >= '2011-01-01';


-- INEFFICIENT: Multiple subqueries repeating same calculation
/*
SELECT 
    customer_id,
    (SELECT SUM(total_amount) FROM transactions WHERE customer_id = c.customer_id) AS total,
    (SELECT COUNT(*) FROM transactions WHERE customer_id = c.customer_id) AS count
FROM customers c;
*/

-- OPTIMIZED: Use JOIN with GROUP BY
SELECT 
    c.customer_id,
    SUM(t.total_amount) AS total,
    COUNT(*) AS count
FROM customers c
LEFT JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id;


-- ----------------------------------------------------------------
-- Materialized Views for Expensive Aggregations
-- Purpose: Pre-calculate and cache expensive queries
-- Use Case: Dashboard queries, reporting
-- ----------------------------------------------------------------

-- Create materialized view for customer summary (refresh daily)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_customer_summary AS
SELECT 
    c.customer_id,
    c.first_purchase_date,
    c.last_purchase_date,
    COUNT(DISTINCT t.invoice_no) AS total_purchases,
    SUM(t.total_amount) AS total_spent,
    ROUND(AVG(t.total_amount), 2) AS avg_order_value
FROM customers c
LEFT JOIN transactions t ON c.customer_id = t.customer_id
WHERE t.quantity > 0
GROUP BY c.customer_id, c.first_purchase_date, c.last_purchase_date;

-- Create index on materialized view
CREATE INDEX idx_mv_customer_summary_spent ON mv_customer_summary(total_spent DESC);

-- Refresh materialized view (run daily via cron/scheduler)
-- REFRESH MATERIALIZED VIEW CONCURRENTLY mv_customer_summary;


/*
=============================================================================
SECTION 9: DATA EXPORT QUERIES
=============================================================================

Purpose: Export data for analysis in R, Excel, or other tools
Use Case: Analytics refresh, ad-hoc analysis requests

=============================================================================
*/

-- ----------------------------------------------------------------
-- QUERY 9.1: Complete Dataset Export (CSV Match)
-- Purpose: Export data matching original CSV structure
-- Use Case: Replicate CSV file from database
-- Output: Save as OnlineRetail.csv
-- ----------------------------------------------------------------

SELECT 
    t.invoice_no AS "InvoiceNo",
    p.stock_code AS "StockCode",
    p.description AS "Description",
    t.quantity AS "Quantity",
    TO_CHAR(t.invoice_date, 'MM/DD/YYYY HH24:MI') AS "InvoiceDate",
    t.unit_price AS "UnitPrice",
    t.customer_id AS "CustomerID",
    co.country_name AS "Country"
FROM transactions t
INNER JOIN products p ON t.product_id = p.product_id
LEFT JOIN customers c ON t.customer_id = c.customer_id
LEFT JOIN countries co ON c.country_id = co.country_id
WHERE t.invoice_date BETWEEN '2010-12-01' AND '2011-12-09'
ORDER BY t.invoice_date, t.invoice_no;

-- Export command (psql):
-- \copy (SELECT ...) TO '/path/to/OnlineRetail.csv' WITH CSV HEADER


-- ----------------------------------------------------------------
-- QUERY 9.2: Customer-Only Dataset Export
-- Purpose: Export for customer behavior analysis
-- Output: Save as retail_customers_only.csv
-- ----------------------------------------------------------------

SELECT 
    t.invoice_no,
    t.customer_id,
    p.stock_code,
    p.description,
    t.quantity,
    t.invoice_date,
    t.unit_price,
    t.total_amount,
    t.is_return,
    co.country_name
FROM transactions t
INNER JOIN products p ON t.product_id = p.product_id
INNER JOIN customers c ON t.customer_id = c.customer_id
INNER JOIN countries co ON c.country_id = co.country_id
WHERE t.invoice_date BETWEEN '2010-12-01' AND '2011-12-09'
ORDER BY t.customer_id, t.invoice_date;


-- ----------------------------------------------------------------
-- QUERY 9.3: Customer Summary Export
-- Purpose: Export pre-calculated customer metrics
-- Output: Save as customer_summary.csv
-- ----------------------------------------------------------------

-- (Use QUERY 4.1 from Section 4)
-- This exports the comprehensive customer summary for RFM analysis


/*
=============================================================================
END OF SQL DOCUMENTATION
=============================================================================

Summary:
- 40+ queries covering extraction, validation, and analytics
- Normalized schema design with proper indexing
- Demonstrates SQL proficiency from basic to advanced
- Ready for production database implementation
- Optimized for analytical workloads

For questions or implementation support, contact:
Victor Gomes - [victorbgomes23@gmail.com]

Last Updated: January 2025
=============================================================================
*/