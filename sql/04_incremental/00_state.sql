create table if not exists pipeline_state (
  model_name      text primary key,
  last_run_ts     timestamptz not null default '1970-01-01',
  updated_at      timestamptz not null default now()
);

insert into pipeline_state (model_name, last_run_ts)
values ('fct_orders_inc', '1970-01-01')
on conflict (model_name) do nothing;

select * from pipeline_state where model_name = 'fct_orders_inc';
