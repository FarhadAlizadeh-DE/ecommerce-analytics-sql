-- Sample customers
INSERT INTO raw_customers (customer_id, created_at, country, state, acquisition_channel) VALUES
(1, '2024-01-05', 'US', 'CA', 'google'),
(2, '2024-01-12', 'US', 'NY', 'facebook'),
(3, '2024-02-03', 'US', 'TX', 'organic'),
(4, '2024-02-20', 'CA', 'ON', 'google'),
(5, '2024-03-01', 'US', 'WA', 'email');

-- Sample products
INSERT INTO raw_products (product_id, product_name, category, current_price) VALUES
(101, 'Wireless Mouse', 'electronics', 25.00),
(102, 'Mechanical Keyboard', 'electronics', 120.00),
(103, 'Water Bottle', 'home', 18.00),
(104, 'Notebook', 'stationery', 6.00);

-- Sample orders
INSERT INTO raw_orders (order_id, customer_id, order_ts, status) VALUES
(1001, 1, '2024-02-01 10:15', 'completed'),
(1002, 1, '2024-03-05 14:20', 'completed'),
(1003, 2, '2024-03-07 09:00', 'completed'),
(1004, 3, '2024-03-15 16:45', 'completed'),
(1005, 4, '2024-03-20 11:30', 'cancelled');

-- Sample order items
INSERT INTO raw_order_items (order_id, product_id, quantity, unit_price_at_purchase, discount_amount) VALUES
(1001, 101, 1, 25.00, 0),
(1001, 103, 2, 18.00, 0),
(1002, 102, 1, 120.00, 20.00),
(1003, 104, 3, 6.00, 0),
(1004, 101, 2, 25.00, 5.00);
