DROP TABLE IF EXISTS dim_sellers CASCADE;

CREATE TABLE dim_sellers AS
SELECT
  -- Integer Surrogate Key
  ROW_NUMBER() OVER (ORDER BY seller_id) AS seller_sk,
  
  -- Natural Key
  seller_id,
  
  -- Location Attributes
  seller_zip_code_prefix,
  seller_city,
  seller_state

FROM stg_sellers
WHERE quality_issue_flag = 'VALID';

-- Primary Key
ALTER TABLE dim_sellers ADD PRIMARY KEY (seller_sk);