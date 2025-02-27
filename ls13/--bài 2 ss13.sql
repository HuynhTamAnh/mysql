--bài 2 ss13
DELIMITER //
--xử lý đơn hàng
CREATE PROCEDURE create_order(
    IN p_product_id INT,     -- ID của sản phẩm cần đặt hàng
    IN p_quantity INT,       -- Số lượng sản phẩm cần mua
    OUT p_order_id INT,      -- ID của đơn hàng mới tạo
    OUT p_status VARCHAR(50) -- Trạng thái kết quả của thao tác
)
BEGIN
    DECLARE current_stock INT;          -- Biến lưu số lượng tồn kho hiện tại
    DECLARE product_price DECIMAL(10,2); -- Biến lưu giá sản phẩm
    DECLARE total_amount DECIMAL(10,2);  -- Biến lưu tổng tiền đơn hàng
    
    -- Khai báo handler để xử lý ngoại lệ SQL
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;  -- Hoàn tác giao dịch nếu có lỗi
        SET p_status = 'Error: Giao dịch thất bại';
    END;
    
    -- Bắt đầu transaction
    START TRANSACTION;
    
    -- Kiểm tra sản phẩm có tồn tại không và lấy thông tin tồn kho, giá
    SELECT stock, price INTO current_stock, product_price 
    FROM products 
    WHERE product_id = p_product_id;
    
    -- Kiểm tra nếu sản phẩm không tồn tại
    IF current_stock IS NULL THEN
        SET p_status = 'Error: Không tìm thấy sản phẩm';
        ROLLBACK;  -- Hoàn tác giao dịch
    -- Kiểm tra nếu số lượng tồn kho không đủ
    ELSEIF current_stock < p_quantity THEN
        SET p_status = 'Error: Số lượng tồn kho không đủ';
        ROLLBACK;  -- Hoàn tác giao dịch
    ELSE
        -- Tính tổng tiền đơn hàng
        SET total_amount = product_price * p_quantity;
        
        -- Tạo đơn hàng mới trong bảng orders
        INSERT INTO orders (product_id, quantity, total_price) 
        VALUES (p_product_id, p_quantity, total_amount);
        
        -- Lấy ID của đơn hàng vừa tạo
        SET p_order_id = LAST_INSERT_ID();
        
        -- Cập nhật số lượng tồn kho của sản phẩm
        UPDATE products 
        SET stock = stock - p_quantity 
        WHERE product_id = p_product_id;
        
        -- Xác nhận giao dịch (commit)
        COMMIT;
        
        SET p_status = 'Success: Đơn hàng đã được tạo thành công';
    END IF;
    
END //

DELIMITER ;

--check
CALL create_order(1, 5, @order_id, @status);
SELECT @order_id, @status;