--bài5 ss13
-- 1. Tạo bảng transaction_log để theo dõi lịch sử giao dịch
CREATE TABLE transaction_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    log_message TEXT NOT NULL,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Thêm cột last_pay_date vào bảng employees
ALTER TABLE employees ADD last_pay_date DATE;

-- 3. Tạo Stored Procedure cho việc chuyển lương
DELIMITER //

CREATE PROCEDURE transfer_salary(IN p_emp_id INT)
BEGIN
    -- Khai báo biến
    DECLARE employee_salary DECIMAL(10,2);
    DECLARE company_balance DECIMAL(15,2);
    DECLARE employee_exists INT;
    
    -- Bắt đầu giao dịch
    START TRANSACTION;
    
    -- Kiểm tra số dư quỹ công ty
    SELECT balance INTO company_balance FROM company_funds LIMIT 1;
    
    -- Kiểm tra sự tồn tại của nhân viên
    SELECT COUNT(*), salary INTO employee_exists, employee_salary 
    FROM employees 
    WHERE emp_id = p_emp_id;
    
    -- Kiểm tra nếu công ty có đủ tiền
    IF (company_balance < employee_salary) THEN
        -- Ghi log lỗi và rollback nếu không đủ tiền
        INSERT INTO transaction_log (log_message) VALUES ('Quỹ không đủ tiền');
        ROLLBACK;
    -- Kiểm tra nếu nhân viên tồn tại
    ELSEIF (employee_exists = 0) THEN
        -- Ghi log lỗi và rollback nếu nhân viên không tồn tại
        INSERT INTO transaction_log (log_message) VALUES ('Nhân viên không tồn tại');
        ROLLBACK;
    ELSE
        -- Thực hiện chuyển lương
        -- 1. Trừ số tiền lương từ quỹ công ty
        UPDATE company_funds SET balance = balance - employee_salary;
        
        -- 2. Thêm bản ghi vào bảng payroll
        INSERT INTO payroll (emp_id, salary, pay_date) 
        VALUES (p_emp_id, employee_salary, CURDATE());
        
        -- 3. Cập nhật ngày trả lương gần nhất cho nhân viên
        UPDATE employees SET last_pay_date = CURDATE() 
        WHERE emp_id = p_emp_id;
        
        -- 4. Ghi log giao dịch thành công
        INSERT INTO transaction_log (log_message) 
        VALUES (CONCAT('Chuyển lương cho nhân viên ', p_emp_id, ' thành công'));
        
        -- 5. Xác nhận giao dịch
        COMMIT;
    END IF;
    
    -- Nếu có bất kỳ lỗi nào xảy ra trong quá trình thực hiện, rollback
    -- Lưu ý: Điều này sẽ được xử lý bởi các câu lệnh ROLLBACK ở trên,
    -- nhưng thêm vào như một biện pháp an toàn bổ sung
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO transaction_log (log_message) VALUES ('Lỗi trong quá trình chuyển lương');
        ROLLBACK;
    END;
END //

DELIMITER ;

-- 4. Ví dụ gọi stored procedure (cho nhân viên có ID là 1)
CALL transfer_salary(1);