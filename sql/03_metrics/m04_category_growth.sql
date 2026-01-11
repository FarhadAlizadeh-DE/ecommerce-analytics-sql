-- Metric 04: Category revenue and month-over-month growth
-- Uses order items joined with products, and only completed orders via stg_orders.

WITH category_monthly AS (
  SELECT
    o.order_month AS month,
    p.category,
    SUM(oi.line_net_amount) AS net_revenue
  FROM stg_orders o
  JOIN stg_order_items oi
    ON oi.order_id = o.order_id
  JOIN dim_products p
    ON p.product_id = oi.product_id
  GROUP BY 1, 2
),
with_prev AS (
  SELECT
    month,
    category,
    net_revenue,
    LAG(net_revenue) OVER (PARTITION BY category ORDER BY month) AS previous_month_revenue
  FROM category_monthly
)
SELECT
  month,
  category,
  net_revenue,
  previous_month_revenue,
  ROUND(
    (net_revenue - previous_month_revenue) / NULLIF(previous_month_revenue, 0) * 100.0
  , 2) AS mom_growth_pct
FROM with_prev
ORDER BY month, category;
