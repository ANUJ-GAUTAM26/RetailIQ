DROP TABLE IF EXISTS fact_sales CASCADE;

CREATE TABLE fact_sales AS
WITH aggregated_items AS (
  SELECT
    order_id,
    COUNT(order_item_id) AS total_items,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(DISTINCT seller_id) AS unique_sellers,
    SUM(price) AS total_item_price,
    SUM(freight_value) AS total_freight_value,
    SUM(price + freight_value) AS total_order_item_cost
  FROM stg_order_items
  WHERE quality_issue_flag = 'VALID'
  GROUP BY order_id
),
aggregated_payments AS (
  SELECT
    order_id,
    SUM(payment_value) AS total_payment_value,
    MAX(payment_installments) AS max_installments,
    STRING_AGG(DISTINCT payment_type, ', ') AS payment_methods_used
  FROM stg_payments
  WHERE quality_issue_flag = 'VALID'
  GROUP BY order_id
),
aggregated_reviews AS (
  SELECT
    order_id,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    COUNT(review_id) AS total_reviews
  FROM stg_reviews
  WHERE quality_issue_flag = 'VALID'
  GROUP BY order_id
)

SELECT
  -- Primary Key
  o.order_id,

  -- Foreign Keys (Surrogate Keys for Star Schema)
  dc.customer_sk,
  TO_CHAR(o.order_purchase_timestamp, 'YYYYMMDD')::INT AS purchase_date_sk,

  -- Natural Identifiers (Traceability)
  o.customer_id,
  c.customer_unique_id,

  -- Order Status & Timestamps
  o.order_status,
  o.order_purchase_timestamp,
  o.order_approved_at,
  o.order_delivered_carrier_date,
  o.order_delivered_customer_date,
  o.order_estimated_delivery_date,

  -- Item Metrics
  COALESCE(i.total_items, 0) AS total_items,
  COALESCE(i.unique_products, 0) AS unique_products,
  COALESCE(i.unique_sellers, 0) AS unique_sellers,
  COALESCE(i.total_item_price, 0.00) AS total_item_price,
  COALESCE(i.total_freight_value, 0.00) AS total_freight_value,
  COALESCE(i.total_order_item_cost, 0.00) AS total_order_item_cost,

  -- Payment Metrics
  COALESCE(p.total_payment_value, 0.00) AS total_payment_value,
  COALESCE(p.max_installments, 0) AS max_installments,
  p.payment_methods_used,

  -- Review Metrics
  r.avg_review_score,
  COALESCE(r.total_reviews, 0) AS total_reviews,

  -- Data Quality Flag
  o.quality_issue_flag AS order_quality_flag

FROM stg_orders o
LEFT JOIN stg_customers c ON o.customer_id = c.customer_id
LEFT JOIN dim_customers dc ON c.customer_unique_id = dc.customer_unique_id
LEFT JOIN aggregated_items i ON o.order_id = i.order_id
LEFT JOIN aggregated_payments p ON o.order_id = p.order_id
LEFT JOIN aggregated_reviews r ON o.order_id = r.order_id;

-- Primary Key & Foreign Keys
ALTER TABLE fact_sales ADD PRIMARY KEY (order_id);
ALTER TABLE fact_sales ADD CONSTRAINT fk_fact_sales_customers FOREIGN KEY (customer_sk) REFERENCES dim_customers(customer_sk);
ALTER TABLE fact_sales ADD CONSTRAINT fk_fact_sales_date FOREIGN KEY (purchase_date_sk) REFERENCES dim_date(date_sk);