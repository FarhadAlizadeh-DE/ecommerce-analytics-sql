begin;

-- Build (or rebuild) the incremental table from the existing mart view
drop table if exists fct_orders_inc;

create table fct_orders_inc as
select *
from fct_orders;

-- Add primary key for upserts
alter table fct_orders_inc
  add constraint fct_orders_inc_pk primary key (order_id);

-- Set pipeline state to the max processed order_ts from staging
update pipeline_state
set last_run_ts = (
      select coalesce(max(order_ts)::timestamptz, '1970-01-01')
      from stg_orders
    ),
    updated_at = now()
where model_name = 'fct_orders_inc';

commit;

select count(*) as fct_orders_inc_rows from fct_orders_inc;
select * from pipeline_state where model_name = 'fct_orders_inc';
