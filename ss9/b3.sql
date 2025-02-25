--bài3
EXPLAIN ANALYZE
SELECT * FROM customers 
WHERE country = 'Germany';

CREATE INDEX idx_country ON customers(country);

EXPLAIN ANALYZE
SELECT * FROM customers 
WHERE country = 'Germany';

DROP INDEX idx_country ON customers;