DROP TABLE IF EXISTS dim_date CASCADE;

CREATE TABLE dim_date AS
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INTEGER AS date_sk,
    d::DATE AS date_actual,
    EXTRACT(YEAR FROM d)::INTEGER AS year,
    EXTRACT(QUARTER FROM d)::INTEGER AS quarter,
    EXTRACT(MONTH FROM d)::INTEGER AS month,
    TRIM(TO_CHAR(d, 'Month')) AS month_name,
    EXTRACT(DAY FROM d)::INTEGER AS day_of_month,
    EXTRACT(ISODOW FROM d)::INTEGER AS day_of_week,
    TRIM(TO_CHAR(d, 'Day')) AS day_name,
    EXTRACT(ISODOW FROM d)::INTEGER IN (6, 7) AS is_weekend
FROM generate_series(
    '2016-01-01'::DATE,
    '2018-12-31'::DATE,
    '1 day'::INTERVAL
) AS g(d);

ALTER TABLE dim_date
ADD PRIMARY KEY (date_sk);