-- Procedure
-- ---------------

-- A Stored Procedure in MySQL is a pre-written set of SQL statements that is stored inside the database and can be executed (called) whenever needed.

-- Think of it like:
-- A reusable SQL program saved inside the database.

-- Instead of writing the same SQL queries again and again, 
-- you write them once inside a procedure and just CALL it.



-- Why Do We Use Stored Procedures?

-- Reusability (write once, use many times)
-- Better performance (precompiled and stored)
-- Reduced network traffic (execute multiple queries in one call)
-- Security (users can execute procedure without direct table access)
-- Cleaner business logic inside DB


-- Basic Syntax
-- DELIMITER //

-- CREATE PROCEDURE procedure_name()
-- BEGIN
--     -- SQL statements
-- END //

-- DELIMITER ;


-- Example

USE demo;

SHOW TABLES;


DELIMITER //
CREATE PROCEDURE GetAllUsers()
BEGIN
    SELECT * FROM users;
END //

DELIMITER;

CALL GetAllUsers();

-- Show Procedures in Current Database
SHOW PROCEDURE STATUS
WHERE Db = DATABASE();


-- Show Procedures with definition in Current Database
SELECT ROUTINE_NAME, ROUTINE_DEFINITION
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
AND ROUTINE_SCHEMA = DATABASE();


-- Drop procedure
DROP PROCEDURE `GetAllUsers`;





-- Procedure with Parameters
-- ---------------------------
DELIMITER //
CREATE PROCEDURE GetUsersById(IN user_id INT)
BEGIN
    SELECT * 
    FROM users
    WHERE id > user_id;
END //
DELIMITER;


CALL GetUsersById(1);


-- This is wrong I want a user with the given id

-- First drop the procedure

DROP PROCEDURE IF EXISTS GetUsersById;

-- Now modify the definition

CREATE PROCEDURE GetUsersById(IN user_id INT)
BEGIN
    SELECT * 
    FROM users
    WHERE id = user_id;
END;

CALL GetUsersById(1);



-- Types of Parameters MySQL supports:

-- IN → Input parameter (default)
-- OUT → Output parameter
-- INOUT → Both input and output


-- Example with OUT:


CREATE PROCEDURE GetUserCount(OUT total INT)
BEGIN
    SELECT COUNT(*) INTO total
    FROM users;
END;

CALL GetUserCount(@count);
SELECT @count;


-- Procedure with INOUT parameter

-- An INOUT parameter:
-- Accepts a value when calling the procedure
-- Can modify that value inside the procedure
-- Returns the modified value back


-- Example

CREATE PROCEDURE IncreaseValue(INOUT num INT)
BEGIN
    SET num = num + 10;
END;


-- Call the procedure
-- Important: INOUT requires a session variable (@variable)

SET @v = 5;
CALL IncreaseValue(@v);
SELECT @v;







-- Function
-- -------------
-- A stored program that accepts input and MUST return exactly one value.

-- Unlike procedures:
-- Function returns a single value
-- Can be used inside SELECT


-- Basic Syntax
-- DELIMITER //

-- CREATE FUNCTION function_name(parameters)
-- RETURNS datatype
-- DETERMINISTIC
-- BEGIN
--     -- logic
--     RETURN value;
-- END //

-- DELIMITER ;


-- NOte: When binary logging (log_bin) is ON, MySQL becomes strict about stored functions
-- Becasue Non-deterministic or data-modifying functions can break replication consistency.
-- So MySQL forces you to explicitly declare what kind of function it is.


-- MySQL requires one of these in function definition:

-- DETERMINISTIC
-- NOT DETERMINISTIC
-- NO SQL
-- READS SQL DATA
-- MODIFIES SQL DATA


-- Simple Example
-- Function to add two numbers:
DELIMITER //

CREATE FUNCTION AddNumbers(a INT, b INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN a + b;
END //

DELIMITER ;

SELECT AddNumbers(5,7);


-- What is DETERMINISTIC?
-- ---------------------------

-- It means:
-- Same input → same output

-- Example:
-- AddNumbers(2,3) always gives 5 → deterministic

-- If function depends on:
-- NOW()
-- RAND()
-- Data changes

-- Then it may be NOT DETERMINISTIC.


-- Example NOT DETERMINISTIC
-- If function read from table
DELIMITER //

CREATE FUNCTION GetUserCount()
RETURNS INT
NOT DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM users;

    RETURN total;
END //

DELIMITER ;

SELECT GetUserCount();

-- Easy But Unsafe
-- SET GLOBAL log_bin_trust_function_creators = 1;

-- What this does:
-- Disables safety check
-- Allows creating function without strict declaration


-- What You Should Do (Best Practice)
-- DETERMINISTIC or NOT DETERMINISTIC
-- +
-- NO SQL / READS SQL DATA / MODIFIES SQL DATA




-- Function to Check if User is Adult
CREATE FUNCTION IsUserAdult(p_id INT)
RETURNS VARCHAR(10)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE user_age INT;

    SELECT age INTO user_age
    FROM users
    WHERE id = p_id;

    IF user_age >= 18 THEN
        RETURN 'Adult';
    ELSE
        RETURN 'Minor';
    END IF;
END;

SELECT id, name, IsUserAdult(id) AS status
FROM users;
