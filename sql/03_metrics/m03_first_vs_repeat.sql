-- Metric 03: First-time vs repeat customers per month
-- Definitions:
--  - first_time_customer_in_month: customer whose first completed order month = current month
--  - repeat_customer_in_month: customer who has ordered before and also ordered in current month

WITH customer_first_month AS (
  SELECT
    customer_id,
    MIN(order_month) AS first_order_month
  FROM fct_orders
  GROUP BY 1
),
monthly_customers AS (
  SELECT DISTINCT
    order_month AS month,
    customer_id
  FROM fct_orders
),
labeled AS (
  SELECT
    mc.month,
    mc.customer_id,
    CASE
      WHEN cfm.first_order_month = mc.month THEN 1 ELSE 0
    END AS is_first_time
  FROM monthly_customers mc
  JOIN customer_first_month cfm
    ON cfm.customer_id = mc.customer_id
)
SELECT
  month,
  COUNT(*) FILTER (WHERE is_first_time = 1) AS first_time_customers,
  COUNT(*) FILTER (WHERE is_first_time = 0) AS repeat_customers,
  ROUND(
    COUNT(*) FILTER (WHERE is_first_time = 0)::numeric
    / NULLIF(COUNT(*), 0)
  , 4) AS repeat_customer_rate
FROM labeled
GROUP BY 1
ORDER BY 1;
