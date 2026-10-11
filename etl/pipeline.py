from pathlib import Path

from extract import extract_csv
from load import load_table
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv


load_dotenv()


# -----------------------------
# Database connection
# -----------------------------

engine = create_engine(
    f"postgresql://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}"
    f"@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
)


# -----------------------------
# 1. Load raw data
# -----------------------------

tables = {
    "olist_customers_dataset.csv": "raw_customers",
    "olist_orders_dataset.csv": "raw_orders",
    "olist_order_items_dataset.csv": "raw_order_items",
    "olist_order_payments_dataset.csv": "raw_payments",
    "olist_order_reviews_dataset.csv": "raw_reviews",
    "olist_products_dataset.csv": "raw_products",
    "olist_sellers_dataset.csv": "raw_sellers",
    "olist_geolocation_dataset.csv": "raw_geolocation",
    "product_category_name_translation.csv": "raw_category_translation"
}


for file, table in tables.items():
    df = extract_csv(file)
    load_table(df, table)


# -----------------------------
# 2. Execute SQL transformations
# -----------------------------

SQL_DIR = Path(__file__).resolve().parent / "sql"


sql_files = [
    "01_clean_orders.sql",
    "02_clean_customers.sql",
    "03_clean_products.sql",
    "04_clean_payments.sql",
    "05_clean_order_items.sql",
    "06_clean_sellers.sql",
    "07_clean_reviews.sql",
    "08_dim_customers.sql",
    "09_dim_products.sql",
    "10_dim_sellers.sql",
    "11_dim_date.sql",
    "12_Facts_sales.sql",
    "fact_order_items.sql"
]


with engine.begin() as connection:

    for sql_file in sql_files:

        print(f"Running {sql_file}...")

        sql_path = SQL_DIR / sql_file

        sql = sql_path.read_text(encoding="utf-8")

        connection.exec_driver_sql(sql)

        print(f"Completed {sql_file}")


print("RetailIQ ETL pipeline completed successfully.")

print("Running data validation...")

import validate

print("RetailIQ ETL pipeline completed successfully.")