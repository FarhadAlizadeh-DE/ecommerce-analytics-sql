-- Metric 02: Month-over-month revenue growth
-- Outputs:
--  - month
--  - net_revenue
--  - previous_month_revenue
--  - mom_growth_pct

WITH monthly AS (
  SELECT
    order_month AS month,
    SUM(order_net_revenue) AS net_revenue
  FROM fct_orders
  GROUP BY 1
),
with_prev AS (
  SELECT
    month,
    net_revenue,
    LAG(net_revenue) OVER (ORDER BY month) AS previous_month_revenue
  FROM monthly
)
SELECT
  month,
  net_revenue,
  previous_month_revenue,
  ROUND(
    (net_revenue - previous_month_revenue) / NULLIF(previous_month_revenue, 0) * 100.0
  , 2) AS mom_growth_pct
FROM with_prev
ORDER BY month;
