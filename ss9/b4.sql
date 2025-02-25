--bài4
USE classicmodels;


EXPLAIN ANALYZE
SELECT orderNumber, orderDate, status
FROM orders 
WHERE YEAR(orderDate) = 2003 
AND status = 'Shipped';

CREATE INDEX idx_orderDate_status ON orders(orderDate, status);

EXPLAIN ANALYZE
SELECT orderNumber, orderDate, status
FROM orders 
WHERE YEAR(orderDate) = 2003 
AND status = 'Shipped';

EXPLAIN ANALYZE
SELECT customerNumber, customerName, phone
FROM customers 
WHERE phone = '203-555-2570';

CREATE UNIQUE INDEX idx_customerNumber ON customers(customerNumber);
CREATE UNIQUE INDEX idx_phone ON customers(phone);

EXPLAIN ANALYZE
SELECT customerNumber, customerName, phone
FROM customers 
WHERE phone = '203-555-2570';

DROP INDEX idx_orderDate_status ON orders;
DROP INDEX idx_customerNumber ON customers;
DROP INDEX idx_phone ON customers;