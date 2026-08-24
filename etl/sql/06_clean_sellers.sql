DROP TABLE IF EXISTS stg_sellers CASCADE;

CREATE TABLE stg_sellers AS
SELECT
  TRIM(LOWER(seller_id)) AS seller_id,
  LPAD(TRIM(seller_zip_code_prefix::TEXT), 5, '0') AS seller_zip_code_prefix,
  TRIM(INITCAP(seller_city)) AS seller_city,
  TRIM(UPPER(seller_state)) AS seller_state,
  CASE
    WHEN seller_id IS NULL OR TRIM(seller_id) = '' THEN 'MISSING_SELLER_ID'
    WHEN LENGTH(LPAD(TRIM(seller_zip_code_prefix::TEXT), 5, '0')) <> 5 THEN 'INVALID_ZIP_PREFIX'
    WHEN LENGTH(TRIM(seller_state)) <> 2 THEN 'INVALID_STATE_CODE'
    ELSE 'VALID'
  END AS quality_issue_flag
FROM raw_sellers;

ALTER TABLE stg_sellers ADD PRIMARY KEY (seller_id);