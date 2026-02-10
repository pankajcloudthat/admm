-- Active: 1770471809351@@127.0.0.1@3306@ecommerce
USE ecommerce;

SELECT * FROM customers;
SELECT * FROM orders;



-- Find customers who have placed at least one order.
SELECT *
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
);


-- Why this is a subquery?

-- The inner query runs first.
-- It returns a list of customer_id.
-- The outer query uses that result.

-- It does NOT depend on the outer query row → so it’s non-correlated.



-- Nested Subquery (Subquery inside another Subquery)
-- Find customers who placed orders with total amount greater than the average order amount.

SELECT *
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    WHERE total_amount > (
        SELECT AVG(total_amount)
        FROM orders
    )
);



-- What’s happening here?

-- Innermost query → calculates average order amount.
-- Middle query → finds customer_ids with orders above average.
-- Outer query → gets customer details.

SELECT * FROM orders

-- Correlated Subquery

-- Find customers whose total order amount is greater than the average total order amount of all customers.

SELECT c.*
FROM customers c
WHERE (
    SELECT SUM(o.total_amount)
    FROM orders o
    WHERE o.customer_id = c.customer_id
) > (
    SELECT AVG(total_amount)
    FROM orders
);

-- Why is this correlated?

-- The inner query uses c.customer_id
-- It runs once for each row of the outer query
-- It depends on outer query → that’s correlation



-- Find customers who have at least one order:
SELECT *
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);


-- Key Differences In vs Exists

-- | Feature            | IN                  | EXISTS             |
-- | ------------------ | ------------------- | ------------------ |
-- | Returns            | List of values      | TRUE / FALSE       |
-- | Execution          | Subquery runs first | Runs per outer row |
-- | Stops early?       | No                  | Yes                |
-- | Handles NULL well? | Risky with NOT IN   | Safe               |
-- | Better for         | Small datasets      | Large datasets     |
