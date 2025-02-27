--bài 4 ss13
--Viết một Stored Procedure trong MySQL để thực hiện transaction nhằm đăng ký học phần cho một sinh viên vào một môn học bất kỳ
DELIMITER //

CREATE PROCEDURE enroll_student(
    IN p_student_name VARCHAR(50),     -- Tên của sinh viên muốn đăng ký
    IN p_course_name VARCHAR(100),     -- Tên môn học mà sinh viên muốn đăng ký
    OUT p_status VARCHAR(100)          -- Trạng thái kết quả của thao tác
)
BEGIN
    -- Khai báo các biến cần thiết
    DECLARE student_id INT;            -- ID của sinh viên
    DECLARE course_id INT;             -- ID của môn học
    DECLARE seats INT;                 -- Số chỗ trống hiện có
    
    -- Khai báo handler để xử lý ngoại lệ SQL
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;  -- Hoàn tác giao dịch nếu có lỗi
        SET p_status = 'Error: Giao dịch thất bại do lỗi hệ thống';
    END;
    
    -- Bắt đầu giao dịch (transaction)
    START TRANSACTION;
    
    -- Kiểm tra sinh viên có tồn tại không
    SELECT student_id INTO student_id
    FROM students
    WHERE student_name = p_student_name;
    
    -- Nếu sinh viên không tồn tại
    IF student_id IS NULL THEN
        SET p_status = 'Error: Không tìm thấy sinh viên với tên đã cung cấp';
        ROLLBACK;
    ELSE
        -- Kiểm tra môn học có tồn tại không và lấy số chỗ trống
        SELECT course_id, available_seats INTO course_id, seats
        FROM courses
        WHERE course_name = p_course_name;
        
        -- Nếu môn học không tồn tại
        IF course_id IS NULL THEN
            SET p_status = 'Error: Không tìm thấy môn học với tên đã cung cấp';
            ROLLBACK;
        ELSE
            -- Kiểm tra xem sinh viên đã đăng ký môn học này chưa
            IF EXISTS (SELECT 1 FROM enrollments WHERE student_id = student_id AND course_id = course_id) THEN
                SET p_status = 'Error: Sinh viên đã đăng ký môn học này trước đó';
                ROLLBACK;
            ELSE
                -- Kiểm tra còn chỗ trống không
                IF seats > 0 THEN
                    -- Thêm sinh viên vào bảng enrollments
                    INSERT INTO enrollments (student_id, course_id)
                    VALUES (student_id, course_id);
                    
                    -- Giảm số chỗ trống của môn học đi 1
                    UPDATE courses
                    SET available_seats = available_seats - 1
                    WHERE course_id = course_id;
                    
                    -- Xác nhận giao dịch (commit)
                    COMMIT;
                    
                    SET p_status = CONCAT('Success: Đã đăng ký thành công môn học "', p_course_name, 
                                         '" cho sinh viên "', p_student_name, '"');
                ELSE
                    -- Nếu không còn chỗ trống
                    SET p_status = 'Error: Môn học đã hết chỗ trống';
                    ROLLBACK;  -- Hoàn tác giao dịch
                END IF;
            END IF;
        END IF;
    END IF;
    
END //

DELIMITER ;

--gọi chạy thử
CALL enroll_student('Nguyễn Văn An', 'Lập trình C', @status);
SELECT @status;