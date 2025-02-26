--bài 1 ss12
use ss12;
DELIMITER //
CREATE TRIGGER before_insert_orders
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    -- Nếu quantity là NULL hoặc nhỏ hơn 1, tự động gán giá trị là 1.
    IF (NEW.quantity IS NULL OR NEW.quantity < 1) THEN
        SET NEW.quantity = 1;
    END IF;   
    
    -- Kiểm tra nếu order_date không được cung cấp (NULL), gán là ngày hiện tại
    IF (NEW.order_date IS NULL) THEN
        SET NEW.order_date = CURRENT_DATE();
    END IF;
END //
DELIMITER ;

-- xoá
DROP TRIGGER before_insert_orders;
