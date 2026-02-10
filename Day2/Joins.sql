-- Active: 1770471809351@@127.0.0.1@3306@demo

-- DROP DATABASE demo;
CREATE DATABASE IF NOT EXISTS demo;

USE demo;

-- Join
-- -------------------------
-- JOIN is used to combine rows from two or more tables based on a related column between them.

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);


CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    dept_id INT,
    manager_id INT
);


INSERT INTO departments (dept_id, dept_name) VALUES
(10, 'HR'),
(20, 'IT'),
(40, 'Finance');


INSERT INTO employees (emp_id, name, dept_id, manager_id) VALUES
(1, 'Rahul', 10, NULL),
(2, 'Sneha', 20, 1),
(3, 'Amit', 30, 1),
(4, 'Neha', NULL, 2);


-- INNER JOIN
-- ---------------
-- Returns only matching rows from both tables.

SELECT e.name, d.dept_name, e.dept_id
FROM employees e
JOIN departments d
ON e.dept_id = d.dept_id;

SELECT * FROM employees;



-- LEFT JOIN (LEFT OUTER JOIN)
-- ------------------------------
-- Returns ALL records from left table + matching from right.

SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id;



-- RIGHT JOIN (RIGHT OUTER JOIN)
-- --------------------------------
-- Returns ALL records from right table + matching from left.


SELECT e.name, d.dept_name
FROM employees e
RIGHT JOIN departments d
ON e.dept_id = d.dept_id;


INSERT INTO employees (emp_id, name, dept_id, manager_id) VALUES
(5, 'Rohit', 10, 1);


-- CROSS JOIN
-- --------------
-- Returns Cartesian product (every row × every row)


SELECT e.name, d.dept_name
FROM employees e
CROSS JOIN departments d;




-- SELF JOIN
-- -----------------
-- A table joined with itself.

-- Example: Suppose employees table has manager_id.

SELECT e.name AS Employee, m.name AS Manager
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.emp_id;









------------------------------------------------------
-- Other Example --

--INNER JOIN using three tables

CREATE DATABASE clinic;

USE clinic;

CREATE TABLE doctors (
    docid INT NOT NULL,
    dname VARCHAR(50) NOT NULL,
    PRIMARY KEY (docid)
);

INSERT INTO doctors (docid, dname)
VALUES
    (1, 'A.VARMA'),
    (2, 'D.GOMES');


CREATE TABLE specialize (
    spid INT NOT NULL,
    description VARCHAR(50) NOT NULL,
    docid INT NOT NULL,
    PRIMARY KEY (spid),
    FOREIGN KEY (docid) REFERENCES doctors(docid)
);

INSERT INTO specialize (spid, description, docid)
VALUES
    (1, 'special1', 1),
    (2, 'special2', 2);



CREATE TABLE timeschedule (
    tid INT NOT NULL,
    tday VARCHAR(3) NOT NULL,
    sit_time TIME NOT NULL,
    docid INT NOT NULL,
    PRIMARY KEY (tid),
    FOREIGN KEY (docid) REFERENCES doctors(docid)
);

INSERT INTO timeschedule (tid, tday, sit_time, docid)
VALUES
    (1, 'MON', '17:00:00', 1),
    (2, 'WED', '08:00:00', 1),
    (3, 'TUE', '16:00:00', 2),
    (4, 'FRI', '09:00:00', 2);

-- display the doctor ID, doctor name, specialization, available day, and sitting time for Doctor ID 1 on Wednesday.
SELECT 
    d.docid, d.dname,
    s.description,
    t.tday, t.sit_time
FROM doctors d 
    INNER JOIN specialize s USING (docid)
    INNER JOIN timeschedule t USING (docid)
WHERE d.docid=1 AND t.tday='WED';


-- step 1
SELECT 
    d.docid, d.dname,
    s.description
FROM doctors d
    INNER JOIN specialize s USING(docid);
-- ON d.docid = s.docid;


--step 2
SELECT 
    d.docid, d.dname,
    s.description,
    t.tday, t.sit_time
FROM doctors d
    INNER JOIN specialize s USING(docid)
    INNER JOIN timeschedule t USING(docid);


--step 3
SELECT 
    d.docid, d.dname,
    s.description,
    t.tday, t.sit_time
FROM doctors d
    INNER JOIN specialize s USING(docid)
    INNER JOIN timeschedule t USING(docid)
WHERE d.docid=1 AND t.tday='WED';