-- Raw layer tables expected by staging views

drop view if exists stg_order_items;
drop view if exists stg_orders;

drop table if exists raw_order_items;
drop table if exists raw_orders;

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
