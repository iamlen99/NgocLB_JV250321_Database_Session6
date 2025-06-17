USE `sales_db`;

ALTER TABLE orders 
DROP FOREIGN KEY o_customer_id_fk;

ALTER TABLE customers
MODIFY customer_id INT AUTO_INCREMENT;

ALTER TABLE orders
ADD CONSTRAINT o_customer_id_fk
	FOREIGN KEY (customer_id)
	REFERENCES customers(customer_id)
	ON DELETE CASCADE;

DROP PROCEDURE add_new_customer;
DELIMITER $$

CREATE PROCEDURE add_new_customer (
	IN in_first_name VARCHAR(100),
    IN in_last_name VARCHAR(100),
    IN in_email VARCHAR(100)
)

BEGIN
	INSERT INTO customers (first_name, last_name, email)
    VALUES (in_first_name, in_last_name, in_email);    
END$$
DELIMITER ;

SET @add_first_name = 'Lee';
SET @add_last_name = 'Khoa';
SET @add_email = 'Khoa@gmail.com';

CALL add_new_customer(@add_first_name, @add_last_name, @add_email);