--bài 4 ss11
DELIMITER //
CREATE PROCEDURE UpdateSalaryByID(IN emp_id INT, IN new_salary DECIMAL(10,2))
BEGIN
    DECLARE current_salary DECIMAL(10,2);
    
    -- Lấy lương hiện tại
    SELECT Salary INTO current_salary 
    FROM Employees 
    WHERE EmployeeID = emp_id;
    
    -- Kiểm tra nếu lương nhỏ hơn 20 triệu
    IF current_salary < 20000000 THEN
        -- Tăng 10%
        UPDATE Employees 
        SET Salary = current_salary * 1.1 
        WHERE EmployeeID = emp_id;
    ELSE
        -- Tăng 5%
        UPDATE Employees 
        SET Salary = current_salary * 1.05 
        WHERE EmployeeID = emp_id;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetLoanAmountByCustomerID(IN cust_id INT, OUT total_loan DECIMAL(15,2))
BEGIN
    -- Khởi tạo tổng số tiền vay
    SET total_loan = 0;
    
    -- Tính tổng số tiền vay
    SELECT COALESCE(SUM(LoanAmount), 0) INTO total_loan
    FROM Loans
    WHERE CustomerID = cust_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteAccountIfLowBalance(IN acc_id INT)
BEGIN
    DECLARE acc_balance DECIMAL(15,2);
    
    -- Lấy số dư tài khoản
    SELECT Balance INTO acc_balance
    FROM Accounts
    WHERE AccountID = acc_id;
    
    -- Kiểm tra nếu số dư nhỏ hơn 1 triệu
    IF acc_balance < 1000000 THEN
        -- Xóa tài khoản
        DELETE FROM Accounts WHERE AccountID = acc_id;
        SELECT 'Xóa tài khoản thành công' AS message;
    ELSE
        SELECT 'Không thể xóa tài khoản. Số dư từ 1 triệu trở lên' AS message;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE TransferMoney(IN from_account INT, IN to_account INT, IN amount DECIMAL(15,2))
BEGIN
    DECLARE from_balance DECIMAL(15,2);
    
    -- Bắt đầu giao dịch
    START TRANSACTION;
    
    -- Lấy số dư từ tài khoản gửi
    SELECT Balance INTO from_balance
    FROM Accounts
    WHERE AccountID = from_account;
    
    -- Kiểm tra nếu tài khoản gửi có đủ số dư
    IF from_balance >= amount THEN
        -- Trừ tiền từ tài khoản gửi
        UPDATE Accounts
        SET Balance = Balance - amount
        WHERE AccountID = from_account;
        
        -- Cộng tiền vào tài khoản nhận
        UPDATE Accounts
        SET Balance = Balance + amount
        WHERE AccountID = to_account;
        
        -- Thêm ghi chép giao dịch
        INSERT INTO Transactions (AccountID, TransactionType, Amount)
        VALUES 
            (from_account, 'Transfer', amount),
            (to_account, 'Deposit', amount);
        
        COMMIT;
        
        -- Hiển thị số dư cuối cùng
        SELECT 'Chuyển tiền thành công' AS message;
        SELECT AccountID, Balance AS 'Số dư mới'
        FROM Accounts
        WHERE AccountID IN (from_account, to_account);
    ELSE
        -- Không đủ tiền, đặt số tiền chuyển = 0 và không thực hiện giao dịch
        ROLLBACK;
        SELECT 'Chuyển tiền thất bại. Không đủ số dư.' AS message;
    END IF;
END //
DELIMITER ;


CALL UpdateSalaryByID(4, 18000000);

CALL GetLoanAmountByCustomerID(1, @total_loan);
SELECT @total_loan AS 'Tổng số tiền vay';

CALL DeleteAccountIfLowBalance(8);

CALL TransferMoney(1, 3, 2000000);