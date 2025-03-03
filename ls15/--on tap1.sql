--on tap1
-- Tạo bảng Customers (Khách hàng)
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    address VARCHAR(255) NULL
);

-- Tạo bảng Products (Sản phẩm)
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    category VARCHAR(50) NOT NULL
);

-- Tạo bảng Employees (Nhân viên)
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_name VARCHAR(100) NOT NULL,
    birthday DATE NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    revenue DECIMAL(10,2) DEFAULT 0
);

-- Tạo bảng Orders (Đơn hàng)
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    employee_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Tạo bảng OrderDetails (Chi tiết đơn hàng)
CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Câu 3.1: Thêm cột email vào bảng Customers
ALTER TABLE Customers
ADD COLUMN email VARCHAR(100) NOT NULL UNIQUE;

-- Câu 3.2: Xóa cột ngày sinh từ bảng Employees
ALTER TABLE Employees
DROP COLUMN birthday;

--câu 4: chèn data vào bang

INSERT INTO Customers (customer_name, phone, address, email) VALUES
('Nguyễn Văn An', '0912345678', 'Hà Nội', 'an.nguyen@gmail.com'),
('Trần Thị Bình', '0923456789', 'Hồ Chí Minh', 'binh.tran@gmail.com'),
('Lê Văn Cường', '0934567890', 'Đà Nẵng', 'cuong.le@gmail.com'),
('Phạm Thị Dung', '0945678901', 'Hải Phòng', 'dung.pham@gmail.com'),
('Hoàng Văn Em', '0956789012', 'Cần Thơ', 'em.hoang@gmail.com');

INSERT INTO Products (product_name, price, quantity, category) VALUES
('Laptop Dell XPS 13', 1500.00, 50, 'Electronics'),
('iPhone 15 Pro', 1200.00, 100, 'Mobile'),
('Samsung Smart TV', 800.00, 30, 'Electronics'),
('Sony Headphones', 200.00, 150, 'Audio'),
('Apple Watch', 350.00, 80, 'Wearables');

INSERT INTO Employees (employee_name, position, salary, revenue) VALUES
('Trương Văn Hùng', 'Sales Manager', 2000.00, 15000.00),
('Lý Thị Hương', 'Sales Executive', 1500.00, 10000.00),
('Đặng Văn Kiên', 'Customer Support', 1200.00, 5000.00),
('Vũ Thị Lan', 'Marketing Specialist', 1800.00, 8000.00),
('Đinh Văn Minh', 'Warehouse Manager', 1600.00, 0.00);

INSERT INTO Orders (customer_id, employee_id, order_date, total_amount) VALUES
(1, 1, '2025-02-25 10:30:00', 2500.00),
(2, 2, '2025-02-26 11:45:00', 1200.00),
(3, 1, '2025-02-27 09:15:00', 3500.00),
(4, 3, '2025-02-28 14:20:00', 550.00),
(5, 2, '2025-03-01 16:30:00', 1800.00);

INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1500.00),
(1, 4, 5, 200.00),
(2, 2, 1, 1200.00),
(3, 1, 2, 1500.00),
(3, 5, 1, 350.00),
(4, 4, 2, 200.00),
(4, 5, 1, 150.00),
(5, 3, 2, 800.00),
(5, 5, 1, 200.00);

--câu 5: truy vấn cơ bản
--5.1 lấy danh sách tất cả khách hàng từ Customers
SELECT customer_id, customer_name, email, phone, address
FROM Customers;

--5.2 sửa thông tin của sản phẩm có product_id=1
UPDATE Products
SET product_name='laptop', price=99.99
WHERE product_id=1;

--5.3 lấy thông tin của những đơn đặt hàng
SELECT o.order_id, c.customer_name, e.employee_name, o.total_amount, o.order_date
FROM Orders o
JOIN Customer c ON o.customer_id=c.customer_id
JOIN Employees e ON o.employee_id=e.employee_id;

--câu 6
-- 6.1 Đếm số lượng đơn hàng của mỗi khách hàng
SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id =o.customer_id
GROUP BY c.customer_id, c.customer_name;

--6.2 thống kê tổng doanh thu của từng nhân viên trong năm hiện tại
SELECT e.employee_id, e.employee_name, SUM(o.total_amount) AS revenue
FROM Employees e
LEFT JOIN Orders o ON e.employee_id=o.employee_id
WHERE YEAR (o.order_date) = YEAR (CURRENT_DATE)
GROUP BY e.employee_id, e.employee_name;

-- 6.3 Thống kê những sản phẩm có số lượng đặt hàng lớn hơn 100 trong tháng hiện tại
SELECT p.product_id, p.product_name, SUM (od.quantity) AS total_ordered
FROM Products p
JOIN OrderDetails od ON p.product_id =od.product_id
JOIN Orders o ON od.order_id=o.order_id
WHERE YEAR (o.order_date)= YEAR(CURRENT_DATE) AND MONTH(o.order_date)=MONTH(CURRENT_DATE)
GROUP BY p.product_id, p.product_name
HAVING SUM(od.quantity)>100
ORDER BY total_order DESC;

--7 truy vấn nâng cao
--7.1 lấy danh sách khách hang chưa từng order hang
SELECT c.customer_id, c.customer_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id =o.customer_id
WHERE o.order_id IS NULL;

--7.2 lay danh sach san pham co gia tri cao hon gia trung binh cua all sp
SELECT product_id, product_name, price
FROM Products
WHERE price> (SELECT AVG(price) FROM Products);

--7.3 tìm những customer có mức chi tiêu cao nhất
SELECT c.customer_id, c.customer_name, SUM(o.total_amount) AS
FROM Customers c
JOIN Orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount)=(
	SELECT SUM(total amount)
	FROM Orders
	GROUP BY customer_id
	ORDER BY SUM(total_amount) DESC
    	LIMIT 1
);

-- Câu 8: Tạo view

-- 8.1 Tạo view view_order_list
CREATE VIEW view_order_list AS
SELECT o.order_id, c.customer_name, e.employee_name, o.total_amount, o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Employees e ON o.employee_id = e.employee_id
ORDER BY o.order_date DESC;

-- 8.2 Tạo view view_order_detail_product
CREATE VIEW view_order_detail_product AS
SELECT od.order_detail_id, p.product_name, od.quantity, od.unit_price
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
ORDER BY od.quantity DESC;

-- Câu 9: Tạo thủ tục lưu trữ

-- 9.1 Tạo thủ tục proc_insert_employee
DELIMITER //
CREATE PROCEDURE proc_insert_employee(
    IN p_employee_name VARCHAR(100),
    IN p_position VARCHAR(50),
    IN p_salary DECIMAL(10,2),
    OUT p_employee_id INT
)
BEGIN
    INSERT INTO Employees(employee_name, position, salary, revenue)
    VALUES(p_employee_name, p_position, p_salary, 0);
    
    SET p_employee_id = LAST_INSERT_ID();
END //
DELIMITER ;

-- 9.2 Tạo thủ tục proc_get_orderdetails
DELIMITER //
CREATE PROCEDURE proc_get_orderdetails(
    IN p_order_id INT
)
BEGIN
    SELECT od.order_detail_id, od.product_id, p.product_name, od.quantity, od.unit_price
    FROM OrderDetails od
    JOIN Products p ON od.product_id = p.product_id
    WHERE od.order_id = p_order_id;
END //
DELIMITER ;

-- 9.3 Tạo thủ tục proc_cal_total_amount_by_order
DELIMITER //
CREATE PROCEDURE proc_cal_total_amount_by_order(
    IN p_order_id INT,
    OUT p_product_count INT
)
BEGIN
    SELECT COUNT(DISTINCT product_id) INTO p_product_count
    FROM OrderDetails
    WHERE order_id = p_order_id;
END //
DELIMITER ;

-- Câu 10: Tạo trigger

DELIMITER //
CREATE TRIGGER trigger_after_insert_order_details
BEFORE INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    DECLARE stock_quantity INT;
    
    -- Lấy số lượng hiện có trong kho
    SELECT quantity INTO stock_quantity
    FROM Products
    WHERE product_id = NEW.product_id;
    
    -- Kiểm tra số lượng đủ hay không
    IF stock_quantity < NEW.quantity THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Số lượng sản phẩm trong kho không đủ';
    ELSE
        -- Cập nhật số lượng sản phẩm trong kho
        UPDATE Products
        SET quantity = quantity - NEW.quantity
        WHERE product_id = NEW.product_id;
    END IF;
END //
DELIMITER ;

-- Câu 11: Quản lý transaction

DELIMITER //
CREATE PROCEDURE proc_insert_order_details(
    IN p_order_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_unit_price DECIMAL(10,2)
)
BEGIN
    DECLARE order_exists INT DEFAULT 0;
    DECLARE exit_handler BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET exit_handler = TRUE;
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Đã xảy ra lỗi, giao dịch đã được hủy bỏ';
    END;

    START TRANSACTION;
    
    -- Kiểm tra mã hóa đơn tồn tại
    SELECT COUNT(*) INTO order_exists FROM Orders WHERE order_id = p_order_id;
    
    IF order_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không tồn tại mã hóa đơn';
        SET exit_handler = TRUE;
    END IF;
    
    IF NOT exit_handler THEN
        -- Chèn dữ liệu vào bảng OrderDetails
        INSERT INTO OrderDetails(order_id, product_id, quantity, unit_price)
        VALUES(p_order_id, p_product_id, p_quantity, p_unit_price);
        
        -- Cập nhật tổng tiền của đơn hàng
        UPDATE Orders
        SET total_amount = total_amount + (p_quantity * p_unit_price)
        WHERE order_id = p_order_id;
        
        COMMIT;
    END IF;
END //
DELIMITER ;