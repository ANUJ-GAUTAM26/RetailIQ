DROP TABLE IF EXISTS stg_products CASCADE;

CREATE TABLE stg_products AS
SELECT
  -- Primary Key
  TRIM(LOWER(p.product_id)) AS product_id,

  -- Product Categories (Original Portuguese & English Translation)
  TRIM(LOWER(p.product_category_name)) AS product_category_name_pt,
  COALESCE(TRIM(LOWER(t.product_category_name_english)), TRIM(LOWER(p.product_category_name)), 'unknown') AS product_category_name_en,

  -- Physical Dimensions & Specifications (Casted explicitly)
  p.product_name_lenght::INT      AS product_name_length,
  p.product_description_lenght::INT AS product_description_length,
  p.product_photos_qty::INT        AS product_photos_qty,
  p.product_weight_g::INT          AS product_weight_g,
  p.product_length_cm::INT         AS product_length_cm,
  p.product_height_cm::INT         AS product_height_cm,
  p.product_width_cm::INT          AS product_width_cm,

  -- Quality Validation Flag
  CASE
    WHEN p.product_id IS NULL OR TRIM(p.product_id) = '' 
      THEN 'MISSING_PRODUCT_ID'
    WHEN p.product_category_name IS NULL 
      THEN 'MISSING_CATEGORY'
    WHEN p.product_weight_g IS NOT NULL AND p.product_weight_g <= 0 
      THEN 'INVALID_WEIGHT'
    WHEN (p.product_length_cm <= 0 OR p.product_height_cm <= 0 OR p.product_width_cm <= 0) 
      THEN 'INVALID_DIMENSIONS'
    ELSE 'VALID'
  END AS quality_issue_flag

FROM raw_products p
LEFT JOIN raw_category_translation t
  ON TRIM(LOWER(p.product_category_name)) = TRIM(LOWER(t.product_category_name));

-- Enforce Primary Key
ALTER TABLE stg_products ADD PRIMARY KEY (product_id);