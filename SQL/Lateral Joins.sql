-- Lateral Joins

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.total
FROM
    customers c
CROSS JOIN LATERAL (
    SELECT
        o.order_id,
        SUM(oi.quantity * p.price) AS total
    FROM
        orders o
    JOIN
        order_items oi ON o.order_id = oi.order_id
    JOIN
        products p ON oi.product_id = p.product_id
    WHERE
        o.customer_id = c.customer_id
    GROUP BY
        o.order_id
    ORDER BY
        total DESC
    LIMIT 1
) o;

-- This query retrieves each customer’s largest order by total value using a lateral join