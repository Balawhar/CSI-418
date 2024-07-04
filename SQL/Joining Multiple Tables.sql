-- Joining Multiple Tables

SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    SUM(oi.quantity * p.price) AS total_order_value
FROM
    orders o
JOIN
    customers c ON o.customer_id = c.customer_id
JOIN
    order_items oi ON o.order_id = oi.order_id
JOIN
    products p ON oi.product_id = p.product_id
GROUP BY
    o.order_id, o.order_date, c.customer_name
HAVING
    SUM(oi.quantity * p.price) > 100;

-- This query retrieves orders with their total value, joining multiple related tables, 
-- and filters orders with a total value greater than 100.