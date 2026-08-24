DROP TABLE IF EXISTS dim_customers CASCADE;

CREATE TABLE dim_customers AS
WITH customer_locations AS (
  -- Grab the most recent location per customer_unique_id
  SELECT 
    c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,
    ROW_NUMBER() OVER (
      PARTITION BY c.customer_unique_id 
      ORDER BY o.order_purchase_timestamp DESC NULLS LAST
    ) AS location_rank
  FROM stg_customers c
  LEFT JOIN stg_orders o ON c.customer_id = o.customer_id
  WHERE c.quality_issue_flag = 'VALID'
),
latest_customer_location AS (
  SELECT 
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
  FROM customer_locations
  WHERE location_rank = 1
),
customer_aggregates AS (
  -- Aggregate lifetime order metrics per unique customer
  SELECT 
    c.customer_unique_id,
    MIN(o.order_purchase_timestamp) AS first_order_timestamp,
    MAX(o.order_purchase_timestamp) AS most_recent_order_timestamp,
    COUNT(DISTINCT o.order_id) AS total_lifetime_orders
  FROM stg_customers c
  LEFT JOIN stg_orders o ON c.customer_id = o.customer_id
  WHERE c.quality_issue_flag = 'VALID'
  GROUP BY c.customer_unique_id
)

SELECT
  -- Unique Integer Surrogate Key
  ROW_NUMBER() OVER (ORDER BY ca.customer_unique_id) AS customer_sk,
  
  -- Natural Key
  ca.customer_unique_id,
  
  -- Most Recent Location Attributes
  lcl.customer_zip_code_prefix,
  lcl.customer_city,
  lcl.customer_state,
  
  -- Lifetime Aggregations
  ca.first_order_timestamp,
  ca.most_recent_order_timestamp,
  ca.total_lifetime_orders

FROM customer_aggregates ca
LEFT JOIN latest_customer_location lcl 
  ON ca.customer_unique_id = lcl.customer_unique_id;

-- Enforce Primary Key
ALTER TABLE dim_customers ADD PRIMARY KEY (customer_sk);