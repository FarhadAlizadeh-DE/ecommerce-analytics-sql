-- Mart: fact orders (one row per completed order)
-- Net revenue is computed from item lines (gross - discount)
-- Only includes completed orders via stg_orders

CREATE OR REPLACE VIEW fct_orders AS
SELECT
  o.order_id,
  o.customer_id,
  o.order_ts,
  o.order_month,
  SUM(oi.line_net_amount) AS order_net_revenue,
  SUM(oi.line_gross_amount) AS order_gross_revenue,
  SUM(oi.discount_amount) AS order_discount_amount
FROM stg_orders o
JOIN stg_order_items oi
  ON oi.order_id = o.order_id
GROUP BY
  o.order_id, o.customer_id, o.order_ts, o.order_month;
