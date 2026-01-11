-- Quality checks: return 0 rows if everything is healthy

-- 1) Net revenue should never be negative
select *
from fct_orders_inc
where order_net_revenue < 0;

-- 2) Gross revenue should never be negative
select *
from fct_orders_inc
where order_gross_revenue < 0;

-- 3) Discount should never be negative
select *
from fct_orders_inc
where order_discount_amount < 0;

-- 4) Net should not exceed gross (unless your business allows it)
select *
from fct_orders_inc
where order_net_revenue > order_gross_revenue;

-- 5) No duplicate order_id (should be impossible with PK)
select order_id, count(*)
from fct_orders_inc
group by 1
having count(*) > 1;
