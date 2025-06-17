USE `sales_db`;

DELIMITER $$

CREATE PROCEDURE delete_order_and_sales (IN in_order_id INT)
BEGIN
    DELETE FROM  sales
    WHERE order_id = in_order_id;
    
    DELETE FROM  orders
    WHERE order_id = in_order_id;
END$$
DELIMITER ;

CALL delete_order_and_sales(5);