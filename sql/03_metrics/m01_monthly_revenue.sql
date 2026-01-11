-- Metric 01: Monthly revenue summary
-- Outputs:
--  - month
--  - net_revenue
--  - orders
--  - unique_customers
--  - AOV (average order value) = net_revenue / orders

SELECT
  order_month AS month,
  SUM(order_net_revenue) AS net_revenue,
  COUNT(*) AS orders,
  COUNT(DISTINCT customer_id) AS unique_customers,
  ROUND(SUM(order_net_revenue) / NULLIF(COUNT(*), 0), 2) AS aov
FROM fct_orders
GROUP BY 1
ORDER BY 1;
