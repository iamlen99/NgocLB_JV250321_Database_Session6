USE `sales_db`;

DELIMITER $$

CREATE PROCEDURE get_monthly_revenue (
	IN in_customer_id INT, 
    IN in_month_year VARCHAR (50),
    OUT customer_name VARCHAR(100),
    OUT month_total_amount DECIMAL(10, 2)
    )
BEGIN
    SELECT CONCAT(first_name, ' ', last_name) 
    INTO customer_name
    FROM customers
    WHERE customer_id = in_customer_id;
    
    SELECT SUM(s.sale_amount) INTO month_total_amount
    FROM sales AS s
    INNER JOIN orders AS o ON o.order_id = s.order_id
    WHERE o.customer_id = in_customer_id
		AND DATE_FORMAT(sale_date, '%Y-%m') = in_month_year
    GROUP BY o.customer_id;
    
END$$
DELIMITER ;

SET @customer_id = 1;
SET @month_year = '2025-06';
SET @customer_name = null;
SET @revenue_amount = null;


CALL get_monthly_revenue(@customer_id, @month_year, @customer_name, @revenue_amount);
SELECT @customer_name AS 'Tên khách hàng', @revenue_amount AS 'Tổng doanh thu theo tháng';