DROP DATABASE IF EXISTS food_delivery;
CREATE DATABASE IF NOT EXISTS food_delivery;
USE food_delivery;

CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    restaurant_id INT,
    order_amount DECIMAL(10,2),
    order_status VARCHAR(50),
    payment_method VARCHAR(50),
    order_date DATE,
    delivery_time_minutes INT
);


INSERT INTO orders VALUES
(1001,101,201,850,'Completed','UPI','2023-09-10',35),
(1002,102,202,-500,'completed','Card','2023-09-12',40),
(1003,103,203,0,'cancel','Cash','2023-09-15',NULL),
(1004,104,204,1200,'done','UPI','2026-01-01',50),
(1005,105,205,650,'Cancelled','Card','2023-10-01',20),
(1006,106,206,950,'Completed','UPI','2023-10-05',200),
(1007,107,207,720,'COMPLETED','Wallet','2023-10-08',30),
(1008,108,208,1100,'invalid_status','UPI','2023-10-10',45),
(1001,101,201,850,'Completed','UPI','2023-09-10',35),
(1009,109,201,450,'Completed','UPI','2023-10-11',25),
(1010,110,202,780,'completed','Card','2023-10-12',60),
(1011,101,203,1500,'Cancelled','Wallet','2023-10-13',15),
(1012,102,204,-300,'done','Cash','2023-10-14',40),
(1013,103,205,980,'COMPLETED','UPI','2023-10-15',NULL),
(1014,104,206,0,'cancel','Card','2023-10-16',35),
(1015,105,207,870,'Completed','UPI','2026-02-01',50),
(1016,106,208,430,'invalid','Wallet','2023-10-18',20),
(1017,107,201,1200,'Completed','Card','2023-10-19',300),
(1018,108,202,640,'Cancelled','Cash','2023-10-20',30),
(1019,109,203,710,'completed','UPI','2023-10-21',42),
(1020,110,204,550,'done','Card','2023-10-22',38),
(1021,101,205,890,'Completed','UPI','2023-10-23',45),
(1022,102,206,1020,'Completed','Wallet','2023-10-24',47),
(1023,103,207,-50,'cancel','UPI','2023-10-25',25),
(1024,104,208,760,'Completed','Card','2023-10-26',0),
(1025,105,201,1340,'COMPLETED','UPI','2023-10-27',33),
(1026,106,202,920,'Cancelled','Wallet','2023-10-28',18),
(1027,107,203,480,'done','Cash','2023-10-29',55),
(1005,105,205,650,'Cancelled','Card','2023-10-01',20);

SELECT COUNT(*) FROM orders;


SELECT order_id, COUNT(*) 
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;



-- ------------------------------------------------------------------

-- Create DWH Database
DROP DATABASE IF EXISTS food_delivery_dwh;
CREATE DATABASE IF NOT EXISTS food_delivery_dwh;

USE food_delivery_dwh;


-- Create Dimension Tables
-- -------------------------
CREATE TABLE food_delivery_dwh.DimCustomer (
    CustomerKey INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    city VARCHAR(50),
    status VARCHAR(20)
);


-- DimRestaurant
-- --------------

CREATE TABLE food_delivery_dwh.DimRestaurant (
    RestaurantKey INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT,
    restaurant_name VARCHAR(100),
    city VARCHAR(50),
    cuisine_type VARCHAR(50),
    rating DECIMAL(3,2),
    is_active_flag INT
);


-- DimDate
CREATE TABLE food_delivery_dwh.DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATE,
    Year INT,
    Quarter INT,
    Month INT,
    MonthName VARCHAR(20),
    Day INT
);



-- Create Fact Table
-- --------------------

CREATE TABLE food_delivery_dwh.FactOrders (
    OrderKey INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    CustomerKey INT,
    RestaurantKey INT,
    DateKey INT,
    order_amount DECIMAL(10,2),
    delivery_time_minutes INT,
    is_cancelled INT,
    is_delayed INT,
    FOREIGN KEY (CustomerKey) REFERENCES DimCustomer(CustomerKey),
    FOREIGN KEY (RestaurantKey) REFERENCES DimRestaurant(RestaurantKey),
    FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey)
);



-- ---------------------------------------------------------
-- After loading the Data
-- Run analytics query


-- Monthly Revenue Trend
USE food_Delivery_dwh;
SELECT 
    d.Year,
    d.Month,
    d.MonthName,
    SUM(f.order_amount) AS Monthly_Revenue
FROM FactOrders f
JOIN DimDate d ON f.DateKey = d.DateKey
WHERE f.is_cancelled = 0
GROUP BY d.Year, d.Month, d.MonthName
ORDER BY d.Year, d.Month;


-- Cancellation Rate (%)
-- -----------------------

SELECT 
    ROUND(
        (SUM(f.is_cancelled) / COUNT(*)) * 100,
        2
    ) AS Cancellation_Percentage
FROM FactOrders f;


-- Revenue by Restaurant
-- ----------------------
SELECT 
    r.restaurant_name,
    SUM(f.order_amount) AS Revenue
FROM FactOrders f
JOIN DimRestaurant r ON f.RestaurantKey = r.RestaurantKey
WHERE f.is_cancelled = 0
GROUP BY r.restaurant_name
ORDER BY Revenue DESC;



-- Revenue by City
-- ------------------

SELECT 
    r.city,
    SUM(f.order_amount) AS Revenue
FROM FactOrders f
JOIN DimRestaurant r ON f.RestaurantKey = r.RestaurantKey
WHERE f.is_cancelled = 0
GROUP BY r.city
ORDER BY Revenue DESC;


-- Customers by Spend
-- -----------------------

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS Customer_Name,
    SUM(f.order_amount) AS Total_Spend
FROM FactOrders f
JOIN DimCustomer c ON f.CustomerKey = c.CustomerKey
WHERE f.is_cancelled = 0
GROUP BY c.customer_id, Customer_Name
ORDER BY Total_Spend DESC
LIMIT 5;


-- Revenue Contribution %
-- --------------------------

SELECT 
    r.restaurant_name,
    SUM(f.order_amount) AS Revenue,
    ROUND(
        SUM(f.order_amount) / 
        (SELECT SUM(order_amount) 
         FROM FactOrders 
         WHERE is_cancelled = 0) * 100,
    2) AS Revenue_Percentage
FROM FactOrders f
JOIN DimRestaurant r ON f.RestaurantKey = r.RestaurantKey
WHERE f.is_cancelled = 0
GROUP BY r.restaurant_name
ORDER BY Revenue DESC;