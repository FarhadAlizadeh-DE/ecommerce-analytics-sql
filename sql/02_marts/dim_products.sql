-- Mart: product dimension
-- One row per product with stable attributes for analysis

CREATE OR REPLACE VIEW dim_products AS
SELECT
  product_id,
  product_name,
  category
FROM raw_products;
