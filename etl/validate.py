import os

from dotenv import load_dotenv
from sqlalchemy import create_engine, text


load_dotenv()

engine = create_engine(
    f"postgresql://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}"
    f"@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
)


checks = {
    "fact_sales row count": """
        SELECT COUNT(*)
        FROM fact_sales
    """,

    "fact_sales duplicate orders": """
        SELECT COUNT(*)
        FROM (
            SELECT order_id
            FROM fact_sales
            GROUP BY order_id
            HAVING COUNT(*) > 1
        ) x
    """,

    "fact_order_items missing customer SK": """
        SELECT COUNT(*)
        FROM fact_order_items
        WHERE customer_sk IS NULL
    """,

    "fact_order_items missing product SK": """
        SELECT COUNT(*)
        FROM fact_order_items
        WHERE product_sk IS NULL
    """,

    "fact_order_items missing seller SK": """
        SELECT COUNT(*)
        FROM fact_order_items
        WHERE seller_sk IS NULL
    """,

    "fact_order_items missing date SK": """
        SELECT COUNT(*)
        FROM fact_order_items
        WHERE purchase_date_sk IS NULL
    """,

    "negative item price": """
        SELECT COUNT(*)
        FROM fact_order_items
        WHERE price < 0
    """,

    "negative freight": """
        SELECT COUNT(*)
        FROM fact_order_items
        WHERE freight_value < 0
    """
}


failures = []

with engine.connect() as connection:

    for name, query in checks.items():

        result = connection.execute(text(query)).scalar()

        print(f"{name}: {result}")

        if name == "fact_sales row count":
            if result == 0:
                failures.append(name)

        elif result > 0:
            failures.append(name)


if failures:
    print("\nDATA VALIDATION FAILED")

    for failure in failures:
        print(f" - {failure}")

    raise SystemExit(1)


print("\nDATA VALIDATION PASSED")