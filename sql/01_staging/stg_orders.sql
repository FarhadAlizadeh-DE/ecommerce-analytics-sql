-- Staging: orders
-- Rules:
--  - Keep only completed orders (analytics revenue truth)
--  - Standardize timestamp
--  - One row per order

CREATE OR REPLACE VIEW stg_orders AS
SELECT
  o.order_id,
  o.customer_id,
  o.order_ts::timestamp AS order_ts,
  date_trunc('month', o.order_ts)::date AS order_month
FROM raw_orders o
WHERE o.status = 'completed';
