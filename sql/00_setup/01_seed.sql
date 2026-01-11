-- Seed data: enough variety to make metrics interesting

insert into raw_orders (order_id, customer_id, order_ts, status) values
(1001, 1, '2025-01-05 10:15:00+00', 'completed'),
(1002, 2, '2025-01-12 12:00:00+00', 'completed'),
(1003, 1, '2025-02-02 09:30:00+00', 'completed'),
(1004, 3, '2025-02-10 14:45:00+00', 'pending'),     -- should be excluded by stg_orders
(1005, 2, '2025-03-01 08:05:00+00', 'completed'),
(1006, 4, '2025-03-15 18:20:00+00', 'cancelled');   -- should be excluded by stg_orders

insert into raw_order_items (
  order_item_id, order_id, product_id, quantity, unit_price_at_purchase, discount_amount
) values
(1, 1001, 501, 1, 29.99, 0.00),
(2, 1001, 601, 3, 12.50, 0.00),

(3, 1002, 501, 1, 29.99, 0.00),
(4, 1002, 701, 2, 19.00, 0.00),

(5, 1003, 601, 1, 12.50, 2.50),
(6, 1003, 801, 1, 50.00, 0.00),

(7, 1004, 501, 1, 29.99, 0.00),  -- pending order (will not count in revenue)

(8, 1005, 701, 1, 19.00, 0.00),
(9, 1005, 901, 2, 15.00, 5.00),

(10, 1006, 601, 2, 12.50, 0.00); -- cancelled order (will not count in revenue)
