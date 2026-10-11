DROP TABLE IF EXISTS dim_products CASCADE;

CREATE TABLE dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY product_id) AS product_sk,

    product_id,

    product_category_name_pt,
    product_category_name_en,

    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,

    quality_issue_flag

FROM stg_products;

ALTER TABLE dim_products
    ADD PRIMARY KEY (product_sk);