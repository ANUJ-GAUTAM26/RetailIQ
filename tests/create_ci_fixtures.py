
from pathlib import Path
import pandas as pd

RAW_DIR = Path(__file__).resolve().parent.parent / "data" / "raw"
RAW_DIR.mkdir(parents=True, exist_ok=True)

datasets = {
    "olist_customers_dataset.csv": [
        {
            "customer_id": "customer_1",
            "customer_unique_id": "unique_1",
            "customer_zip_code_prefix": 12345,
            "customer_city": "sao paulo",
            "customer_state": "SP",
        },
        {
            "customer_id": "customer_2",
            "customer_unique_id": "unique_2",
            "customer_zip_code_prefix": 54321,
            "customer_city": "rio de janeiro",
            "customer_state": "RJ",
        },
    ],
    "olist_orders_dataset.csv": [
        {
            "order_id": "order_1",
            "customer_id": "customer_1",
            "order_status": "delivered",
            "order_purchase_timestamp": "2017-01-10 10:00:00",
            "order_approved_at": "2017-01-10 10:10:00",
            "order_delivered_carrier_date": "2017-01-11 10:00:00",
            "order_delivered_customer_date": "2017-01-15 10:00:00",
            "order_estimated_delivery_date": "2017-01-20 10:00:00",
        },
        {
            "order_id": "order_2",
            "customer_id": "customer_2",
            "order_status": "delivered",
            "order_purchase_timestamp": "2017-02-10 10:00:00",
            "order_approved_at": "2017-02-10 10:10:00",
            "order_delivered_carrier_date": "2017-02-11 10:00:00",
            "order_delivered_customer_date": "2017-02-15 10:00:00",
            "order_estimated_delivery_date": "2017-02-20 10:00:00",
        },
    ],
    "olist_order_items_dataset.csv": [
        {
            "order_id": "order_1",
            "order_item_id": 1,
            "product_id": "product_1",
            "seller_id": "seller_1",
            "shipping_limit_date": "2017-01-12 10:00:00",
            "price": 100.00,
            "freight_value": 10.00,
        },
        {
            "order_id": "order_2",
            "order_item_id": 1,
            "product_id": "product_2",
            "seller_id": "seller_2",
            "shipping_limit_date": "2017-02-12 10:00:00",
            "price": 200.00,
            "freight_value": 20.00,
        },
    ],
    "olist_order_payments_dataset.csv": [
        {
            "order_id": "order_1",
            "payment_sequential": 1,
            "payment_type": "credit_card",
            "payment_installments": 1,
            "payment_value": 110.00,
        },
        {
            "order_id": "order_2",
            "payment_sequential": 1,
            "payment_type": "boleto",
            "payment_installments": 1,
            "payment_value": 220.00,
        },
    ],
    "olist_order_reviews_dataset.csv": [
        {
            "review_id": "review_1",
            "order_id": "order_1",
            "review_score": 5,
            "review_comment_title": "Great",
            "review_comment_message": "Good product",
            "review_creation_date": "2017-01-16 00:00:00",
            "review_answer_timestamp": "2017-01-17 00:00:00",
        },
        {
            "review_id": "review_2",
            "order_id": "order_2",
            "review_score": 4,
            "review_comment_title": "Good",
            "review_comment_message": "As expected",
            "review_creation_date": "2017-02-16 00:00:00",
            "review_answer_timestamp": "2017-02-17 00:00:00",
        },
    ],
    "olist_products_dataset.csv": [
        {
            "product_id": "product_1",
            "product_category_name": "electronics",
            "product_name_lenght": 20,
            "product_description_lenght": 100,
            "product_photos_qty": 2,
            "product_weight_g": 500,
            "product_length_cm": 10,
            "product_height_cm": 10,
            "product_width_cm": 10,
        },
        {
            "product_id": "product_2",
            "product_category_name": "books",
            "product_name_lenght": 15,
            "product_description_lenght": 80,
            "product_photos_qty": 1,
            "product_weight_g": 300,
            "product_length_cm": 15,
            "product_height_cm": 2,
            "product_width_cm": 10,
        },
    ],
    "olist_sellers_dataset.csv": [
        {
            "seller_id": "seller_1",
            "seller_zip_code_prefix": 11111,
            "seller_city": "sao paulo",
            "seller_state": "SP",
        },
        {
            "seller_id": "seller_2",
            "seller_zip_code_prefix": 22222,
            "seller_city": "curitiba",
            "seller_state": "PR",
        },
    ],
    "olist_geolocation_dataset.csv": [
        {
            "geolocation_zip_code_prefix": 12345,
            "geolocation_lat": -23.55,
            "geolocation_lng": -46.63,
            "geolocation_city": "sao paulo",
            "geolocation_state": "SP",
        },
    ],
    "product_category_name_translation.csv": [
        {
            "product_category_name": "electronics",
            "product_category_name_english": "electronics",
        },
        {
            "product_category_name": "books",
            "product_category_name_english": "books",
        },
    ],
}

for filename, rows in datasets.items():
    pd.DataFrame(rows).to_csv(RAW_DIR / filename, index=False)
    print(f"Created {filename}: {len(rows)} rows")

print("CI fixture dataset created.")