--bài1
-- Tạo và sử dụng CSDL ss9
CREATE DATABASE ss9;
USE s9;
-- Tạo bảng employee
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10, 2) NOT NULL,
    manager_id INT NULL
);
-- Thêm dữ liệu vào bảng
INSERT INTO employees (name, department, salary, manager_id) VALUES
('Alice', 'Sales', 6000, NULL),         
('Bob', 'Marketing', 7000, NULL),     
('Charlie', 'Sales', 5500, 1),         
('David', 'Marketing', 5800, 2),       
('Eva', 'HR', 5000, 3),                
('Frank', 'IT', 4500, 1),              
('Grace', 'Sales', 7000, 3),           
('Hannah', 'Marketing', 5200, 2),     
('Ian', 'IT', 6800, 3),               
('Jack', 'Finance', 3000, 1);    

create view view_high_salary_employees as
select employee_id, name, salary
from employees
where salary >5000

INSERT INTO employees (employee_id, name, salary)
VALUES (11,'JOHN DOE', 5500)

SELECT * FROM  view_high_salary_employees;

DELETE FROM employees
WHERE employee_id=11;

SELECT * FROM  view_high_salary_employees;
