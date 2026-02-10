-- Active: 1770471809351@@127.0.0.1@3306@demo

-- Add constraints to table
-- ----------------------------

-- What Are Constraints?

-- Constraints are rules applied to table columns to control what data can be inserted or updated.
-- They help maintain data integrity and accuracy.


-- Common Types of Constraints
-- -----------------------------------------------------
-- | Constraint  | Purpose                             |
-- | ----------- | ----------------------------------- |
-- | NOT NULL    | Column cannot have NULL value       |
-- | UNIQUE      | All values must be different        |
-- | PRIMARY KEY | Unique + Not Null (main identifier) |
-- | FOREIGN KEY | Links to another table              |
-- | CHECK       | Limits values based on condition    |
-- | DEFAULT     | Sets default value if none provided |

DROP DATABASE IF EXISTS demo;

CREATE DATABASE demo;
use demo;

DROP TABLE IF EXISTS student_2;

-- CHECk age > 18
-- CHECK major in value should be 'Biology','Computer Science', 'Machine Learning'
CREATE TABLE student_2 (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  age TINYINT NOT NULL,
  major VARCHAR(40) CHECK(major in('Biology','Computer Science', 'Machine Learning')),
  email VARCHAR(50),
  CONSTRAINT chk_age CHECK (age >= 18)
);

SELECT * 
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'student_2';

INSERT INTO student_2 VALUES
(1, 'Jack Sparrow', 19, 'Biology', 'jack.sparrow@example.com');


INSERT INTO student_2 VALUES
(2, 'Kate Winslet', 20, 'Computer Science', 'kate.winslet@example.com'),
(3, 'Jack Sparrow Jr.', 19,  'Biology', 'jackjr@example.com'),
(4, 'Katey Thomas', 20,  'Computer Science', 'katey.thomas@example.com');


-- Select rows from a Table or View 'student_2' in schema 'demo'
SELECT * FROM demo.student_2;

INSERT INTO student_2 VALUES
(5, 'Kathren', 12, 'Computer Science', 'kathren@example.com');

INSERT INTO student_2 VALUES
(5, 'Kathren', 22, 'Computer Science', 'kathren@example.com');


INSERT INTO student_2 VALUES
(6, 'Jacky Chen', 127, 'Biology', 'jacky.chen@example.com');

INSERT INTO student_2 VALUES
(7, 'Jack Smith', 600, 'Biology', 'jack.smith@example.com');

select * from student_2;


-- Age 127 is incorrect
------------------------

DROP TABLE IF EXISTS student_2;

CREATE TABLE student_2 (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  age TINYINT NOT NULL,
  major VARCHAR(40) CHECK(major in('Biology','Computer Science', 'Machine Learning')),
  email VARCHAR(50) UNIQUE,
  CONSTRAINT chk_age_range CHECK (age BETWEEN 18 AND 80)
);

DESC student_2;

-- List all constraints
SELECT * 
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'student_2';


SELECT * FROM student_2;

INSERT INTO student_2 VALUES
(1, 'Jack Sparrow', 19, 'Biology', 'jack.sparrow@example.com'),
(2, 'Kate Winslet', 20, 'Computer Science', 'kate.winslet@example.com'),
(3, 'Jack Sparrow Jr.', 19,  'Biology', 'jackjr@example.com'),
(4, 'Katey Thomas', 20,  'Computer Science', 'katey.thomas@example.com'),
(5, 'Kathren', 22, 'Computer Science', 'kathren@example.com');

INSERT INTO student_2 VALUES
(6, 'Jacky Chen', 127, 'Biology', 'jacky.chen@example.com');


INSERT INTO student_2 VALUES
(6, 'Jacky Chen', 27, 'Biology', 'jacky.chen@example.com');


SELECT * FROM student_2;


-- Update data
-- -----------------------

-- Update a Single Row (by ID)
UPDATE student_2
SET Email = 'jackjr@example.com'
WHERE Student_ID = 2;


SELECT * FROM student_2 WHERE student_id = 2;


SELECT * FROM student_2;





-- Update Multiple Columns
UPDATE student_2
SET Major = 'Biology',
    Email = 'kate.w@example.com'
WHERE email = 'kate.winslet@example.com';


SELECT * FROM student_2
WHERE Name = 'Kate Winslet';


-- Update Multiple Rows (Condition Based)
UPDATE student_2
SET major = 'Life Science'
WHERE major = "Biology";



SELECT * FROM student_2
WHERE major = "Machine Learning";