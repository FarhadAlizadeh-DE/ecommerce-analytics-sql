begin;

-- 1) Read last successful run time
with state as (
  select last_run_ts
  from pipeline_state
  where model_name = 'fct_orders_inc'
),

-- 2) Identify new orders since last run (using stg_orders timestamp)
new_orders as (
  select so.order_id
  from stg_orders so
  cross join state s
  where so.order_ts::timestamptz > s.last_run_ts
),

-- 3) Recompute only those orders using your existing fct_orders view logic
delta as (
  select fo.*
  from fct_orders fo
  where fo.order_id in (select order_id from new_orders)
)

-- 4) Upsert into materialized table
insert into fct_orders_inc
select * from delta
on conflict (order_id) do update
set
  -- overwrite all columns with the latest computed values
  customer_id = excluded.customer_id,
  order_ts = excluded.order_ts,
  order_month = excluded.order_month,
  gross_revenue = excluded.gross_revenue,
  discount_amount = excluded.discount_amount,
  net_revenue = excluded.net_revenue,
  item_count = excluded.item_count;

-- 5) Advance state
update pipeline_state
set last_run_ts = (
      select coalesce(max(order_ts)::timestamptz, last_run_ts)
      from stg_orders
    ),
    updated_at = now()
where model_name = 'fct_orders_inc';

commit;

select count(*) as fct_orders_inc_rows from fct_orders_inc;
select * from pipeline_state where model_name = 'fct_orders_inc';
