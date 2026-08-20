"""
Retail Sales Analysis - Data Cleaning Script
Reads retail_sales_raw.csv, cleans it, and loads it into a SQLite database.
"""

import pandas as pd
import sqlite3

RAW_FILE = "retail_sales_raw.csv"
CLEAN_CSV = "retail_sales_clean.csv"
CLEAN_XLSX = "retail_sales_clean.xlsx"
DB_FILE = "retail_sales.db"

def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    before = len(df)

    # 1. Remove exact duplicate rows
    df = df.drop_duplicates()

    # 2. Fix negative quantity data-entry typos
    df["quantity"] = df["quantity"].abs()

    # 3. Fill missing discount values with 0% and recalculate dependent fields
    df["discount_pct"] = df["discount_pct"].fillna(0)
    df["discount_amount"] = df["gross_amount"] * (df["discount_pct"] / 100)
    df["net_sales"] = df["gross_amount"] - df["discount_amount"]

    # 4. Fill missing payment method with 'Unknown' (preserve the row instead of dropping)
    df["payment_method"] = df["payment_method"].fillna("Unknown")

    # 5. Proper date type
    df["order_date"] = pd.to_datetime(df["order_date"])

    after = len(df)
    print(f"Rows before cleaning: {before}, after: {after}")
    print(f"Missing values remaining: {df.isna().sum().sum()}")
    return df


def main():
    df = pd.read_csv(RAW_FILE)
    df = clean_data(df)

    df.to_csv(CLEAN_CSV, index=False)
    df.to_excel(CLEAN_XLSX, index=False, sheet_name="Sales")

    conn = sqlite3.connect(DB_FILE)
    df.to_sql("sales", conn, if_exists="replace", index=False)
    conn.close()

    print(f"Saved: {CLEAN_CSV}, {CLEAN_XLSX}, {DB_FILE} (table: sales)")


if __name__ == "__main__":
    main()
