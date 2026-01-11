begin;

-- 1) Build a temp table of delta order_ids (new since last run)
drop table if exists tmp_new_orders;
create temp table tmp_new_orders as
with state as (
  select last_run_ts
  from pipeline_state
  where model_name = 'fct_orders_inc'
)
select so.order_id
from stg_orders so
cross join state s
where so.order_ts::timestamptz > s.last_run_ts;

-- 2) Delete existing rows for delta order_ids (idempotent)
delete from fct_orders_inc
where order_id in (select order_id from tmp_new_orders);

-- 3) Insert recomputed rows from the canonical mart view
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
where order_id in (select order_id from tmp_new_orders);

-- 4) Advance state only if we processed something new
update pipeline_state
set last_run_ts = (
      select coalesce(max(so.order_ts)::timestamptz, last_run_ts)
      from stg_orders so
      where so.order_id in (select order_id from tmp_new_orders)
    ),
    updated_at = now()
where model_name = 'fct_orders_inc';

commit;

select count(*) as fct_orders_inc_rows from fct_orders_inc;
select * from pipeline_state where model_name = 'fct_orders_inc';
