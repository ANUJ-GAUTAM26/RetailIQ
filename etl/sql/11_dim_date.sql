DROP TABLE IF EXISTS dim_date CASCADE;

CREATE TABLE dim_date AS
SELECT
  -- Integer Surrogate Key (e.g., 20180101)
  TO_CHAR(d, 'YYYYMMDD')::INT AS date_sk,
  
  -- Date Attributes
  d::DATE AS date_actual,
  EXTRACT(YEAR FROM d)::INT AS year,
  EXTRACT(QUARTER FROM d)::INT AS quarter,
  EXTRACT(MONTH FROM d)::INT AS month,
  TO_CHAR(d, 'Month') AS month_name,
  EXTRACT(DAY FROM d)::INT AS day_of_month,
  EXTRACT(ISODOW FROM d)::INT AS day_of_week,
  TO_CHAR(d, 'Day') AS day_name,
  CASE WHEN EXTRACT(ISODOW FROM d) IN (6, 7) THEN TRUE ELSE FALSE END AS is_weekend

FROM GENERATE_SERIES('2016-01-01'::TIMESTAMP, '2020-12-31'::TIMESTAMP, '1 day'::INTERVAL) d;

-- Primary Key
ALTER TABLE dim_date ADD PRIMARY KEY (date_sk);