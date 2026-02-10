-- Active: 1770471809351@@127.0.0.1@3306@ecommerce


-- Aggregation
-- --------------
-- Aggregation means performing calculations on multiple rows of data and returning a single summarized result.


-- In MySQL, we use aggregate functions like:

-- COUNT() → count rows
-- SUM() → total value
-- AVG() → average
-- MIN() → smallest value
-- MAX() → largest value

-- Aggregation is often used with GROUP BY to summarize data per category (like per customer).


CREATE DATABASE IF NOT EXISTS ecommerce;

USE ecommerce;

DROP TABLE IF EXISTS orders;

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(20) NOT NULL,
  middle_name VARCHAR(20) NULL,
  last_name VARCHAR(20) NOT NULL,
  email VARCHAR(50) NOT NULL,
  address VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Create orders table
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  order_date DATE NOT NULL,
  delivery_date DATE NOT NULL,
  total_amount FLOAT(5,2),
  status VARCHAR(10) DEFAULT 'Pending',
  Foreign Key (customer_id) REFERENCES customers(customer_id)
);

-- Drop Table
-- DROP TABLE ORDERS;

-- INSERT rows in customers table:
INSERT INTO customers (first_name, middle_name, last_name, email, address)
VALUES ('John', 'Michael', 'Doe', 'john.doe@example.com', '123 Main St, New York, NY'),
('Jane', NULL, 'Smith', 'jane.smith@example.com', '456 Oak Ave, Los Angeles, CA'),
('Robert', 'Andrew', 'Brown', 'robert.brown@example.com', '789 Pine Rd, Chicago, IL'),
('Emily', 'Grace', 'Johnson', 'emily.johnson@example.com', NULL),
('David', NULL, 'Wilson', 'david.wilson@example.com', '654 Cedar Ln, Phoenix, AZ');


-- INSERT rows in orders table
INSERT INTO orders (customer_id, order_date, delivery_date, total_amount, status)
VALUES
(1, '2026-02-01', '2026-02-04', 120.50, 'Completed'),
(2, '2026-02-02', '2026-02-06', 75.99, 'Pending'),
(3, '2026-02-03', '2026-02-07', 250.00, 'Shipped'),
(1, '2026-02-04', '2026-02-08', 45.75, 'Cancelled'),
(4, '2026-02-05', '2026-02-09', 310.20, 'Completed'),
(5, '2026-02-06', '2026-02-10', 89.49, DEFAULT),
(2, '2026-02-07', '2026-02-13', 150.00, 'Shipped');

SHOW TABLES;



-- Simple Aggregation (No GROUP BY)
SELECT SUM(total_amount) AS total_revenue
FROM orders;


-- Total number of orders
SELECT COUNT(*) AS total_orders
FROM orders;




-- Aggregation with GROUP BY
-- ----------------------------


-- Total amount spent by each customer

SELECT 
    customer_id,
    SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id;

-- What happens here?

-- 1. MySQL groups rows by customer_id
-- 2. Then calculates SUM(total_amount) for each group
-- 3. Returns one row per customer



-- Count Orders Per Customer

SELECT 
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id;


-- Using JOIN + Aggregation
-- Customer names along with their total spending:

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;



-- Filtering Aggregated Results (HAVING)

-- Important difference:

-- WHERE → filters rows before aggregation
-- HAVING → filters after aggregation

-- Example: Customers who spent more than 1000

SELECT 
    customer_id,
    SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > 200;


-- without using having

Select * From (
    SELECT 
    customer_id,
    SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY customer_id
) q 
WHERE total_spent > 200;


-- Execution order (simplified):

-- FROM
-- JOIN
-- WHERE
-- GROUP BY
-- HAVING
-- SELECT




-- Aggregation by Order Status
---------------------------------------

-- Count orders by status
SELECT 
    status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY status;



-- Total revenue by status
SELECT 
    status,
    SUM(total_amount) AS total_revenue
FROM orders
GROUP BY status;



-- Monthly Revenue Aggregation
-- Revenue per month

SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;



-- Handling NULLs in Aggregation
-- In MySQL:

-- COUNT(column) → ignores NULLs
-- SUM() → ignores NULLs
-- AVG() → ignores NULLs



-- Insert a row with NULL total_amount
INSERT INTO orders (customer_id, order_date, delivery_date, total_amount, status) VALUES
(3, '2026-02-08', '2026-02-12', NULL, 'Pending');



-- If total_amount is NULL
SELECT SUM(total_amount)
FROM orders;


-- If some rows have NULL, they are simply skipped.
-- But if all values are NULL, result = NULL.

-- Safer version using COALESCE
-- COALESCE(value, default) → returns value if not NULL, else default

SELECT COALESCE(SUM(total_amount), 0) AS total_revenue
FROM orders;


-- COUNT Difference Example

-- counts all rows
SELECT COUNT(*) FROM orders;         

-- ignores NULL total_amount
SELECT COUNT(total_amount) FROM orders;  


SELECT count(*) FROM customers;

SELECT count(DISTINCT customer_id) From orders;

UPDATE orders
SET total_amount = NULL;

SELECT COALESCE(SUM(total_amount), 'No Data') AS total_revenue
FROM orders;