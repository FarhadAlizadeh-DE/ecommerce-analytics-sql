-- Staging: order items
-- Rules:
--  - Compute gross and net line amounts
--  - Discount is assumed to be an absolute amount per line (not %)

CREATE OR REPLACE VIEW stg_order_items AS
SELECT
  oi.order_id,
  oi.product_id,
  oi.quantity,
  oi.unit_price_at_purchase,
  oi.discount_amount,
  (oi.quantity * oi.unit_price_at_purchase) AS line_gross_amount,
  (oi.quantity * oi.unit_price_at_purchase) - oi.discount_amount AS line_net_amount
FROM raw_order_items oi;
