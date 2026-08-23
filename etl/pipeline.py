from extract import extract_csv
from load import load_table


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