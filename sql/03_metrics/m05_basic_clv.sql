-- Metric 05: Basic Customer Lifetime Value (CLV - lite)
-- Definition:
--  - CLV = total net revenue per customer over observed period
--  - Includes order count and first/last order timestamps

SELECT
  customer_id,
  COUNT(*) AS order_count,
  SUM(order_net_revenue) AS lifetime_net_revenue,
  MIN(order_ts) AS first_order_ts,
  MAX(order_ts) AS last_order_ts
FROM fct_orders
GROUP BY 1
ORDER BY lifetime_net_revenue DESC;
