# Retail Sales Analysis — SQL + Power BI Dashboard

## Problem Statement
A retail business wants to understand where its revenue is coming from — which regions,
categories, products, and customer segments drive performance — and where it's losing money
to discounts and returns. This project analyzes 2 years of transactional sales data using SQL
for querying and Power BI for visualization, ending in a set of concrete business
recommendations.

## Dataset
- **Source**: Synthetic dataset generated to mirror a realistic Indian retail sales export
  (6,000 transactions, Jan 2023 – Dec 2024)
- **Fields**: order id, order date, customer id & segment, region, product category & name,
  quantity, unit price, discount %, net sales, payment method, return flag
- **Realistic messiness included on purpose**: duplicate rows, missing discount/payment values,
  a few negative-quantity data-entry errors — cleaned in `01_data_cleaning.py`

## Tools Used
`SQL (SQLite)` · `Python (pandas)` · `Power BI` · `Excel`

## Project Structure
```
retail_sales_raw.csv        # raw synthetic data (before cleaning)
retail_sales_clean.csv      # cleaned data
retail_sales_clean.xlsx     # cleaned data, ready to import into Power BI
retail_sales.db             # SQLite database (table: sales)
sql_analysis.sql            # 10 business-question SQL queries
query_results.md            # output of all 10 queries
dashboard_preview.png       # static preview of the dashboard visuals
README.md
```

## Data Cleaning
- Removed 15 exact duplicate order rows
- Corrected 5 rows with negative quantity (data-entry typo) using absolute value
- Filled 192 missing discount values with 0% (no discount applied) and recalculated net sales
- Filled 142 missing payment methods with "Unknown" rather than dropping the rows

## SQL Analysis
10 queries answer core business questions, covering:
1. Overall KPIs (total orders, revenue, AOV)
2. Monthly revenue trend
3. Revenue and orders by region
4. Top 10 products by revenue
5. Category-wise revenue contribution (%)
6. Month-over-month revenue growth
7. Customer segment performance
8. Top 10 customers by lifetime spend
9. Return rate by category
10. Payment method preference and average order value

Full queries: [`sql_analysis.sql`](sql_analysis.sql). Full output: [`query_results.md`](query_results.md).

## Dashboard
Built in Power BI using `retail_sales_clean.xlsx`: monthly revenue trend, revenue by region,
category contribution, and top 5 products by revenue — with slicers for region, category, and
order date.

![Retail Sales Dashboard]
<img width="1321" height="735" alt="Screenshot 2026-08-20 122747" src="https://github.com/user-attachments/assets/84d91481-a885-4fcf-9b93-62b4dacf5586" />


## Key Insights
- **Electronics drives ~68% of total revenue** despite being only 1 of 5 categories — the
  business is heavily concentrated in a single category, which is a concentration risk.
- **South region leads revenue (₹22.6M)** with the highest average order value (₹16,517),
  ~19% ahead of the lowest-performing region (Central).
- **Revenue dipped in Feb 2024 (−20% MoM)** and again mid-2024, while March and June 2024 saw
  the two sharpest recoveries (+49% and +40% MoM) — worth investigating what drove those swings
  (promotions, stock availability, or seasonality).
- **Sports products have the highest return rate (7.5%)**, nearly 3 points above Electronics
  (4.8%) — a potential sizing, quality, or product-description issue worth a closer look.
- **UPI is the dominant payment method (34% of orders)**, but Credit Card orders have the
  highest average value (₹15,112) — suggesting higher-value purchases skew toward credit.

## How to Reproduce
1. `python 01_data_cleaning.py` — cleans raw data, loads into SQLite (`retail_sales.db`)
2. Run `sql_analysis.sql` against `retail_sales.db` (or open in DB Browser for SQLite)
3. Import `retail_sales_clean.xlsx` into Power BI Desktop and build the visuals described above

---
*Note: This project uses a synthetic dataset built to mirror realistic retail transaction
patterns, created for portfolio purposes.*



