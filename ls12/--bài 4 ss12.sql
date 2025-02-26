--bài 4 ss12
--Tạo bảng order_warnings
CREATE TABLE order_warnings (
    warning_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    warning_message VARCHAR(255) NOT NULL
);
-- Tạo trigger AFTER INSERT
DELIMITER //
CREATE TRIGGER after_insert_orders
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE total_value DECIMAL(10, 2);
    
    -- Tính tổng giá trị đơn hàng
    SET total_value = NEW.quantity * NEW.price;
    
    -- Kiểm tra nếu tổng giá trị vượt quá ngưỡng 5000
    IF total_value > 5000 THEN
        -- Ghi cảnh báo vào bảng order_warnings
        INSERT INTO order_warnings (order_id, warning_message)
        VALUES (NEW.order_id, 'Total value exceeds limit');
    END IF;
END //
DELIMITER ;

-- Thực hiện thao tác INSERT
-- Thêm đơn hàng mới: ('Mark', 'Monitor', 2, 3000.00, '2023-08-01')
INSERT INTO orders (customer_name, product, quantity, price, order_date)
VALUES ('Mark', 'Monitor', 2, 3000.00, '2023-08-01');

-- Thêm đơn hàng mới: ('Paul', 'Mouse', 1, 50.00, '2023-08-02')
INSERT INTO orders (customer_name, product, quantity, price, order_date)
VALUES ('Paul', 'Mouse', 1, 50.00, '2023-08-02');

--kiểm tra bang
SELECT * FROM order_warnings;