--P2
--cau1
CREATE DATABASE Cuoi_ki;
USE Cuoi_ki;
-- Create Customer table
CREATE TABLE Customer (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_full_name VARCHAR(150) NOT NULL,
    customer_email VARCHAR(255) UNIQUE,
    customer_address VARCHAR(255) NOT NULL,
    customer_phone CHAR(15) NOT NULL UNIQUE
);

-- Create Room table
CREATE TABLE Room (
    room_id VARCHAR(10) PRIMARY KEY,
    room_type ENUM('single', 'double', 'suite') NOT NULL,
    room_price DECIMAL(10, 2) NOT NULL,
    room_status ENUM('Available', 'Booked') NOT NULL,
    room_area INT NOT NULL
);

-- Create Booking table
CREATE TABLE Booking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id VARCHAR(10) NOT NULL,
    room_id VARCHAR(10) NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (room_id) REFERENCES Room(room_id),
    CONSTRAINT check_total_amount CHECK (total_amount > 0)
);

-- Create Payment table
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_date DATE NOT NULL,
    payment_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- them room_type trong Room
ALTER TABLE Room
ADD COLUMN room_type ENUM ('single', 'double','suite'),

--them customer_phone vào customer
ALTER TABLE Customer
ADD COLUMN customer_phone CHAR(15) NOT NULL UNIQUE,

--them rang buoc cho total_amount trong booking
ALTER TABLE Booking
MODIFY COLUMN total_amount >=0

-- p3
-- 1 them du lieu mau
INSERT INTO Customer (customer_id, customer_full_name, customer_email, customer_phone, customer_address) VALUES
('C001', 'Nguyen Anh Tu', 'tu.nguyen@example.com', '0912345678', 'Hanoi, Vietnam'),
('C002', 'Tran Thi Mai', 'mai.tran@example.com', '0923456789', 'Ho Chi Minh, Vietnam'),
('C003', 'Le Minh Hoang', 'hoang.le@example.com', '0934567890', 'Danang, Vietnam'),
('C004', 'Pham Hoang Nam', 'nam.pham@example.com', '0945678901', 'Hue, Vietnam'),
('C005', 'Vu Minh Thu', 'thu.vu@example.com', '0956789012', 'Hai Phong, Vietnam'),
('C006', 'Nguyen Thi Lan', 'lan.nguyen@example.com', '0967890123', 'Quang Ninh, Vietnam'),
('C007', 'Bui Minh Tuan', 'tuan.bui@example.com', '0978901234', 'Bac Giang, Vietnam'),
('C008', 'Pham Quang Hieu', 'hieu.pham@example.com', '0989012345', 'Quang Nam, Vietnam'),
('C009', 'Le Thi Lan', 'lan.le@example.com', '0990123456', 'Da Lat, Vietnam'),
('C010', 'Nguyen Thi Mai', 'mai.nguyen@example.com', '0901234567', 'Can Tho, Vietnam');

-- Room
INSERT INTO Room (room_id, room_type, room_price, room_status, room_area) VALUES
('R001', 'single', 100.0, 'Available', 25),
('R002', 'double', 150.0, 'Booked', 40),
('R003', 'suite', 250.0, 'Available', 60),
('R004', 'single', 120.0, 'Booked', 30),
('R005', 'double', 160.0, 'Available', 35);

--Booking
INSERT INTO Booking (booking_id, customer_id, room_id, check_in_date, check_out_date, total_amount) VALUES
(1, 'C001', 'R001', '2025-03-01', '2025-03-05', 400.0),
(2, 'C002', 'R002', '2025-03-02', '2025-03-06', 600.0),
(3, 'C003', 'R003', '2025-03-03', '2025-03-07', 1000.0),
(4, 'C004', 'R004', '2025-03-04', '2025-03-08', 480.0),
(5, 'C005', 'R005', '2025-03-05', '2025-03-09', 800.0),
(6, 'C006', 'R001', '2025-03-06', '2025-03-10', 400.0),
(7, 'C007', 'R002', '2025-03-07', '2025-03-11', 600.0),
(8, 'C008', 'R003', '2025-03-08', '2025-03-12', 1000.0),
(9, 'C009', 'R004', '2025-03-09', '2025-03-13', 480.0),
(10, 'C010', 'R005', '2025-03-10', '2025-03-14', 800.0);

--Payment
INSERT INTO Payment (payment_id, booking_id, payment_method, payment_date, payment_amount) VALUES
(1, 1, 'Cash', '2025-03-05', 400.0),
(2, 2, 'Credit Card', '2025-03-06', 600.0),
(3, 3, 'Bank Transfer', '2025-03-07', 1000.0),
(4, 4, 'Cash', '2025-03-08', 480.0),
(5, 5, 'Credit Card', '2025-03-09', 800.0),
(6, 6, 'Bank Transfer', '2025-03-10', 400.0),
(7, 7, 'Cash', '2025-03-11', 600.0),
(8, 8, 'Credit Card', '2025-03-12', 1000.0),
(9, 9, 'Bank Transfer', '2025-03-13', 480.0),
(10, 10, 'Cash', '2025-03-14', 800.0),
(11, 1, 'Credit Card', '2025-03-15', 400.0),
(12, 2, 'Bank Transfer', '2025-03-16', 600.0),
(13, 3, 'Cash', '2025-03-17', 1000.0),
(14, 4, 'Credit Card', '2025-03-18', 480.0),
(15, 5, 'Bank Transfer', '2025-03-19', 800.0),
(16, 6, 'Cash', '2025-03-20', 400.0),
(17, 7, 'Credit Card', '2025-03-21', 600.0),
(18, 8, 'Bank Transfer', '2025-03-22', 1000.0),
(19, 9, 'Cash', '2025-03-23', 480.0),
(20, 10, 'Credit Card', '2025-03-24', 800.0);

-- 2 Update
UPDATE Booking b
JOIN Room r ON b.room_id = r.room_id
SET b.total_amount = r.room_price * DATEDIFF(b.check_out_date, b.check_in_date)
WHERE r.room_status = 'Booked' AND b.check_in_date < CURRENT_DATE();

-- 3 Delete
DELETE FROM Payment 
WHERE payment_method = 'Cash' AND payment_amount < 500;

-- p4
-- 1
SELECT customer_id, customer_full_name, customer_email, customer_phone, customer_address
FROM Customer
ORDER BY customer_full_name;

-- 2. lay thong tin phong giam dan theo gia
SELECT room_id, room_type, room_price, room_area
FROM Room
ORDER BY room_price DESC;

-- 3. lay thong tin khach hang va thong tin phong da dat
SELECT c.customer_id, c.customer_full_name, b.room_id, b.check_in_date, b.check_out_date
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id;

-- 4. lay danh sach khach hang va tong tien thanh toan khi dat phong theo so tien giam dan
SELECT c.customer_id, c.customer_full_name, p.payment_method, p.payment_amount
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN Payment p ON b.booking_id = p.booking_id
ORDER BY p.payment_amount DESC;

-- 5. lay thong tin khach hang tu 2 den 4 trong customer sap xep theo ten khach hang
SELECT customer_id, customer_full_name
FROM Customer
ORDER BY customer_full_name
LIMIT 3 OFFSET 1;

-- 6. lay khach dat it nhat 2 phong va tong tien tren 1000
SELECT c.customer_id, c.customer_full_name, COUNT(DISTINCT b.room_id) AS room_count
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN Payment p ON b.booking_id = p.booking_id
GROUP BY c.customer_id, c.customer_full_name
HAVING SUM(p.payment_amount) > 1000 AND COUNT(DISTINCT b.room_id) >= 2;

-- 7. tat ca phong co tong thanh toan duoi 1000 va it nhat 3 khach hang dat
SELECT r.room_id, r.room_type, r.room_price, SUM(p.payment_amount) AS total_payment
FROM Room r
JOIN Booking b ON r.room_id = b.room_id
JOIN Payment p ON b.booking_id = p.booking_id
GROUP BY r.room_id, r.room_type, r.room_price
HAVING SUM(p.payment_amount) < 1000 AND COUNT(DISTINCT b.customer_id) >= 3;

-- 8. danh sach khach hang co tong tien thanh toan hon 1000
SELECT c.customer_id, c.customer_full_name, b.room_id, SUM(p.payment_amount) AS total_payment
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN Payment p ON b.booking_id = p.booking_id
GROUP BY c.customer_id, c.customer_full_name, b.room_id
HAVING SUM(p.payment_amount) > 1000;

-- 9. cac phong co so luong khach dat nhieu nhat va it nhat
SELECT r.room_id, r.room_type, COUNT(b.customer_id) AS customer_count
FROM Room r
LEFT JOIN Booking b ON r.room_id = b.room_id
GROUP BY r.room_id, r.room_type
HAVING COUNT(b.customer_id) = (
    --nhiu nhat
    SELECT COUNT(b.customer_id)
    FROM Room r
    JOIN Booking b ON r.room_id = b.room_id
    GROUP BY r.room_id
    ORDER BY COUNT(b.customer_id) DESC
    LIMIT 1
) OR COUNT(b.customer_id) = (
--it nhat
    SELECT COUNT(b.customer_id)
    FROM Room r
    JOIN Booking b ON r.room_id = b.room_id
    GROUP BY r.room_id
    ORDER BY COUNT(b.customer_id) ASC
    LIMIT 1
);

-- 10. danh sach khach co tong tien thanh toan lan dat phong cao hon so tien thanh toan trung binh cua tat ca khach hang cung phong
SELECT c.customer_id, c.customer_full_name, b.room_id, SUM(p.payment_amount) AS total_payment
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN Payment p ON b.booking_id = p.booking_id
GROUP BY c.customer_id, c.customer_full_name, b.room_id
HAVING SUM(p.payment_amount) > (
    SELECT AVG(payment_amount)
    FROM Payment p2
    JOIN Booking b2 ON p2.booking_id = b2.booking_id
    WHERE b2.room_id = b.room_id
);

-- P5: tạo view
-- 1. tao view cho ong va khach voi ngay check in truoc ngay 10/3/2025
CREATE VIEW early_march_bookings AS
SELECT r.room_id, r.room_type, c.customer_id, c.customer_full_name
FROM Room r
JOIN Booking b ON r.room_id = b.room_id
JOIN Customer c ON b.customer_id = c.customer_id
WHERE b.check_in_date < '2025-03-10';

-- 2. View cho khach hang va cac phong da dat ma dien tich phong lon hon 30m2
CREATE VIEW large_room_bookings AS
SELECT c.customer_id, c.customer_full_name, r.room_id, r.room_area
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN Room r ON b.room_id = r.room_id
WHERE r.room_area > 30;

-- P6: tao triggers
-- 1. Trigger check du lieu khi chen vao bang
DELIMITER //
CREATE TRIGGER check_insert_booking
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
    IF NEW.check_in_date > NEW.check_out_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ngày đặt phòng không thể sau ngày trả phòng được!';
    END IF;
END //
DELIMITER ;

-- 2. Trigger cap nhat trang thai phong khi phong duoc dat
DELIMITER //
CREATE TRIGGER update_room_status_on_booking
AFTER INSERT ON Booking
FOR EACH ROW
BEGIN
    UPDATE Room
    SET room_status = 'Booked'
    WHERE room_id = NEW.room_id;
END //
DELIMITER ;

--p7 store procedure
-- 1 tao store procedure ten add_customer them moi khach hang voi day du cac thong tin can thiet
DELIMITER //
CREATE PROCEDURE add_customer(
    IN p_customer_id VARCHAR(10),
    IN p_customer_full_name VARCHAR(150),
    IN p_customer_email VARCHAR(255),
    IN p_customer_address VARCHAR(255),
    IN p_customer_phone CHAR(15)
)
BEGIN
    INSERT INTO Customer (customer_id, customer_full_name, customer_email, customer_address, customer_phone)
    VALUES (p_customer_id, p_customer_full_name, p_customer_email, p_customer_address, p_customer_phone);
END //
DELIMITER ;

-- 2. Procedure de add thanh toan moi
DELIMITER //
CREATE PROCEDURE add_payment(
    IN p_booking_id INT,
    IN p_payment_method VARCHAR(50),
    IN p_payment_amount DECIMAL(10,2),
    IN p_payment_date DATE
)
BEGIN
    INSERT INTO Payment (booking_id, payment_method, payment_date, payment_amount)
    VALUES (p_booking_id, p_payment_method, p_payment_date, p_payment_amount);
END //
DELIMITER ;
