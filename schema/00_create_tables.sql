-- Raw tables (PostgreSQL)

DROP TABLE IF EXISTS raw_order_items;
DROP TABLE IF EXISTS raw_orders;
DROP TABLE IF EXISTS raw_products;
DROP TABLE IF EXISTS raw_customers;

CREATE TABLE raw_customers (
  customer_id         BIGINT PRIMARY KEY,
  created_at          TIMESTAMP NOT NULL,
  country             TEXT,
  state               TEXT,
  acquisition_channel TEXT
);

CREATE TABLE raw_products (
  product_id     BIGINT PRIMARY KEY,
  product_name   TEXT NOT NULL,
  category       TEXT NOT NULL,
  current_price  NUMERIC(12,2)
);

CREATE TABLE raw_orders (
  order_id     BIGINT PRIMARY KEY,
  customer_id  BIGINT NOT NULL REFERENCES raw_customers(customer_id),
  order_ts     TIMESTAMP NOT NULL,
  status       TEXT NOT NULL CHECK (status IN ('completed','cancelled','refunded'))
);

CREATE TABLE raw_order_items (
  order_id     BIGINT NOT NULL REFERENCES raw_orders(order_id),
  product_id   BIGINT NOT NULL REFERENCES raw_products(product_id),
  quantity     INTEGER NOT NULL CHECK (quantity > 0),
  unit_price_at_purchase NUMERIC(12,2) NOT NULL CHECK (unit_price_at_purchase >= 0),
  discount_amount        NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (discount_amount >= 0),
  PRIMARY KEY (order_id, product_id)
);

CREATE INDEX idx_raw_orders_customer_ts ON raw_orders(customer_id, order_ts);
CREATE INDEX idx_raw_orders_ts ON raw_orders(order_ts);
CREATE INDEX idx_raw_products_category ON raw_products(category);
