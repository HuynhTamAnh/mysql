--bài3 ss13
--Viết một Stored Procedure trong MySQL để thực hiện transaction nhằm chuyển lương cho nhân viên từ quỹ công ty
DELIMITER //

CREATE PROCEDURE pay_salary(
    IN p_emp_id INT,          -- ID của nhân viên nhận lương
    OUT p_status VARCHAR(100) -- Trạng thái kết quả của thao tác
)
BEGIN
    -- Khai báo các biến cần thiết
    DECLARE employee_salary DECIMAL(10,2);       -- Lưu lương của nhân viên
    DECLARE current_fund_balance DECIMAL(15,2);  -- Lưu số dư hiện tại của quỹ công ty
    DECLARE bank_system_status BOOLEAN DEFAULT TRUE; -- Giả lập trạng thái hệ thống ngân hàng
    
    -- Khai báo handler để xử lý ngoại lệ SQL
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;  -- Hoàn tác giao dịch nếu có lỗi
        SET p_status = 'Error: Giao dịch thất bại do lỗi hệ thống';
    END;
    
    -- Bắt đầu giao dịch (transaction)
    START TRANSACTION;
    
    -- Kiểm tra nhân viên có tồn tại không và lấy thông tin lương
    SELECT salary INTO employee_salary
    FROM employees
    WHERE emp_id = p_emp_id;
    
    -- Kiểm tra nếu nhân viên không tồn tại
    IF employee_salary IS NULL THEN
        SET p_status = 'Error: Không tìm thấy nhân viên với ID đã cung cấp';
        ROLLBACK;  -- Hoàn tác giao dịch
    ELSE
        -- Kiểm tra số dư của quỹ công ty
        SELECT balance INTO current_fund_balance
        FROM company_funds
        WHERE fund_id = 1; -- Giả sử quỹ công ty có ID = 1
        
        -- Kiểm tra nếu quỹ không đủ tiền để trả lương
        IF current_fund_balance < employee_salary THEN
            SET p_status = 'Error: Số dư quỹ công ty không đủ để trả lương';
            ROLLBACK;  -- Hoàn tác giao dịch theo yêu cầu
        ELSE
            -- Kiểm tra trạng thái hệ thống ngân hàng (giả lập, trong thực tế sẽ gọi API ngân hàng)
            -- Giả sử bank_system_status = TRUE là hệ thống hoạt động bình thường
            IF bank_system_status = FALSE THEN
                SET p_status = 'Error: Hệ thống ngân hàng gặp lỗi';
                ROLLBACK;  -- Hoàn tác giao dịch để tiền hoàn về quỹ công ty
            ELSE
                -- Trừ lương của nhân viên khỏi quỹ công ty
                UPDATE company_funds
                SET balance = balance - employee_salary
                WHERE fund_id = 1;
                
                -- Thêm bản ghi vào bảng payroll để xác nhận lương đã được trả
                INSERT INTO payroll (emp_id, salary, pay_date)
                VALUES (p_emp_id, employee_salary, CURDATE());
                
                -- Xác nhận giao dịch (commit)
                COMMIT;
                
                SET p_status = CONCAT('Success: Đã chuyển lương thành công cho nhân viên ID ', p_emp_id, 
                                     ' với số tiền ', employee_salary);
            END IF;
        END IF;
    END IF;
    
END //

DELIMITER ;