## Important Note About Processed Data

**Processed data files are NOT included in this repository** because they exceed GitHub's file size limits (100 MB).

### To Generate Processed Datasets:

1. Download the raw data: `OnlineRetail.csv` (see Source section above)
2. Place it in `data/raw/`
3. Run `notebooks/01_data_exploration.Rmd`
4. Run `notebooks/02_data_cleaning.Rmd`
5. Processed files will be created in `data/processed/`

### Generated Files:

- `retail_cleaned.csv` (~104 MB) - Full cleaned transaction data
- `retail_customers_only.csv` (~78 MB) - Transactions with CustomerID only
- `customer_summary.csv` (~500 KB) - Pre-calculated customer metrics

**Note:** These files are in `.gitignore` and will not be pushed to GitHub.
