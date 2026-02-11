--Operator and FUNCTION--
---------------------------------------------

SELECT * FROM publisher;

-- BETWEEN - AND operator with YEAR()
SELECT pub_name,country,pub_city,estd
FROM publisher
WHERE YEAR(estd) BETWEEN 1968 AND 1975;



-- BETWEEN - AND operator with MONTH()
SELECT pub_name,country,pub_city,estd 
FROM publisher        
WHERE MONTH(estd) BETWEEN '02' and '08';


-- BETWEEN - AND operator using logical AND
SELECT pub_name,country,pub_city,estd
FROM publisher          
WHERE MONTH(estd) BETWEEN '05' AND '09' 
AND YEAR(estd) BETWEEN 1950 AND 1975;


-- BETWEEN - AND operator with a date range
SELECT pub_name,country,pub_city,estd
FROM publisher 
WHERE estd BETWEEN '1950-01-01' AND '1975-12-31';


-- NOT BETWEEN AND operator
SELECT pub_name,country,pub_city,estd
FROM publisher
WHERE YEAR(estd)  NOT BETWEEN 1968 AND 1975;


SELECT pub_name,country,pub_city,estd 
FROM publisher 
WHERE MONTH(estd)  NOT BETWEEN '02' and '08';


SELECT pub_name,country,pub_city,estd
FROM publisher 
WHERE MONTH(estd) NOT BETWEEN '05' and '09'
AND YEAR(estd) NOT BETWEEN 1950 AND 1975;



SELECT pub_name,country,pub_city,estd 
FROM publisher             
WHERE estd NOT BETWEEN '1950-01-01' AND '1975-12-31';



-- NULL safe equal to operato
SELECT NULL = 1, NULL = NULL, 3 = NULL;

SELECT NULL <=> 1, NULL <=> NULL, 3 <=> NULL;


-- GREATEST() function

SELECT GREATEST(15,10,25);


SELECT book_name,dt_of_pub,no_page
FROM book_mast
WHERE no_page > GREATEST(200,300,395);


-- IN FUNCTION

SELECT 11 IN (15,10,25);


SELECT book_name,dt_of_pub,no_page
FROM book_mast          
WHERE no_page IN (300,400,500);



-- LEAST

SELECT LEAST(15,10,25);

SELECT LEAST("Z","A","S");

SELECT book_name,dt_of_pub,no_page
FROM book_mast
WHERE no_page<LEAST(500,300,395);






-- CASE operator
-- Simple case

SELECT
    CASE 1 
        WHEN 1 
            THEN 'this is case one'
        WHEN 2 
            THEN 'this is case two' 
        ELSE 'this is not in the case'

END as 'how to execute case statement';


SELECT 
    CASE 4 
        WHEN 1 
            THEN 'this is case one'
        WHEN 2 
            THEN 'this is case two' 
        ELSE 'this is not in the case'

END as 'how to execute case statement';




SELECT 
    CASE 2 
        WHEN 1 
            THEN 'this is case one'
        WHEN 2 
            THEN 'this is case two' 
        ELSE 'this is not in the case'

END as 'how to execute case statement';


SELECT 
    pub_name,
    CASE country
        WHEN 'UK' THEN 'Europe'
        WHEN 'USA' THEN 'America'
        ELSE 'Other'
    END AS region
FROM publisher;




-- Searched case
SELECT 
    CASE  
        WHEN 2>3 
            THEN 'this is true A'
        WHEN 1>3 
            THEN 'this is true B'
        ELSE 'this is false' 
    END;

SELECT 
    CASE  
        WHEN 2<3 
            THEN 'this is true'
            ELSE 'this is false' 
    END;



SELECT 
    book_name,
    book_price,
    CASE
        WHEN book_price <= 150 THEN 'Budget'
        WHEN book_price BETWEEN 151 AND 200 THEN 'Standard'
        ELSE 'Premium'
    END AS price_cat
FROM book_mast;



-- CASE with Aggregate
-- Count expensive and cheap book

SELECT
    COUNT(CASE WHEN book_price >= 200 THEN 1 END) as expensive,
    COUNT(CASE WHEN book_price  < 200 THEN 1 END) as cheap
FROM book_mast;


-- CASE with Group BY
-- Publisher Revenue Category

SELECT 
    p.pub_name, 
    SUM(b.book_price) as total_rev,
    CASE
        WHEN SUM(b.book_price) > 300 THEN 'High'
        WHEN SUM(b.book_price) > 200 THEN 'MEDIUM'
        ELSE 'Low'
    END AS rev_cat
FROM publisher p
JOIN book_mast b USING(pub_id)
GROUP BY p.pub_name


-- CASE in ORDER BY
SELECT
    book_name,
    book_price
FROM book_mast
ORDER BY
    CASE 
        WHEN book_price >= 200 THEN 1
        ELSE 2
    END;


-- IF() function

SELECT IF(1>3,'a','b');

SELECT book_name,
IF(pub_lang='English',"English Book","Other Language") 
AS Language 
FROM book_mast;



SELECT book_name,isbn_no,
IF(
    (SELECT COUNT(*) FROM book_mast WHERE pub_lang='English')<
    (SELECT COUNT(*) FROM book_mast WHERE pub_lang<>'English'),
    -- if true
    (CONCAT("Pages: ",no_page)),
    -- if false
    (CONCAT("Price: ",book_price))) 
AS "Page / Price"
FROM book_mast;



SELECT book_id, book_name, 
IF(pub_lang IS NULL,'N/A',pub_lang) AS "Pub. Language"
FROM book_mast;



SELECT SUM(IF(pub_lang = 'English',1,0))   AS English,
       SUM(IF(pub_lang <> 'English',1,0)) AS "Non English"
FROM purchase;



SELECT COUNT(IF(country = 'USA',1,NULL))  USA,
       COUNT(IF(country = 'UK',1,NULL))  UK,
       COUNT(IF(country = 'India',1,NULL))  India,
       COUNT(IF(country = 'Australia',1,NULL))  Australia
FROM publisher;







---------------------------------------------------
-- String FUNCTION


-- ASCII() function
SELECT ASCII('a')AS Lower_Case, ASCII('A') AS Upper_Case;

SELECT aut_name,ASCII(aut_name)as "ASCII value of 1st character" 
FROM author 
WHERE ASCII(aut_name)<70;



-- BIN FUNCTION

SELECT BIN(4);


-- Char LENGTH

SELECT CHAR_LENGTH('test string');


SELECT pub_name,
CHAR_LENGTH(pub_name)  AS 'character length' 
FROM publisher 
WHERE CHAR_LENGTH(pub_name)>20;


-- CHAR
SELECT CHAR(67,72,65,82);


SELECT CONCAT_WS('$','1st string','2nd string');

SELECT CONCAT_WS(',',aut_id,aut_name,country,home_city) 
FROM author 
WHERE country<>'USA';


SELECT CONCAT(pub_city,'--> ',country)
FROM publisher;


SELECT CONCAT(pub_city,'--> ',country)
FROM publisher
WHERE CONCAT(pub_name,' ',country_office)="Ultra Press Inc. London";



SELECT CONCAT(book_name,'--> ',pub_lang)
FROM book_mast;




-- FORMAT
SELECT book_name,FORMAT(book_price,4) 
FROM book_mast
WHERE book_price>150;



-- INSERT
SELECT INSERT('Originalstring', 4, 5, ' insert ');


SELECT INSERT('Originalstring', 4,15, ' insert ');

SELECT aut_id, INSERT(aut_id,4,0, '/')
FROM author 
WHERE country='USA';



--INSTR
SELECT INSTR('myteststring','st');



SELECT book_name, INSTR(book_name,'an') 
FROM book_mast 
WHERE INSTR(book_name,'an')>0;


--LCASE
SELECT LCASE('MYTESTSTRING');



SELECT pub_name,LCASE(pub_name) 
FROM publisher 
WHERE country<>'USA';

SELECT pub_name,LOWER(pub_name) 
FROM publisher 
WHERE country<>'USA';



SELECT UCASE('myteststring');


SELECT pub_name,UCASE(pub_name) 
FROM publisher 
WHERE country<>'USA';

SELECT pub_name,UPPER(pub_name) 
FROM publisher 
WHERE country<>'USA';



SELECT pub_name, LEFT(pub_name, 5) 
FROM publisher;


SELECT pub_name, RIGHT(pub_name, 5) 
FROM publisher;


SELECT pub_name,LENGTH(pub_name) FROM publisher;


SELECT LOCATE('st','myteststring');

SELECT LOCATE('st','mytestjjjjstring',6);


SELECT pub_name,LOCATE('at',pub_name) 
FROM publisher 
WHERE locate('at',pub_name)>0;


SELECT pub_name,LOCATE('at',pub_name),
LOCATE('at',pub_name,16)
FROM publisher 
WHERE LOCATE('at',pub_name)>0;



SELECT LPAD('Hellow',10,'*');
SELECT LPAD(country,25-(length(country)),'*')
FROM publisher;

SELECT RPAD('Hellow',10,'*');



SELECT aut_name,RPAD(aut_name,25,'*')
FROM author 
WHERE country='UK';

SELECT '            Hellow', LTRIM('     Hellow');


SELECT ' Hellow   ', RTRIM(' Hellow');


SELECT '   Hellow   ', TRIM(' Hellow');



SELECT REPLACE('SQLresource','ur','r');


SELECT pub_city,country,
REPLACE(country,'K','SA') 
FROM publisher 
WHERE country='UK';



select REVERSE('PANKAJ');

SELECT pub_city,country,
REVERSE(country)
FROM publisher 
WHERE country='USA';


SELECT 'start', SPACE(10), 'end';

SELECT aut_id,aut_name,aut_id,space(10), aut_name 
FROM author 
WHERE country='USA';






-----------------------------------------------------------

-- MATH FUNCTION

SELECT ABS(5);


SELECT ACOS(.1);

SELECT ASIN(.4);


SELECT 12 DIV 3;


SELECT EXP(1);

SELECT EXP(-1);


SELECT FLOOR(1.72);


SELECT FLOOR (-2.72);


SELECT LOG(3);


SELECT LOG(2,2);


SELECT MOD(17,5);


SELECT POW(3, 2);



SELECT RAND();


SELECT RAND(),RAND(2),RAND(2);


SELECT pub_name,country,no_of_branch,
   FLOOR(RAND(2)*20)
      FROM publisher
WHERE no_of_branch>FLOOR(RAND(2)*20);



SELECT ROUND(4.43);


SELECT ROUND(-4.53);



SELECT SIGN(-145), SIGN(0), SIGN(145);


SELECT SQRT(25);


SELECT TRUNCATE(2.465,1);


SELECT TRUNCATE(142.465,-2);






