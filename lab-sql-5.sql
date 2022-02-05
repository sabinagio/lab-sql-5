USE sakila;

# 1. Drop column picture from staff.
ALTER TABLE staff
DROP picture;

# 2. A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
SELECT * FROM customer WHERE first_name = "Tammy" and last_name = "Sanders";
SELECT * FROM staff;


INSERT INTO staff 
(staff_id, `active`, `password`, username, store_id, first_name, last_name, address_id, email, last_update)

SELECT '3', '1', '', 'Tammy', store_id, first_name, last_name, address_id, email, last_update
FROM customer 
WHERE first_name = "Tammy" AND last_name = "Sanders";

# 3. Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. 
# You can use current date for the rental_date column in the rental table. 

# Check the necessary information
SELECT * FROM rental ORDER BY rental_id DESC LIMIT 1;

# Select only the first entry as there are 4 different inventory ids for the same movie
INSERT INTO rental (rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
SELECT '16050', NOW(), inventory.inventory_id, customer.customer_id, null, staff.staff_id, NOW()
FROM inventory
INNER JOIN film ON inventory.film_id = film.film_id
INNER JOIN customer ON inventory.store_id = customer.store_id
INNER JOIN staff ON staff.store_id = inventory.store_id
WHERE 
	film.title = "Academy Dinosaur" AND 
    inventory.store_id = '1'AND 
    customer.first_name = "Charlotte" AND 
    customer.last_name = "Hunter"
LIMIT 1;

# Check that the insertion happened correctly
SELECT * FROM rental ORDER BY rental_id DESC LIMIT 1;

# 4. Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, 
# and the date for the users that would be deleted. Follow these steps:

# 4.1. Check if there are any non-active users
SELECT payment.payment_id
FROM payment
INNER JOIN customer ON payment.customer_id = customer.customer_id
WHERE customer.active = 0;

# 4.2. Create a table backup table as suggested
CREATE TABLE customer_backup LIKE customer;

# 4.3. Insert the non active users in the table backup table
INSERT INTO customer_backup (customer_id, store_id, first_name, last_name, email, address_id, `active`, create_date, last_update)
SELECT * FROM customer WHERE `active` = 0;

# 4.4. Delete the non active users from the table customer
DELETE FROM customer WHERE `active` = 0; # Had to enable ON DELETE CASCADE for the tables where customer_id 
										 # was a foreign key in the sakila-schema before running the previous command

