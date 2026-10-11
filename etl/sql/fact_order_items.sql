DROP TABLE IF EXISTS fact_order_items;

CREATE TABLE fact_order_items AS
SELECT
    oi.order_id,
    oi.order_item_id,

    -- Surrogate keys
    p.product_sk,
    s.seller_sk,
    c.customer_sk,
    d.date_sk AS purchase_date_sk,

    -- Business identifiers
    oi.product_id,
    oi.seller_id,

    -- Measures
    oi.price,
    oi.freight_value,
    oi.price + oi.freight_value AS total_item_value,

    -- Useful order information
    o.order_purchase_timestamp,

    -- Quality information
    oi.quality_issue_flag AS item_quality_flag

FROM stg_order_items oi

JOIN stg_orders o
    ON oi.order_id = o.order_id

JOIN stg_customers sc
    ON o.customer_id = sc.customer_id

JOIN dim_customers c
    ON sc.customer_unique_id = c.customer_unique_id

JOIN dim_products p
    ON oi.product_id = p.product_id

JOIN dim_sellers s
    ON oi.seller_id = s.seller_id

JOIN dim_date d
    ON DATE(o.order_purchase_timestamp) = d.date_actual;