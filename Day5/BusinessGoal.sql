-- Data Warehouse
-- ----------------


-- End-to-end using Food Delivery domain


-- Step 1:
-- Start With the End Goal (Business First)
-- --------------------------------------------

-- Let’s say the business wants to answer:

-- 1. What is the daily / monthly revenue trend?
-- 2. Which restaurant generates highest revenue?
-- 3. Who are the top customers by spending?
-- 4. What are the popular food categories?
-- 5. What is the average delivery time?
-- 6. How is revenue trending by city?

-- From this, we identify Measures (Facts) and Dimensions.


-- STEP 2 — Identify Star Schema
-- ---------------------------------


-- Fact Table (Measures)
-- -----------------------

-- Order Amount
-- Quantity
-- Delivery Time
-- Discount
-- Order Count



-- Dimension Tables
-- -----------------------

-- Date
-- Customer (SCD Type 2)
-- Restaurant
-- Food Item
-- City
-- Delivery Partner






-- STEP 3 — Star Schema Design
-- -------------------------------

-- FACT TABLE: FactOrders
-- -----------------------

-- DateKey (FK)
-- CustomerKey (FK)
-- RestaurantKey (FK)
-- FoodKey (FK)
-- CityKey (FK)
-- DeliveryPartnerKey (FK)
-- OrderID (degenerate)
-- Quantity
-- OrderAmount
-- DiscountAmount
-- DeliveryMinutes


-- Dimension Tables
-- -----------------------

-- 1. DimDate
-- -------------
-- DateKey (PK)
-- FullDate
-- Day
-- Month
-- Year
-- Quarter
-- DayName


-- 2. DimCustomer (SCD Type 2)
-- ---------------------------
-- CustomerKey (PK surrogate)
-- CustomerID (business key)
-- Name
-- Email
-- City
-- StartDate
-- EndDate
-- IsCurrent

-- 3. DimRestaurant
-- ---------------
-- RestaurantKey
-- RestaurantID
-- RestaurantName
-- Category
-- City

-- 4. DimFood
-- ----------
-- FoodKey
-- FoodID
-- FoodName
-- Category
-- Price

-- 5. DimCity
-- ---------
-- CityKey
-- CityName
-- State

-- 6. DimDeliveryPartner
-- ---------------------
-- PartnerKey
-- PartnerID
-- PartnerName