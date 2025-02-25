USE classicmodels;

CREATE INDEX idx_creditLimit ON customers(creditLimit);

EXPLAIN ANALYZE
SELECT 
    c.customerNumber,
    c.customerName,
    c.city,
    c.creditLimit,
    o.country
FROM customers c
INNER JOIN offices o
    ON c.salesRepEmployeeNumber = o.salesRepEmployeeNumber
WHERE c.creditLimit BETWEEN 50000 AND 100000
ORDER BY c.creditLimit DESC
LIMIT 5;

EXPLAIN ANALYZE
SELECT 
    c.customerNumber,
    c.customerName,
    c.city,
    c.creditLimit,
    o.country
FROM customers c
INNER JOIN offices o
    ON c.salesRepEmployeeNumber = o.salesRepEmployeeNumber
WHERE c.creditLimit BETWEEN 50000 AND 100000
ORDER BY c.creditLimit DESC
LIMIT 5;