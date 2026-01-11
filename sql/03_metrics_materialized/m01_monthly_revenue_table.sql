drop table if exists m01_monthly_revenue;

create table m01_monthly_revenue as
select
  month,
  sum(net_revenue) as net_revenue,
  count(distinct order_id) as orders,
  count(distinct customer_id) as unique_customers,
  round(sum(net_revenue) / nullif(count(distinct order_id), 0), 2) as aov
from fct_orders
group by month
order by month;
