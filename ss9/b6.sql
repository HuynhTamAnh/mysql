--bài6
CREATE VIEW view_orders_summary AS
SELECT 
    c.customerNumber,
    c.customerName,
    COUNT(o.orderNumber) as total_orders
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName;

SELECT 
    customerNumber,
    customerName,
    total_orders
FROM view_orders_summary
WHERE total_orders > 3
ORDER BY total_orders DESC;