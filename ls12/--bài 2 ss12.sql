--bài 2 ss12
--tạo table price_changes
CREATE TABLE price_changes (
    change_id INT AUTO_INCREMENT PRIMARY KEY,
    product VARCHAR(100) NOT NULL,
    old_price DECIMAL(10, 2) NOT NULL,
    new_price DECIMAL(10, 2) NOT NULL
);

-- Tạo trigger AFTER UPDATE
DELIMITER //
CREATE TRIGGER after_update_products
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    -- Kiểm tra nếu giá đã thay đổi
    IF OLD.price != NEW.price THEN
        -- Ghi lại thông tin thay đổi giá vào bảng price_changes
        INSERT INTO price_changes (product, old_price, new_price)
        VALUES (NEW.product_name, OLD.price, NEW.price);
    END IF;
END //
DELIMITER ;

--update
-- Cập nhật giá của sản phẩm 'Laptop' thành 1400.00
UPDATE products 
SET price = 1400.00
WHERE product_name = 'Laptop';

-- Cập nhật giá của sản phẩm 'Smartphone' thành 800.00
UPDATE products 
SET price = 800.00
WHERE product_name = 'Smartphone';

--kiểm tra dữ liệu
SELECT * FROM price_changes;