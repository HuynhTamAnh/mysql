--bài 1 ss13
DELIMITER //
--Viết một Stored Procedure trong MySQL để thực hiện transaction nhằm chuyển tiền từ tài khoản này sang tài khoản khác


CREATE PROCEDURE transfer_money(
    IN from_account INT,       -- ID của tài khoản gửi tiền
    IN to_account INT,         -- ID của tài khoản nhận tiền
    IN amount DECIMAL(10,2)    -- Số tiền cần chuyển
)
BEGIN
    DECLARE current_balance DECIMAL(10,2);
    DECLARE exit_handler BOOLEAN DEFAULT FALSE;
    
    -- Tạo một transaction point để có thể rollback nếu cần
    START TRANSACTION;
    
    -- Kiểm tra số dư của tài khoản gửi
    SELECT balance INTO current_balance FROM accounts 
    WHERE account_id = from_account FOR UPDATE;
    
    -- Kiểm tra xem tài khoản gửi có đủ tiền không
    IF current_balance >= amount THEN
        -- Trừ số tiền từ tài khoản from_account
        UPDATE accounts 
        SET balance = balance - amount 
        WHERE account_id = from_account;
        
        -- Cộng số tiền vào tài khoản to_account
        UPDATE accounts 
        SET balance = balance + amount 
        WHERE account_id = to_account;
        
        -- Xác nhận giao dịch thành công
        COMMIT;
    ELSE
        -- Nếu không đủ số dư, rollback giao dịch
        ROLLBACK;
        SET exit_handler = TRUE;
        SELECT 'Insufficient balance' AS message;
    END IF;
    
    -- Kiểm tra xem cả hai tài khoản có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM accounts WHERE account_id = from_account) OR 
       NOT EXISTS (SELECT 1 FROM accounts WHERE account_id = to_account) THEN
        ROLLBACK;
        SET exit_handler = TRUE;
        SELECT 'One or both accounts do not exist' AS message;
    END IF;
    
    -- Nếu không có lỗi, ghi log giao dịch thành công
    IF NOT exit_handler THEN
        INSERT INTO transaction_logs (from_account, to_account, amount, transaction_date)
        VALUES (from_account, to_account, amount, NOW());
        
        SELECT 'Transaction completed successfully' AS message;
    END IF;
END //

DELIMITER ;