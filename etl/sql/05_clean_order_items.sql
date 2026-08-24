DROP TABLE IF EXISTS stg_order_items CASCADE;

CREATE TABLE stg_order_items AS
SELECT
  -- Keys
  TRIM(LOWER(order_id))         AS order_id,
  order_item_id::INT            AS order_item_id,
  TRIM(LOWER(product_id))       AS product_id,
  TRIM(LOWER(seller_id))        AS seller_id,

  -- Fulfilment Deadline
  shipping_limit_date::TIMESTAMP AS shipping_limit_date,

  -- Financial Measures
  price::NUMERIC(10, 2)         AS price,
  freight_value::NUMERIC(10, 2)  AS freight_value,

  -- Data Quality Flag
  CASE
    WHEN order_id IS NULL OR TRIM(order_id) = '' 
      THEN 'MISSING_ORDER_ID'
    WHEN product_id IS NULL OR TRIM(product_id) = '' 
      THEN 'MISSING_PRODUCT_ID'
    WHEN seller_id IS NULL OR TRIM(seller_id) = '' 
      THEN 'MISSING_SELLER_ID'
    WHEN price IS NULL OR price < 0 
      THEN 'INVALID_PRICE'
    WHEN freight_value IS NULL OR freight_value < 0 
      THEN 'INVALID_FREIGHT'
    ELSE 'VALID'
  END AS quality_issue_flag

FROM raw_order_items;

-- Composite Primary Key
ALTER TABLE stg_order_items ADD PRIMARY KEY (order_id, order_item_id);