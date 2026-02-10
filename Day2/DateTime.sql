-- Active: 1770471809351@@127.0.0.1@3306@demo
-- Date functions (e.g., DATE_ADD(), DATEDIFF(), NOW())
-- ----------------------------------------------------
-- Date functions are low-key superheroes in data analysis and software development. 
-- Any time your data has a date or time column (and it almost always does), 
-- date functions help you make sense of patterns, trends, and timelines.

-- Why Date Functions Are Important
-- Organizing & Filtering Data

-- You can:
-- Extract year, month, day
-- Filter records from a specific period
-- Group data by week, month, or quarter

-- Example: “Show me sales from January 2026.”


-- Now(): returns the current date and time
SELECT NOW() AS current_datetime;
SELECT CURRENT_TIMESTAMP() AS current_datetime;


-- Use Cases

-- Insert current timestamp in orders
-- Login tracking
-- Audit logs
-- Created_at fields


-- -----------


--  CURDATE(): Returns only current date
SELECT CURDATE() as cdate;

-- Use Cases

-- Compare only dates (ignore time)
-- Daily reports
-- Attendance systems


-- -----------


-- DATE(): Extracts date from datetime
SELECT DATE(NOW()) AS current_date_only;
SELECT DATE('2025-02-10 14:35:22') AS current_date_only;


SELECT YEAR('2026-02-10');
SELECT MONTH('2026-02-10');
SELECT DAY('2026-02-15');
SELECT HOUR(NOW());
SELECT MINUTE(NOW());
SELECT SECOND(NOW());




-- Use Cases
-- Compare date part of datetime
-- Group by date

Drop Table if exists users;
CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  middle_name VARCHAR(50) NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL,
  age TINYINT UNSIGNED NOT NULL,
  first_paid_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users(first_name, middle_name, last_name, email, age) VALUES
('John', 'Michael', 'Smith', 'johnsmith@gmail.com', 25),
('Jane', 'Elizabeth', 'Doe', 'janedoe@Gmail.com', 28),
('Xavier', NULL, 'Wills', 'xavier@wills.io', 35),
('Bev', NULL, 'Scott', 'bev@bevscott.com', 16),
('Bree', 'Marie', 'Jensen', 'bjensen@corp.net', 42),
('John', 'Robert', 'Jacobs', 'jjacobs@corp.net', 56),
('Rick', NULL, 'Fullman', 'fullman@hotmail.com', 16);


SELECT DATE(first_paid_at) AS payment_date, COUNT(*) AS payments_count
FROM users
Group by payment_date;


-- -----------


-- DATE_ADD(): Adds a specified time interval to a date
SELECT DATE_ADD(NOW(), INTERVAL 7 DAY) AS next_week;
SELECT (NOW() - INTERVAL 7 MONTH) AS next_week;

-- Units: DAY, MONTH, YEAR, HOUR, MINUTE, SECOND

-- Use Cases
-- Calculate future dates (e.g., subscription renewal)
-- Schedule events
-- Delivery dates
-- Expiration dates


-- -----------


-- DATE_SUB(): Subtracts a specified time interval from a date
SELECT DATE_SUB(NOW(), INTERVAL 30 DAY);

-- Use Cases

-- Last 30 days data
-- Monthly reports

SELECT * From users
WHERE first_paid_at >= DATE_ADD(NOW(), INTERVAL 1 HOUR);


-- -----------


-- DATEDIFF(): Returns the number of days between two dates
SELECT DATEDIFF(NOW(), first_paid_at) AS days_since_first_payment 
From users WHERE first_paid_at IS NOT NULL;

-- Use Cases
-- Calculate age in days
-- Time since last login
-- Calculate overdue days


-- -----------


-- TIMESTAMPDIFF(): Returns the difference between two dates in specified units
-- More powerful than DATEDIFF.
-- It calculates the difference between two dates/timestamps in a specified unit.

-- Unlike DATEDIFF() (which only returns days), this one can return:

-- Years
-- Months
-- Days
-- Hours
-- Minutes
-- Seconds

-- Syntax: TIMESTAMPDIFF(unit, datetime_expr1, datetime_expr2)
-- unit: YEAR, MONTH, DAY, HOUR, MINUTE, SECOND
-- It calculates: datetime_expr2 - datetime_expr1 in the specified unit.

UPDATE users
SET first_paid_at = NOW()-INTERVAL 1 MONTH
Where id in (7)

SELECT * FROM users;


SELECT first_paid_at, TIMESTAMPDIFF(MONTH, first_paid_at, NOW()) AS months_since_first_payment
FROM users WHERE first_paid_at IS NOT NULL;




-- Use Cases

-- Calculate age correctly
-- Work experience
-- Session duration


-- -----------


-- YEAR(), MONTH(), DAY(): Extracts year, month, or day from a date
SELECT
  YEAR(first_paid_at) AS payment_year,
  MONTH(first_paid_at) AS payment_month,
  DAY(first_paid_at) AS payment_day
FROM users
WHERE first_paid_at IS NOT NULL;

-- Use Cases
-- Grouping by year/month/day
-- Filtering by specific year/month/day
-- Monthly sales


-- -----------


-- DAYNAME(), MONTHNAME(): Returns the name of the day or month
SELECT
  first_paid_at,
  DAYNAME(first_paid_at) AS payment_day_name,
  MONTHNAME(first_paid_at) AS payment_month_name
FROM users WHERE first_paid_at IS NOT NULL;




-- Real Business Queries Using Date Functions
-- ---------------------------------------------

use ecommerce;

SELECT * FROM orders;
-- Monthly Revenue Report
SELECT 
    MONTH(order_date) AS order_month,
    SUM(total_amount) AS total_sales
FROM orders
GROUP BY MONTH(order_date);



-- Calculate Delivery Time (Performance Metric)
SELECT 
    order_id,
    DATEDIFF(delivery_date, order_date) AS delivery_days
FROM orders;


-- Find Late Deliveries (More than 5 Days)
SELECT * FROM orders
WHERE DATEDIFF(delivery_date, order_date) > 5;


-- Orders in the Last 3 Days (Dynamic Reporting)
SELECT *
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL 3 DAY;


SELECT LAST_DAY('2026-05-01')


-- Convert from date to Formatted string
SELECT DATE_FORMAT(NOW(), '%d, %W %M, %Y')

-- Common format codes:

-- %Y → 4 digit year
-- %m → month (01–12)
-- %d → day
-- %W → weekday name
-- %M → month name


-- Convert from date string to date
SELECT STR_TO_DATE('10, Tuesday February, 2026', '%d, %W %M, %Y')

SELECT STR_TO_DATE('10-12-26', '%d-%m-%Y')