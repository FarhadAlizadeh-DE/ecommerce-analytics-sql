-- Quality checks: should return 0 rows for “bad” checks

-- 1) Net revenue should never be negative
select *
from fct_orders_inc
where net_revenue < 0;

-- 2) Every order must have at least one item
select *
from fct_orders_inc
where item_count <= 0;

-- 3) No duplicate order_id (should be impossible with PK)
select order_id, count(*)
from fct_orders_inc
group by 1
having count(*) > 1;
