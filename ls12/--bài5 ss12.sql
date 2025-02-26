--bài5 ss12
-- Tạo bảng projects
CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    budget DECIMAL(15, 2) NOT NULL,
    total_salary DECIMAL(15, 2) DEFAULT 0
);

-- Tạo bảng workers
CREATE TABLE workers (
    worker_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    project_id INT,
    salary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

--thêm dữ lieu mau
INSERT INTO projects (name, budget) VALUES
    ('Bridge Construction', 10000.00),
    ('Road Expansion', 15000.00),
    ('Office Renovation', 8000.00);

--Tạo 2 trigger để cập nhật tổng lương
-- Trigger AFTER INSERT
DELIMITER //
CREATE TRIGGER after_insert_worker
AFTER INSERT ON workers
FOR EACH ROW
BEGIN
    -- Cộng lương của công nhân vào total_salary của dự án
    UPDATE projects
    SET total_salary = total_salary + NEW.salary
    WHERE project_id = NEW.project_id;
END //
DELIMITER ;

-- Trigger AFTER DELETE
DELIMITER //
CREATE TRIGGER after_delete_worker
AFTER DELETE ON workers
FOR EACH ROW
BEGIN
    -- Trừ lương của công nhân khỏi total_salary của dự án
    UPDATE projects
    SET total_salary = total_salary - OLD.salary
    WHERE project_id = OLD.project_id;
END //
DELIMITER ;

--them du lieu mau
INSERT INTO workers (name, project_id, salary) VALUES
    ('John', 1, 2500.00),
    ('Alice', 1, 3000.00),
    ('Bob', 2, 2000.00),
    ('Eve', 2, 3500.00),
    ('Charlie', 3, 1500.00);

--xoa thu cong nhan
DELETE FROM workers WHERE name = 'John';

-- Hiển thị bảng projects để kiểm tra
SELECT * FROM projects;