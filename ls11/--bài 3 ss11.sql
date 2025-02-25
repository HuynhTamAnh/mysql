--bài 3 ss11
DELIMITER //

CREATE PROCEDURE GetCustomerByPhone(IN p_PhoneNumber VARCHAR(20))
BEGIN
    SELECT 
        CustomerID, 
        FullName, 
        DateOfBirth, 
        Address, 
        Email
    FROM 
        Customers
    WHERE 
        PhoneNumber = p_PhoneNumber;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetTotalBalance(IN p_CustomerID INT, OUT p_TotalBalance DECIMAL(15,2))
BEGIN
    SELECT 
        SUM(Balance) INTO p_TotalBalance
    FROM 
        Accounts
    WHERE 
        CustomerID = p_CustomerID;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE IncreaseEmployeeSalary(IN p_EmployeeID INT, INOUT p_Salary DECIMAL(15,2))
BEGIN
    -- Lấy mức lương hiện tại
    SELECT Salary INTO p_Salary
    FROM Employees
    WHERE EmployeeID = p_EmployeeID;
    
    -- Tính toán mức lương mới (tăng 10%)
    SET p_Salary = p_Salary * 1.1;
    
    -- Cập nhật mức lương mới vào bảng Employees
    UPDATE Employees
    SET Salary = p_Salary
    WHERE EmployeeID = p_EmployeeID;
END //

DELIMITER ;

-- Gọi thủ tục GetCustomerByPhone
CALL GetCustomerByPhone('0901234567');

-- Gọi thủ tục GetTotalBalance
SET @total_balance = 0;
CALL GetTotalBalance(1, @total_balance);
SELECT @total_balance AS 'Tổng số dư';

-- Gọi thủ tục IncreaseEmployeeSalary
SET @current_salary = 0;
CALL IncreaseEmployeeSalary(4, @current_salary);
SELECT @current_salary AS 'Mức lương mới';

DROP PROCEDURE IF EXISTS GetCustomerByPhone;
DROP PROCEDURE IF EXISTS GetTotalBalance;
DROP PROCEDURE IF EXISTS IncreaseEmployeeSalary;