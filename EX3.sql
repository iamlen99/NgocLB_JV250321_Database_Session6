USE `sales_db`;

DELIMITER $$
CREATE PROCEDURE update_order_total_amount (
	IN in_order_id INT,
    IN in_new_total_amount DECIMAL(10, 2)
	)
BEGIN 
	UPDATE orders
    SET orders.`total_amount` = in_new_total_amount
    WHERE orders.order_id = in_order_id;
END$$
DELIMITER ;

SET @order_id = 2;
SET @updated_total_amount = 550;

CALL update_order_total_amount(@order_id, @updated_total_amount);