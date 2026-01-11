-- Raw layer tables expected by staging views

-- Reset (idempotent)
DROP VIEW IF EXISTS fct_orders CASCADE;
DROP VIEW IF EXISTS stg_order_items CASCADE;
DROP VIEW IF EXISTS stg_orders CASCADE;

DROP TABLE IF EXISTS raw_order_items CASCADE;
DROP TABLE IF EXISTS raw_orders CASCADE;
DROP TABLE IF EXISTS raw_products CASCADE;

create table raw_orders (
  order_id     bigint primary key,
  customer_id  bigint not null,
  order_ts     timestamptz not null,
  status       text not null
);

create table raw_order_items (
  order_item_id          bigint primary key,
  order_id               bigint not null references raw_orders(order_id),
  product_id             bigint not null,
  quantity               int not null check (quantity > 0),
  unit_price_at_purchase numeric(12,2) not null check (unit_price_at_purchase >= 0),
  discount_amount        numeric(12,2) not null default 0 check (discount_amount >= 0)
);

create index if not exists idx_raw_orders_ts on raw_orders(order_ts);
create index if not exists idx_raw_order_items_order_id on raw_order_items(order_id);
create index if not exists idx_raw_order_items_product_id on raw_order_items(product_id);

-- Raw products (required by dim_products mart)
create table if not exists raw_products (
  product_id   bigint primary key,
  product_name text not null,
  category     text not null
);

create index if not exists idx_raw_products_category on raw_products(category);
