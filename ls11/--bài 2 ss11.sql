--bài 2 ss11
CREATE INDEX idx_phone_number ON Customers(PhoneNumber);

-- Kiểm tra hiệu suất truy vấn
EXPLAIN SELECT * FROM Customers WHERE PhoneNumber = '0901234567';

CREATE INDEX idx_branch_salary ON Employees(BranchID, Salary);

-- Kiểm tra xem index có được sử dụng kh
EXPLAIN SELECT * FROM Employees WHERE BranchID = 1 AND Salary > 20000000;

CREATE UNIQUE INDEX idx_account_customer ON Accounts(AccountID, CustomerID);

-- Hiển thị danh sách Index trong bảng Customers
SHOW INDEX FROM Customers;

-- Hiển thị danh sách Index trong bảng Employees
SHOW INDEX FROM Employees;

-- Hiển thị danh sách Index trong bảng Accounts
SHOW INDEX FROM Accounts;

-- Xóa index trong bảng Customers
DROP INDEX idx_phone_number ON Customers;

-- Xóa index trong bảng Employees
DROP INDEX idx_branch_salary ON Employees;

-- Xóa index trong bảng Accounts
DROP INDEX idx_account_customer ON Accounts;