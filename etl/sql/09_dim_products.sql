DROP TABLE IF EXISTS dim_products CASCADE;

CREATE TABLE dim_products AS
SELECT
  -- Integer Surrogate Key
  ROW_NUMBER() OVER (ORDER BY product_id) AS product_sk,
  
  -- Natural Key
  product_id,
  
  -- Category Attributes
  product_category_name_pt,
  product_category_name_en,
  
  -- Physical Attributes
  product_name_length,
  product_description_length,
  product_photos_qty,
  product_weight_g,
  product_length_cm,
  product_height_cm,
  product_width_cm

FROM stg_products
WHERE quality_issue_flag = 'VALID';

-- Primary Key
ALTER TABLE dim_products ADD PRIMARY KEY (product_sk);