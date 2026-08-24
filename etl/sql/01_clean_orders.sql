DROP TABLE IF EXISTS stg_orders CASCADE;

CREATE TABLE stg_orders AS
SELECT
  -- Primary & Foreign Keys
  TRIM(LOWER(order_id)) AS order_id,
  TRIM(LOWER(customer_id)) AS customer_id,

  -- Categorical Attributes
  TRIM(LOWER(order_status)) AS order_status,

  -- Lifecycle Timestamps
  order_purchase_timestamp::TIMESTAMP       AS order_purchase_timestamp,
  order_approved_at::TIMESTAMP               AS order_approved_at,
  order_delivered_carrier_date::TIMESTAMP   AS order_delivered_carrier_date,
  order_delivered_customer_date::TIMESTAMP  AS order_delivered_customer_date,
  order_estimated_delivery_date::TIMESTAMP  AS order_estimated_delivery_date,

  -- Quality Flag Logic
  CASE
    WHEN order_purchase_timestamp IS NULL 
      THEN 'MISSING_PURCHASE_TIMESTAMP'
    WHEN order_approved_at IS NOT NULL AND order_approved_at < order_purchase_timestamp 
      THEN 'INVALID_APPROVAL_TIME'
    WHEN order_delivered_carrier_date IS NOT NULL AND order_delivered_carrier_date < order_purchase_timestamp 
      THEN 'INVALID_CARRIER_TIME'
    WHEN order_delivered_carrier_date IS NOT NULL AND order_approved_at IS NOT NULL AND order_delivered_carrier_date < order_approved_at 
      THEN 'INVALID_CARRIER_APPROVAL_TIME'
    WHEN order_delivered_customer_date IS NOT NULL AND order_delivered_carrier_date IS NOT NULL AND order_delivered_customer_date < order_delivered_carrier_date 
      THEN 'INVALID_DELIVERY_TIME'
    WHEN order_status = 'delivered' AND order_delivered_customer_date IS NULL 
      THEN 'MISSING_DELIVERY_TIMESTAMP'
    WHEN order_status <> 'delivered' AND order_delivered_customer_date IS NOT NULL 
      THEN 'DELIVERY_STATUS_MISMATCH'
    WHEN order_estimated_delivery_date IS NOT NULL AND order_estimated_delivery_date < order_purchase_timestamp 
      THEN 'INVALID_ESTIMATED_DELIVERY'
    WHEN order_delivered_customer_date IS NOT NULL AND order_delivered_customer_date < order_purchase_timestamp 
      THEN 'NEGATIVE_DELIVERY_DURATION'
    ELSE 'VALID'
  END AS quality_issue_flag

FROM raw_orders;

ALTER TABLE stg_orders ADD PRIMARY KEY (order_id);