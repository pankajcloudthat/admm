-- Active: 1770471809351@@127.0.0.1@3306@demo
-- Create user
-- CREATE USER username IDENTIFIED BY password;

CREATE USER 'amit' IDENTIFIED BY 'Amit@123';


-- Show users
select host, user from mysql.user;


-- Delete user
delete from mysql.user where user = 'amit';


-- Change PASSWORD

ALTER USER amit IDENTIFIED BY 'amit';


Select CURRENT_USER();
SHOW GRANTS FOR CURRENT_USER();

-- Viewing permissions of an User Account:

SHOW GRANTS FOR amit;


-- Granting Privileges
-- ----------------------------

-- GRANT privileges_names ON object TO user;

-- GRANT privilege_name(s)   
-- ON object   
-- TO user_account_name;  

use ecommerce;

SHOW TABLES;
SELECT DATABASE()

GRANT SELECT ON ecommerce.users to amit;
SHOW GRANTS FOR amit;

-- USAGE Permission means the user can connect to MySQL, but has no permissions to do anything.


-- Privileges can be applied.
-- --------------------------------

-- SELECT: It enables us to view the result set from a specified table.
-- INSERT: It enables us to add records in a given table.
-- DELETE: It enables us to remove rows from a table.
-- CREATE: It enables us to create tables/schemas.
-- ALTER: It enables us to modify tables/schemas.
-- UPDATE: It enables us to modify a table.
-- DROP: It enables us to drop a table.
-- INDEX: It enables us to create indexes on a table.
-- ALL: It enables us to give ALL permissions except GRANT privilege.
-- GRANT: It enables us to change or add access rights.


use emp;

-- Grant SELECT
GRANT SELECT ON users TO'amit'@'localhost';
SHOW GRANTS FOR amit@localhost;



-- Granting more than one Privilege 
GRANT SELECT, INSERT, DELETE, UPDATE ON users TO 'amit'@'localhost';
SHOW GRANTS FOR amit@localhost;



-- Granting All the Privilege
GRANT ALL ON Users TO 'amit'@'localhost';
SHOW GRANTS FOR amit@localhost;



-----------------------

-- Grant PRIVILEGES to all USERs
-- GRANT SELECT  ON Users TO '*'@'localhost;



-- Grant Privileges on Functions/Procedures
-- GRANT EXECUTE ON [ PROCEDURE | FUNCTION ] object TO user; 


-- GRANT EXECUTE ON FUNCTION [Functio_Name] TO 'amit'@localhost'; 


-- GRANT EXECUTE ON PROCEDURE [Procedure_Name] TO 'amit'@localhost'; 


-- REVOKE EXECUTE ON [ PROCEDURE | FUNCTION ] object FROM user; 










----------------------------------------------

-- Revoking Privileges from a Table

REVOKE SELECT ON  users FROM 'amit'@'localhost';
SHOW GRANTS FOR amit@localhost;




REVOKE ALL ON emp.users FROM 'amit'@'localhost';

SHOW GRANTS FOR amit@localhost;












--------------------------------------------
-- Role

CREATE ROLE IF NOT EXISTS 'TestRole_ReadOnly';


GRANT SELECT ON * . * TO 'TestRole_ReadOnly';


GRANT 'TestRole_ReadOnly' TO 'amit'@'localhost';

SHOW GRANTs FOR amit@localhost USING TestRole_ReadOnly;


DROP ROLE TestRole_ReadOnly;
