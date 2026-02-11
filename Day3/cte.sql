
-- CTE (Common Table Expression)
-- -----------------------------

-- A CTE is a temporary named result set that you can reference inside a SELECT, INSERT, UPDATE, or DELETE statement.

-- It improves:

-- Readability
-- Reusability
-- Complex query structure
-- Logical separation of steps


-- Basic Syntax

WITH cte_name AS (
    SELECT ...
)
SELECT *
FROM cte_name;


-- Simple CTE Example
-- Get monthly revenue per department

WITH monthly_revenue AS (
    SELECT 
        department,
        DATE_FORMAT(sale_date, '%Y-%m') AS month,
        SUM(sale_amount) AS total_revenue
    FROM sales_data
    GROUP BY department, DATE_FORMAT(sale_date, '%Y-%m')
)
SELECT *
FROM monthly_revenue
ORDER BY department, month;




-- Find best month per department
WITH monthly_revenue AS (
    SELECT 
        department,
        DATE_FORMAT(sale_date, '%Y-%m') AS month,
        SUM(sale_amount) AS total_revenue
    FROM sales_data
    GROUP BY department, DATE_FORMAT(sale_date, '%Y-%m')
)
SELECT *
FROM (
    SELECT 
        department,
        month,
        total_revenue,
        RANK() OVER (
            PARTITION BY department
            ORDER BY total_revenue DESC
        ) AS month_rank
    FROM monthly_revenue
) t
WHERE month_rank = 1;



-- Month-over-month growth
WITH monthly_revenue AS (
    SELECT 
        department,
        DATE_FORMAT(sale_date, '%Y-%m') AS month,
        SUM(sale_amount) AS total_revenue
    FROM sales_data
    GROUP BY department, DATE_FORMAT(sale_date, '%Y-%m')
)
SELECT 
    department,
    month,
    total_revenue,
    total_revenue -
    LAG(total_revenue) OVER (
        PARTITION BY department
        ORDER BY month
    ) AS growth_difference
FROM monthly_revenue
ORDER BY department, month;



-- How is each restaurant performing month-over-month?

WITH monthly_revenue AS (
    SELECT 
        r.restaurant_id,
        r.restaurant_name,
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(o.total_amount) AS total_revenue
    FROM Orders o
    JOIN Restaurants r
        ON o.restaurant_id = r.restaurant_id
    WHERE o.status = 'Delivered'
    GROUP BY r.restaurant_id, r.restaurant_name, DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT 
    restaurant_name,
    month,
    total_revenue,
    total_revenue -
    LAG(total_revenue) OVER (
        PARTITION BY restaurant_id
        ORDER BY month
    ) AS revenue_growth
FROM monthly_revenue
ORDER BY restaurant_name, month;



-- Who are the top spenders in each restaurant?
WITH customer_spending AS (
    SELECT 
        r.restaurant_id,
        r.restaurant_name,
        c.customer_id,
        c.name AS customer_name,
        SUM(o.total_amount) AS total_spent
    FROM Orders o
    JOIN Customers c 
        ON o.customer_id = c.customer_id
    JOIN Restaurants r 
        ON o.restaurant_id = r.restaurant_id
    WHERE o.status = 'Delivered'
    GROUP BY r.restaurant_id, r.restaurant_name, c.customer_id, c.name
)
SELECT *
FROM (
    SELECT *,
        DENSE_RANK() OVER (
            PARTITION BY restaurant_id
            ORDER BY total_spent DESC
        ) AS spending_rank
    FROM customer_spending
) ranked
WHERE spending_rank = 1
ORDER BY restaurant_name, spending_rank;



-- Divide customers into 4 spending tiers.

WITH total_spending AS (
    SELECT 
        c.customer_id,
        c.name,
        SUM(o.total_amount) AS total_spent
    FROM Customers c
    JOIN Orders o 
        ON c.customer_id = o.customer_id
    WHERE o.status = 'Delivered'
    GROUP BY c.customer_id, c.name
)
SELECT 
    customer_id,
    name,
    total_spent,
    NTILE(4) OVER (
        ORDER BY total_spent DESC
    ) AS spending_segment
FROM total_spending
ORDER BY spending_segment, total_spent DESC;



--Daily Running Revenue per Restaurant

WITH daily_revenue AS (
    SELECT 
        r.restaurant_id,
        r.restaurant_name,
        DATE(o.order_date) AS order_day,
        SUM(o.total_amount) AS daily_total
    FROM Orders o
    JOIN Restaurants r 
        ON o.restaurant_id = r.restaurant_id
    WHERE o.status = 'Delivered'
    GROUP BY r.restaurant_id, r.restaurant_name, DATE(o.order_date)
)
SELECT 
    restaurant_name,
    order_day,
    daily_total,
    SUM(daily_total) OVER (
        PARTITION BY restaurant_id
        ORDER BY order_day
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_revenue
FROM daily_revenue
ORDER BY restaurant_name, order_day;
