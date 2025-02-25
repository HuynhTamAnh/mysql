--bài 1 ss11
CREATE VIEW EmployeeBranch AS
SELECT 
    e.EmployeeID,
    e.FullName,
    e.Position,
    e.Salary,
    b.BranchName,
    b.Location
FROM 
    Employees e
JOIN 
    Branches b ON e.BranchID = b.BranchID;

CREATE VIEW HighSalaryEmployees AS
SELECT 
    EmployeeID,
    FullName,
    Position,
    Salary
FROM 
    Employees
WHERE 
    Salary >= 15000000
WITH CHECK OPTION;

SELECT * FROM EmployeeBranch;

SELECT * FROM HighSalaryEmployees;

ALTER VIEW EmployeeBranch AS
SELECT 
    e.EmployeeID,
    e.FullName,
    e.Position,
    e.Salary,
    b.BranchName,
    b.Location,
    e.PhoneNumber
FROM 
    Employees e
JOIN 
    Branches b ON e.BranchID = b.BranchID;

DELETE FROM EmployeeBranch
WHERE BranchName = 'Chi nhánh Hà Nội';

SELECT * FROM Employees;