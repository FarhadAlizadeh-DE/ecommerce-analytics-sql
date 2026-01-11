begin;

-- 1) Read last successful run time
with state as (
  select last_run_ts
  from pipeline_state
  where model_name = 'fct_orders_inc'
),

-- 2) Identify new orders since last run (based on order_ts)
new_orders as (
  select so.order_id
  from stg_orders so
  cross join state s
  where so.order_ts::timestamptz > s.last_run_ts
)

-- 3) Delete existing rows for delta order_ids (idempotent)
delete from fct_orders_inc
where order_id in (select order_id from new_orders);

-- 4) Insert recomputed rows from the canonical mart view
insert into fct_orders_inc (
  order_id,
  customer_id,
  order_ts,
  order_month,
  order_net_revenue,
  order_gross_revenue,
  order_discount_amount
)
select
  order_id,
  customer_id,
  order_ts,
  order_month,
  order_net_revenue,
  order_gross_revenue,
  order_discount_amount
from fct_orders
where order_id in (select order_id from new_orders);

-- 5) Advance state to latest processed order_ts in staging
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
