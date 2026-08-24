DROP TABLE IF EXISTS stg_payments CASCADE;

CREATE TABLE stg_payments AS
SELECT
  -- Foreign Key
  TRIM(LOWER(order_id)) AS order_id,

  -- Payment Attributes
  payment_sequential::INT           AS payment_sequential,
  TRIM(LOWER(payment_type))         AS payment_type,
  payment_installments::INT         AS payment_installments,
  payment_value::NUMERIC(10, 2)     AS payment_value,

  -- Data Quality Flag
  CASE
    WHEN order_id IS NULL OR TRIM(order_id) = '' 
      THEN 'MISSING_ORDER_ID'
    WHEN payment_value IS NULL OR payment_value < 0 
      THEN 'INVALID_PAYMENT_VALUE'
    WHEN payment_installments IS NULL OR payment_installments < 0 
      THEN 'INVALID_INSTALLMENTS'
    WHEN payment_value = 0 AND payment_type <> 'not_defined' 
      THEN 'ZERO_PAYMENT_VALUE'
    ELSE 'VALID'
  END AS quality_issue_flag

FROM raw_payments;

-- Composite Primary Key
ALTER TABLE stg_payments ADD PRIMARY KEY (order_id, payment_sequential);