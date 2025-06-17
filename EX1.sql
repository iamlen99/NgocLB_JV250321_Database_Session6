CREATE SCHEMA `sales_db`;

USE `sales_db`;

CREATE TABLE customers (
	`customer_id` INT,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`customer_id`)
);

INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'john.doe@example.com'),
(2, 'Jane', 'Smith', 'jane.smith@example.com'),
(3, 'Bob', 'Johnson', 'bob.johnson@example.com');

CREATE TABLE promotions (
	`promotion_id` INT,
    `promotion_name` VARCHAR(100) NOT NULL,
    `discount_percentage` DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (`promotion_id`)
);

INSERT INTO promotions (promotion_id, promotion_name, discount_percentage) VALUES
(1, 'Summer Sale', 10.00),
(2, 'Black Friday', 20.00),
(3, 'New Year Sale', 15.00);

CREATE TABLE products (
	`product_id` INT,
    `product_name` VARCHAR(100) NOT NULL,
    `price` DECIMAL(10, 2) NOT NULL,
    `promotion_id` INT,
    PRIMARY KEY (`product_id`),
    CONSTRAINT `p_promotion_id_fk`
		FOREIGN KEY (`promotion_id`)
        REFERENCES promotions (`promotion_id`)
         ON DELETE CASCADE
);

INSERT INTO products (product_id, product_name, price, promotion_id) VALUES
(1, 'Laptop', 1000.00, 1),
(2, 'Smartphone', 700.00, 2),
(3, 'Headphones', 150.00, NULL),
(4, 'Monitor', 300.00, 3);

CREATE TABLE orders (
	`order_id` INT,
    `customer_id` INT,
    `order_date` DATETIME,
    `total_amount` DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (`order_id`),
    CONSTRAINT `o_customer_id_fk`
		FOREIGN KEY (`customer_id`)
		REFERENCES customers (`customer_id`)
        ON DELETE CASCADE
);

INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(1, 1, '2025-06-15 10:00:00', 1700.00),
(2, 2, '2025-06-16 14:30:00', 450.00),
(3, 3, '2025-06-17 09:15:00', 300.00);

CREATE TABLE sales (
	`sale_id` INT,
    `order_id` INT,
    `sale_date` DATE,
    `sale_amount` DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (`sale_id`),
	CONSTRAINT `s_order_id_fk`
		FOREIGN KEY (`order_id`)
		REFERENCES orders (`order_id`)
        ON DELETE CASCADE
);

INSERT INTO sales (sale_id, order_id, sale_date, sale_amount) VALUES
(1, 1, '2025-06-15', 1700.00),
(2, 2, '2025-06-16', 450.00),
(3, 3, '2025-06-17', 300.00);

CREATE TABLE order_details (
	`order_detail_id` INT,
    `order_id` INT,
	`product_id` INT,
    `quantity` INT NOT NULL,
    `unit_price` DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (`order_detail_id`),
    CONSTRAINT `od_order_id_fk`
		FOREIGN KEY (`order_id`)
		REFERENCES orders (`order_id`)
        ON DELETE CASCADE,
	CONSTRAINT `od_product_id_fk`
		FOREIGN KEY (`product_id`)
		REFERENCES products (`product_id`)
		ON DELETE CASCADE
);

INSERT INTO order_details (order_detail_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1, 1000.00),  -- Laptop
(2, 1, 2, 1, 700.00),   -- Smartphone
(3, 2, 3, 3, 150.00),   -- Headphones
(4, 3, 4, 1, 300.00);   -- Monitor

drop procedure GetCustomerTotalRevenue;

DELIMITER $$ 
CREATE PROCEDURE GetCustomerTotalRevenue (
	IN in_customer_id INT, 
    IN in_start_date DATETIME, 
    IN in_end_DATE DATETIME, 
    OUT customer_name VARCHAR(100), 
    OUT total_revenue INT)
BEGIN 
	SELECT CONCAT(customers.`first_name`, ' ', customers.`last_name`)
	INTO customer_name
    FROM customers
    WHERE customers.customer_id = in_customer_id;
    
	SELECT SUM(o.`total_amount`) INTO total_revenue
    FROM orders AS o
    INNER JOIN customers AS c ON c.`customer_id` = o.`customer_id`
    WHERE order_date BETWEEN in_start_date AND in_end_DATE 
		AND o.customer_id = in_customer_id
	GROUP BY o.customer_id; 
END$$
DELIMITER ;

SET @customer_id = 3; 
SET @start_date := '2025-06-15 9:00:00'; 
SET @end_date := '2025-06-30 10:00:00'; 
SET @revenue_total = null;
SET @customer_name = null;

SELECT @end_date;

CALL GetCustomerTotalRevenue (@customer_id, @start_date, @end_date,  @customer_name, @revenue_total);
SELECT @customer_name AS 'Tên khách hàng', @revenue_total AS 'Tổng doanh thu';


