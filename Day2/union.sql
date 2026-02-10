-- Active: 1770471809351@@127.0.0.1@3306@demo


USE demo;

-- UNION
-- ----------------
-- UNION combines the results of two or more SELECT statements into one result set.
-- It removes duplicate rows automatically.


-- UNION ALL
-- ---------
-- UNION ALL also combines results from multiple SELECT statements.
-- It doesn’t try to remove anything.


-- Create first table
CREATE TABLE table_a (
    id INT,
    name VARCHAR(50)
);

-- Create second table
CREATE TABLE table_b (
    id INT,
    name VARCHAR(50)
);


-- Insert data into table_a
INSERT INTO table_a (id, name) VALUES
(1, 'John'),
(2, 'Sarah'),
(3, 'Mike');

-- Insert data into table_b
INSERT INTO table_b (id, name) VALUES
(3, 'Mike'),
(4, 'Anna'),
(5, 'David');


-- UNION Example

SELECT id, name FROM table_a
UNION
SELECT id, name FROM table_b;


-- UNION ALL Example

SELECT id, name FROM table_a
UNION ALL
SELECT id, name FROM table_b;