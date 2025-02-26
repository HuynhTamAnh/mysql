--bài6 ss12
-- 1. Sử dụng lại bảng projects và bảng workers để thao tác.

-- 2. Tạo bảng budget_warnings để lưu thông tin cảnh báo ngân sách
CREATE TABLE budget_warnings (
    warning_id INT AUTO_INCREMENT PRIMARY KEY,  -- Mã cảnh báo (Warning ID).
    project_id INT NOT NULL,                    -- Mã dự án (Project ID).
    warning_message VARCHAR(255) NOT NULL,      -- Nội dung cảnh báo (Warning message).
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- 3. Tạo trigger AFTER UPDATE trên bảng projects
DELIMITER //
CREATE TRIGGER check_budget_after_update
AFTER UPDATE ON projects
FOR EACH ROW
BEGIN
    -- Kiểm tra nếu total_salary > budget
    IF NEW.total_salary > NEW.budget THEN
        -- Kiểm tra nếu dự án đã có cảnh báo trước đó, không ghi thêm cảnh báo trùng lặp
        IF NOT EXISTS (SELECT 1 FROM budget_warnings 
                      WHERE project_id = NEW.project_id 
                      AND warning_message = 'Budget exceeded due to high salary') THEN
            -- Ghi cảnh báo vào bảng budget_warnings
            INSERT INTO budget_warnings (project_id, warning_message)
            VALUES (NEW.project_id, 'Budget exceeded due to high salary');
        END IF;
    END IF;
END //
DELIMITER ;

-- 4. Tạo view ProjectOverview để hiển thị thông tin chi tiết về dự án
CREATE VIEW ProjectOverview AS
SELECT 
    p.project_id,       -- Mã dự án (Project ID).
    p.project_name,     -- Tên dự án (Project Name).
    p.budget,           -- Ngân sách (Budget).
    p.total_salary,     -- Tổng lương công nhân (Total Salary).
    bw.warning_message  -- Cảnh báo ngân sách (Warning Message).
FROM 
    projects p
LEFT JOIN 
    budget_warnings bw ON p.project_id = bw.project_id;

-- 5. Tiến hành thêm nhân viên sau
INSERT INTO workers (name, project_id, salary) VALUES ('Michael', 1, 6000.00);
INSERT INTO workers (name, project_id, salary) VALUES ('Sarah', 2, 10000.00);
INSERT INTO workers (name, project_id, salary) VALUES ('David', 3, 1000.00);

-- 6. Tạo trigger để cập nhật total_salary trong bảng projects khi thêm nhân viên mới
DELIMITER //
CREATE TRIGGER update_total_salary_after_insert
AFTER INSERT ON workers
FOR EACH ROW
BEGIN
    -- Cập nhật total_salary trong bảng projects
    UPDATE projects
    SET total_salary = (
        SELECT SUM(salary)
        FROM workers
        WHERE project_id = NEW.project_id
    )
    WHERE project_id = NEW.project_id;
END //
DELIMITER ;

-- Tạo trigger khi thông tin nhân viên được cập nhật
CREATE TRIGGER update_total_salary_after_update
AFTER UPDATE ON workers
FOR EACH ROW
BEGIN
    -- Nếu nhân viên được chuyển dự án, cập nhật cả dự án cũ và mới
    IF OLD.project_id != NEW.project_id THEN
        -- Cập nhật dự án cũ
        UPDATE projects
        SET total_salary = (
            SELECT SUM(salary)
            FROM workers
            WHERE project_id = OLD.project_id
        )
        WHERE project_id = OLD.project_id;
    END IF;
    
    -- Cập nhật dự án hiện tại
    UPDATE projects
    SET total_salary = (
        SELECT SUM(salary)
        FROM workers
        WHERE project_id = NEW.project_id
    )
    WHERE project_id = NEW.project_id;
END //
DELIMITER ;

-- Tạo trigger khi nhân viên bị xóa
CREATE TRIGGER update_total_salary_after_delete
AFTER DELETE ON workers
FOR EACH ROW
BEGIN
    -- Cập nhật total_salary trong bảng projects
    UPDATE projects
    SET total_salary = (
        SELECT SUM(salary)
        FROM workers
        WHERE project_id = OLD.project_id
    )
    WHERE project_id = OLD.project_id;
END //
DELIMITER ;

-- Các câu lệnh mẫu để kiểm tra chức năng

-- Hiển thị bảng budget_warnings để kiểm chứng
SELECT * FROM budget_warnings;

-- Xem thông tin dự án sử dụng view ProjectOverview
SELECT * FROM ProjectOverview;