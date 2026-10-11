-- ============================================================
-- 13_validate_gold.sql
-- RetailIQ - Gold Layer Validation
-- ============================================================


-- 1. Fact table row count
SELECT COUNT(*) AS total_orders
FROM fact_sales;


-- 2. Duplicate order_id
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM fact_sales
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 3. Missing customer surrogate keys
SELECT COUNT(*) AS missing_customer_sk
FROM fact_sales
WHERE customer_sk IS NULL;


-- 4. Missing purchase date keys
SELECT COUNT(*) AS missing_purchase_date_sk
FROM fact_sales
WHERE purchase_date_sk IS NULL;


-- 5. Negative values
SELECT *
FROM fact_sales
WHERE total_items < 0
   OR unique_products < 0
   OR unique_sellers < 0
   OR total_item_price < 0
   OR total_freight_value < 0
   OR total_order_item_cost < 0
   OR total_payment_value < 0
   OR max_installments < 0;


-- 6. Invalid timestamp sequence
SELECT *
FROM fact_sales
WHERE
       (order_approved_at IS NOT NULL
        AND order_approved_at < order_purchase_timestamp)

    OR (order_delivered_carrier_date IS NOT NULL
        AND order_delivered_carrier_date < order_purchase_timestamp)

    OR (order_delivered_carrier_date IS NOT NULL
        AND order_approved_at IS NOT NULL
        AND order_delivered_carrier_date < order_approved_at)

    OR (order_delivered_customer_date IS NOT NULL
        AND order_delivered_carrier_date IS NOT NULL
        AND order_delivered_customer_date < order_delivered_carrier_date)

    OR (order_delivered_customer_date IS NOT NULL
        AND order_delivered_customer_date < order_purchase_timestamp);


-- 7. Delivered orders without delivery timestamp
SELECT *
FROM fact_sales
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;


-- 8. Non-delivered orders with delivery timestamp
SELECT *
FROM fact_sales
WHERE order_status <> 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- 9. Estimated delivery before purchase
SELECT *
FROM fact_sales
WHERE order_estimated_delivery_date IS NOT NULL
  AND order_estimated_delivery_date < order_purchase_timestamp;


-- 10. Order quality flag distribution
SELECT
    order_quality_flag,
    COUNT(*) AS order_count
FROM fact_sales
GROUP BY order_quality_flag
ORDER BY order_count DESC;


-- 11. Order status distribution
SELECT
    order_status,
    COUNT(*) AS order_count
FROM fact_sales
GROUP BY order_status
ORDER BY order_count DESC;


-- 12. Monthly sales
SELECT
    d.year,
    d.month,
    TRIM(d.month_name) AS month_name,
    COUNT(*) AS order_count,
    ROUND(SUM(f.total_item_price), 2) AS total_revenue
FROM fact_sales f
JOIN dim_date d
    ON f.purchase_date_sk = d.date_sk
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY
    d.year,
    d.month;


-- 13. Overall business metrics
SELECT
    COUNT(*) AS total_orders,
    SUM(total_items) AS total_items,
    ROUND(SUM(total_item_price), 2) AS total_item_revenue,
    ROUND(SUM(total_freight_value), 2) AS total_freight,
    ROUND(SUM(total_order_item_cost), 2) AS total_cost,
    ROUND(SUM(total_payment_value), 2) AS total_payment_value,
    ROUND(AVG(avg_review_score), 2) AS avg_review_score
FROM fact_sales;