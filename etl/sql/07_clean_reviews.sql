DROP TABLE IF EXISTS stg_reviews CASCADE;

CREATE TABLE stg_reviews AS
SELECT
  TRIM(LOWER(review_id)) AS review_id,
  TRIM(LOWER(order_id)) AS order_id,
  review_score::INT AS review_score,
  TRIM(review_comment_title) AS review_comment_title,
  TRIM(review_comment_message) AS review_comment_message,
  review_creation_date::TIMESTAMP AS review_creation_date,
  review_answer_timestamp::TIMESTAMP AS review_answer_timestamp,
  CASE
    WHEN review_id IS NULL OR TRIM(review_id) = '' THEN 'MISSING_REVIEW_ID'
    WHEN order_id IS NULL OR TRIM(order_id) = '' THEN 'MISSING_ORDER_ID'
    WHEN review_score NOT BETWEEN 1 AND 5 THEN 'INVALID_SCORE'
    ELSE 'VALID'
  END AS quality_issue_flag
FROM raw_reviews;

ALTER TABLE stg_reviews ADD PRIMARY KEY (review_id, order_id);