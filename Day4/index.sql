-- Active: 1770471809351@@127.0.0.1@3306@demo
-- MySQL Indexes & Performance Optimization
-- ------------------------------------------

-- What Is an Index in MySQL?
-- -----------------------------
-- It's a data structure (typically a B-Tree) that improves the speed of data retrieval operations on a table.


-- Think of it like:
-- A book index — instead of scanning every page, you jump directly to the topic.

-- Without an index → MySQL performs a full table scan
-- With an index → MySQL performs a fast lookup



-- Why Indexes Are Important
-- ----------------------------

-- Indexes are critical for:

-- Faster SELECT queries
-- Efficient filtering (WHERE)
-- Faster sorting (ORDER BY)
-- Faster joins (JOIN)
-- Enforcing uniqueness (e.g., PRIMARY KEY, UNIQUE)

-- But:

-- Indexes consume storage
-- They slightly slow down INSERT, UPDATE, and DELETE


-- How to Create Indexes in MySQL
-- Basic Syntax

-- CREATE INDEX index_name 
-- ON table_name(column_name);



-- EXPLAIN
-- -----------
-- EXPLAIN is a command in MySQL that shows how MySQL executes a query.

-- It tells you:

-- Which index is used (or not used)
-- How many rows are scanned
-- Join order
-- Whether it’s doing a full table scan



USE demo;

Drop Table if exists users;
CREATE TABLE users(
  id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL,
  age TINYINT UNSIGNED NOT NULL
);

INSERT INTO users VALUES
(1, 'John', 'john@email.com', 25),
(2, 'Alice', 'alice@email.com', 30),
(3, 'Bob', 'bob@email.com', 22),
(4, 'David', 'david@email.com', 28),
(5, 'Emma', 'emma@email.com', 25),
(6, 'Chris', 'chris@email.com', 35),
(7, 'Sophia', 'sophia@email.com', 29),
(8, 'Daniel', 'daniel@email.com', 40),
(9, 'Olivia', 'olivia@email.com', 31),
(10, 'Liam', 'liam@email.com', 27);

EXPLAIN SELECT * FROM users WHERE age = 30;


-- id

-- The identifier of the SELECT query.
-- If you have subqueries or joins, different parts get different IDs.
-- Higher id usually runs first (especially with subqueries).


-- select_type

-- Tells what type of SELECT it is.
-- Common values:

-- SIMPLE → No subqueries or UNION
-- PRIMARY → Outer query in subquery
-- SUBQUERY → Inner subquery
-- DERIVED → Subquery in FROM clause
-- UNION → Part of UNION
-- DEPENDENT SUBQUERY → Subquery depends on outer query (can be slower)

Explain SELECT * FROM users WHERE age > (SELECT AVG(age) FROM users);

-- table

-- The table MySQL is accessing in that step.
-- If you join 3 tables, you’ll see 3 rows — one per table.


-- type (Very Important)

-- This shows how MySQL accesses the table.
-- Think of it as performance level.

-- Best → Worst:

-- | Type   | Meaning                                |
-- | ------ | -------------------------------------- |
-- | system | Only one row                           |
-- | const  | Primary key or unique index used       |
-- | eq_ref | One row per join                       |
-- | ref    | Index used, but multiple rows possible |
-- | range  | Using index range (BETWEEN, >, <)      |
-- | index  | Full index scan                        |
-- | ALL    | Full table scan                        |

EXPLAIN SELECT * FROM users WHERE id = 10;

Explain SELECT * FROM users WHERE age > (SELECT age FROM users WHERE id = 5);

-- possible_keys
-- Indexes MySQL could use.
-- If this is NULL → No useful index exists.

-- key
-- The actual index MySQL chose.
-- If NULL → No index used.

-- key_len
-- How many bytes of the index are used.
-- Helpful when debugging composite indexes.

-- Example:
-- Index on (first_name, last_name)
-- If only first_name used → shorter key_len


-- ref
-- Shows which column or constant is compared to the index.
-- Example:
-- ref: const
-- Means it’s comparing to a constant value (like WHERE id = 5).


-- rows
-- Estimated number of rows MySQL thinks it must examine.
-- Lower is better.
-- Important: this is an estimate, not exact.


-- filtered
-- Percentage of rows that pass the condition.
-- Example:
-- rows = 1000
-- filtered = 10
-- → MySQL expects 100 rows after filtering


-- Extra (Very Important)
-- Additional info about query execution.

-- Common values:
-- Using where → WHERE condition applied
-- Using index → Covering index used (good!)
-- Using temporary → Temporary table created (can be slow)
-- Using filesort → Sorting done manually (can be slow)
-- Range checked for each record → Not ideal







-- Primary Index (Primary Key)
-- -----------------------------
-- Automatically indexed
-- Unique
-- Cannot be NULL


EXPLAIN SELECT * FROM users WHERE id = 10;


-- Unique Index
-- ----------------
-- A unique index is an index that prevents duplicate values in one or more columns.

-- It ensures that:
-- No two rows can have the same value in the indexed column(s).

-- Why It’s Important

-- Maintains data integrity
-- Prevents duplicate entries
-- Speeds up lookups

-- Commonly used for:
--    Email addresses
--    Username
--    National ID
--    Account numbers



EXPLAIN SELECT * FROM users
WHERE email = "bob@email.com";

CREATE UNIQUE INDEX idx_email
ON users(email);

DESC users;


EXPLAIN SELECT * FROM users
WHERE email = "bob@email.com";

SHOW INDEX FROM users;




-- How to drop index

-- DROP INDEX idx_email on users;
-- or
-- ALTER TABLE users
-- DROP INDEX idx_email;





-- Single-Column Index
-- ---------------------
-- A single-column index is an index created on one column only.


-- This index helps when queries filter or sort using that one column.
-- CREATE INDEX idx_name 
-- ON users(name);

-- When to Use It
--    Column frequently used in WHERE
--    Column used in ORDER BY
--    Column used in JOIN
--    High selectivity (many unique values)



-- If you run the query:
EXPLAIN SELECT * FROM users 
WHERE name = 'John';

-- If name is indexed:
--  MySQL uses the index
--  Faster lookup
--  No full table scan


CREATE INDEX idx_name
ON users(name);


EXPLAIN SELECT * FROM users 
WHERE name = 'John';


EXPLAIN SELECT * FROM users 
ORDER BY name;


-- MySQL might decide:

-- “I can use the name index to sort”
-- But then I still need ALL columns
-- So I must fetch full rows
-- Sometimes it's cheaper to scan + sort instead


EXPLAIN SELECT name FROM users 
ORDER BY name;




-- Multi-Column Index (Composite Index)
-- -----------------------------------------

-- A multi-column index (also called composite index) is an index created on two or more columns together.


SHOW INDEX FROM users;
DROP INDEX idx_name ON users;
DROP INDEX idx_email ON users;
DROP INDEX idx_name_email ON users;


EXPLAIN SELECT * FROM users
WHERE name = 'John' and email = 'john@email.com';


CREATE INDEX idx_name_email 
ON users(name, email);


EXPLAIN SELECT * FROM users
WHERE name = 'John' and email = 'john@email.com';

EXPLAIN SELECT * FROM users
WHERE email = 'john@email.com' and name = 'John';



-- Now the index stores values sorted by:
-- name then email



-- How It Works (Very Important Concept)

-- Composite indexes follow something called the:
-- Leftmost Prefix Rule

-- If index is: (name, email)

-- It works for:
-- ✔ WHERE name = 'John'
-- ✔ WHERE name = 'John' AND email = 'john@email.com'

EXPLAIN SELECT * FROM users
WHERE name = 'john';

-- It does NOT efficiently work for:
-- X WHERE email = 'john@email.com'

EXPLAIN SELECT * FROM users
WHERE email = 'john@email.com';


-- Single vs Multi-Column Index Comparison

-- | Feature                          | Single-Column Index | Multi-Column Index   |
-- | -------------------------------- | ------------------- | -------------------- |
-- | Columns Indexed                  | 1                   | 2 or more            |
-- | Simpler                          | Yes                 | Slightly complex     |
-- | Good for multi-condition queries | Not ideal           | Best choice          |
-- | Order matters                    | No                  | Yes (very important) |