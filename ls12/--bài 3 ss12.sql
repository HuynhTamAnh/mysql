--bài 3 ss12
-- Tạo bảng deleted_orders
CREATE TABLE deleted_orders (
    deleted_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    product VARCHAR(100) NOT NULL,
    order_date DATE NOT NULL,
    deleted_at DATETIME NOT NULL
);

-- Tạo trigger AFTER DELETE
DELIMITER //
CREATE TRIGGER after_delete_orders
AFTER DELETE ON orders
FOR EACH ROW
BEGIN
    INSERT INTO deleted_orders (
        order_id,
        customer_name,
        product,
        order_date,
        deleted_at
    )
    VALUES (
        OLD.id, -- Giả sử trường ID trong bảng orders là 'id'
        OLD.customer_name,
        OLD.product,
        OLD.order_date,
        NOW()
    );
END //
DELIMITER ;

--delete
-- Xóa đơn hàng có order_id = 4
DELETE FROM orders WHERE order_id = 4;

-- Xóa đơn hàng có order_id = 5
DELETE FROM orders WHERE order_id = 5;

--hiển thị lại table
SELECT * FROM deleted_orders;