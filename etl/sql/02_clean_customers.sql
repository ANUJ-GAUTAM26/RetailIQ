DROP TABLE IF EXISTS stg_customers CASCADE;

CREATE TABLE stg_customers AS
SELECT
  -- Identifiers
  TRIM(LOWER(customer_id)) AS customer_id,
  TRIM(LOWER(customer_unique_id)) AS customer_unique_id,

  -- Location Attributes
  LPAD(TRIM(customer_zip_code_prefix::TEXT), 5, '0') AS customer_zip_code_prefix,
  TRIM(INITCAP(customer_city)) AS customer_city,
  TRIM(UPPER(customer_state)) AS customer_state,

  -- Quality Validation Flag
  CASE
    WHEN customer_id IS NULL OR TRIM(customer_id) = '' 
      THEN 'MISSING_CUSTOMER_ID'
    WHEN customer_unique_id IS NULL OR TRIM(customer_unique_id) = '' 
      THEN 'MISSING_UNIQUE_ID'
    WHEN LENGTH(LPAD(TRIM(customer_zip_code_prefix::TEXT), 5, '0')) <> 5 
      THEN 'INVALID_ZIP_PREFIX'
    WHEN LENGTH(TRIM(customer_state)) <> 2 
      THEN 'INVALID_STATE_CODE'
    ELSE 'VALID'
  END AS quality_issue_flag

FROM raw_customers;

-- Enforce PK
ALTER TABLE stg_customers ADD PRIMARY KEY (customer_id);