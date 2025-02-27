--bài 6 ss13
-- 1. Tạo bảng enrollments_history
CREATE TABLE enrollments_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    action VARCHAR(50),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tạo Stored Procedure đăng ký học phần
DELIMITER //

CREATE PROCEDURE enroll_student(
    IN p_student_name VARCHAR(50),
    IN p_course_name VARCHAR(100)
)
BEGIN
    -- Khai báo biến
    DECLARE v_student_id INT;
    DECLARE v_course_id INT;
    DECLARE v_available_seats INT;
    DECLARE v_is_enrolled INT;
    
    -- Bắt đầu transaction
    START TRANSACTION;
    
    -- Lấy student_id từ tên sinh viên
    SELECT student_id INTO v_student_id
    FROM students
    WHERE student_name = p_student_name;
    
    -- Nếu không tìm thấy sinh viên, thêm mới sinh viên
    IF v_student_id IS NULL THEN
        INSERT INTO students(student_name) VALUES(p_student_name);
        SET v_student_id = LAST_INSERT_ID();
    END IF;
    
    -- Lấy course_id và số chỗ trống từ tên môn học
    SELECT course_id, available_seats INTO v_course_id, v_available_seats
    FROM courses
    WHERE course_name = p_course_name;
    
    -- Nếu không tìm thấy môn học, ghi log và rollback
    IF v_course_id IS NULL THEN
        INSERT INTO enrollments_history(student_id, course_id, action)
        VALUES(v_student_id, NULL, 'FAILED');
        
        ROLLBACK;
        SELECT 'Môn học không tồn tại' AS message;
        
    ELSE
        -- Kiểm tra xem sinh viên đã đăng ký môn học này chưa
        SELECT COUNT(*) INTO v_is_enrolled
        FROM enrollments
        WHERE student_id = v_student_id AND course_id = v_course_id;
        
        IF v_is_enrolled > 0 THEN
            -- Sinh viên đã đăng ký, ghi log và rollback
            INSERT INTO enrollments_history(student_id, course_id, action)
            VALUES(v_student_id, v_course_id, 'FAILED');
            
            ROLLBACK;
            SELECT 'Sinh viên đã đăng ký môn học này' AS message;
            
        ELSE
            -- Kiểm tra số chỗ trống
            IF v_available_seats > 0 THEN
                -- Còn chỗ trống, thực hiện đăng ký
                
                -- Thêm sinh viên vào bảng enrollments
                INSERT INTO enrollments(student_id, course_id)
                VALUES(v_student_id, v_course_id);
                
                -- Giảm số chỗ trống của môn học
                UPDATE courses
                SET available_seats = available_seats - 1
                WHERE course_id = v_course_id;
                
                -- Ghi lại lịch sử đăng ký
                INSERT INTO enrollments_history(student_id, course_id, action)
                VALUES(v_student_id, v_course_id, 'REGISTERED');
                
                -- Commit transaction
                COMMIT;
                
                SELECT 'Đăng ký thành công' AS message;
                
            ELSE
                -- Hết chỗ, ghi log và rollback
                INSERT INTO enrollments_history(student_id, course_id, action)
                VALUES(v_student_id, v_course_id, 'FAILED');
                
                ROLLBACK;
                SELECT 'Đăng ký thất bại do hết chỗ' AS message;
            END IF;
        END IF;
    END IF;
    
    -- Xử lý lỗi
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        INSERT INTO enrollments_history(student_id, course_id, action)
        VALUES(v_student_id, v_course_id, 'FAILED');
        SELECT 'Lỗi hệ thống, không thể đăng ký' AS message;
    END;
END //

DELIMITER ;

-- 3. Ví dụ gọi Stored Procedure
CALL enroll_student('Nguyễn Văn An', 'Lập trình C');

-- 4. Hiển thị các bảng để kiểm chứng
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM enrollments;
SELECT * FROM enrollments_history;