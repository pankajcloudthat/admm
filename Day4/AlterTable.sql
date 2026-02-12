DROP DATABASE IF EXISTS demo;

CREATE DATABASE demo;
use demo;

-- CHECk age > 18
-- CHECK major in value should be 'Biology','Computer Science', 'Machine Learning'
DROP TABLE IF EXISTS student_2;

CREATE TABLE student_2 (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  age TINYINT NOT NULL,
  major VARCHAR(40) CHECK(major in('Biology','Computer Science', 'Machine Learning')),
  CONSTRAINT chk_age CHECK (age >= 18)
);

DESC student_2;

SHOW CREATE TABLE student_2;

INSERT INTO student_2 VALUES
(1, 'Jack Sparrow', 19, 'Biology', 'jack.sparrow@example.com'),
(2, 'Kate Winslet', 20, 'Computer Science', 'kate.winslet@example.com'),
(3, 'Jack Sparrow Jr.', 19,  'Biology', 'jackjr@example.com'),
(4, 'Katey Thomas', 20,  'Computer Science', 'katey.thomas@example.com'),
(5, 'Kathren', 22, 'Computer Science', 'kathren@example.com'),
(6, 'Jacky Chen', 27, 'Biology', 'jacky.chen@example.com');

ALTER TABLE student_2
ADD email VARCHAR(50) FIRST;

DESC student_2;

ALTER TABLE student_2
DROP COLUMN email;

ALTER TABLE student_2
ADD COLUMN email VARCHAR(50) AFTER name;


DESC student_2;

ALTER TABLE student_2
ADD COLUMN email VARCHAR(50);


-- Run the aboev insert statement
SELECT * FROM student_2;


ALTER TABLE student_2
ADD phone VARCHAR(15) NOT NULL;


ALTER TABLE student_2
ADD status VARCHAR(20) DEFAULT 'active';

SELECT * FROM student_2;



-- Add Multiple Columns
ALTER TABLE student_2
ADD address VARCHAR(100),
ADD admission_date DATE;





-- Modify Column (Change Data Type / Size)
-- ------------------------------------------

DESC student_2;

ALTER TABLE student_2
MODIFY name VARCHAR(100);



ALTER TABLE student_2
MODIFY age INT;



-- Rename Column
-- ------------------

DESC student_2;

-- (MySQL 8+)
ALTER TABLE student_2
RENAME COLUMN name TO full_name;


-- Older MySQL:
ALTER TABLE student_2
CHANGE full_name name VARCHAR(50);



-- Add Constraint
-- -------------------

DESC student_2;

ALTER TABLE student_2
ADD CONSTRAINT unique_name UNIQUE(name);



-- Update constraint
-- ------------------

SHOW CREATE TABLE student_2;

ALTER TABLE student_2
DROP CONSTRAINT chk_age;

ALTER TABLE student_2
ADD CONSTRAINT chk_age_range CHECK (age BETWEEN 18 AND 80);

SELECT * FROM student_2;

DELETE FROM student_2
WHERE student_id = 6;

DESC student_2;

INSERT INTO student_2 VALUES
(8, 'Jacky Chen', 127, 'Biology', 'jacky.chen@example.com', '898989', 'active','a','2020-12-20');


-- Another Example
-- -----------------------------
ALTER Table student_2
DROP CONSTRAINT student_2_chk_1;

ALTER TABLE student_2
ADD CONSTRAINT check_major CHECK(major in('Biology','Computer Science', 'Machine Learning', 'LIFE SCIENCE'))



-- Drop Constraint
-- Drop CHECK (MySQL 8+):
ALTER TABLE student_2
DROP CHECK chk_age_range;



-- Drop UNIQUE:
ALTER TABLE student_2
DROP INDEX unique_name;



-- Add FOREIGN KEY

CREATE TABLE department (
  department_id INT PRIMARY KEY AUTO_INCREMENT,
  department_name VARCHAR(100) NOT NULL UNIQUE,
  building VARCHAR(100)
);

INSERT INTO department (department_name, building)
VALUES 
('Biology', 'Block A'),
('Computer Science', 'Block B'),
('Machine Learning', 'Block C');


SELECT * FROM department;

ALTER TABLE student_2
ADD department_id INT;


INSERT INTO student_2 (name, age, major, department_id, phone)
VALUES 
('Rahul', 20, 'Computer Science', 2, '454545'),
('Aisha', 22, 'Biology', 1,'343434');

SELECT * FROM student_2;


ALTER TABLE student_2
ADD CONSTRAINT fk_dept
FOREIGN KEY (department_id)
REFERENCES department(department_id);


INSERT INTO student_2 (name, age, major, department_id, phone)
VALUES 
('Rocky', 20, 'Computer Science', 3, '454545'),
('Alita', 22, 'Biology', 1,'343434');

-- or

ALTER TABLE student_2
ADD CONSTRAINT ffk_dept
FOREIGN KEY (department_id)
REFERENCES department(department_id)
ON DELETE SET NULL
ON UPDATE CASCADE;



-- Drop FOREIGN KEY:
ALTER TABLE student_2
DROP FOREIGN KEY fk_dept;



-- Update Department ID
UPDATE department 
SET department_id = 10 
WHERE department_id = 2;





DESC student_2;

-- Add / Remove NOT NULL
ALTER TABLE student_2
MODIFY age TINYINT NULL;



ALTER TABLE student_2
MODIFY major VARCHAR(40) NOT NULL;



-- Add DEFAULT to Existing Column
ALTER TABLE student_2
ALTER major SET DEFAULT 'Biology';

-- or

ALTER TABLE student_2
MODIFY major VARCHAR(40) DEFAULT 'Biology';


-- Drop DEFAULT
ALTER TABLE student_2
ALTER major DROP DEFAULT;
