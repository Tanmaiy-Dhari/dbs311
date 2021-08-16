-- ***********************
-- Student Name: Jeongseon Yoon
-- Student ID: 109687202
-- Date: June 25, 2021
-- Purpose: Lab 05 - DBS311NDD
-- ***********************

-- Question 1 - Write a store procedure that get an integer number and prints "The number is even." If a number is divisible by 2. 
-- Otherwise, it prints "The number is odd."
-- Q1 SOLUTION --
CREATE OR REPLACE PROCEDURE even_odd (intNum IN NUMBER) AS
BEGIN
    IF MOD(intNum, 2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('The number is even.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The number is odd.');
    END IF;
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Unexpected Error!');
END;
/
EXEC even_odd(8);
EXEC even_odd(11);

-- Question 2 - Create a stored procedure named find_employee. 
-- This procedure gets an employee number and prints the following employee information:
-- First name Last name Email Phone Hire date Job title
-- Q2 SOLUTION --
CREATE OR REPLACE PROCEDURE find_employee (empNum IN NUMBER) AS
    oFirstName VARCHAR2(255);
    oLasttName VARCHAR2(255);
    oEmail VARCHAR2(255);
    oPhone VARCHAR2(50);
    oHireDate DATE;
    oJobTitle VARCHAR2(255);
BEGIN
    SELECT first_name, last_name, email, phone, hire_date, job_title
    INTO oFirstName, oLasttName, oEmail, oPhone, oHireDate, oJobTitle
    FROM employees
    WHERE employee_id = empNum;
    DBMS_OUTPUT.PUT_LINE('First name: ' || oFirstName);
    DBMS_OUTPUT.PUT_LINE('Last name: ' || oLasttName);
    DBMS_OUTPUT.PUT_LINE('Email: ' || oEmail);
    DBMS_OUTPUT.PUT_LINE('Phone: ' || oPhone);
    DBMS_OUTPUT.PUT_LINE('Hire date: ' || oHireDate);
    DBMS_OUTPUT.PUT_LINE('Job title: ' || oJobTitle);
EXCEPTION
WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too Many Rows Returned!');
WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No Data Found!');
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Unexpected Error!');
END;
/
EXEC find_employee(107);

-- Question 3 - Every year, the company increases the price of all products in one category. 
-- For example, the company wants to increase the price (list_price) of products in category 1 by $5. 
-- Write a procedure named update_price_by_cat to update the price of all products in a given category
-- and the given amount to be added to the current price if the price is greater than 0. 
-- The procedure shows the number of updated rows if the update is successful.
-- Q3 SOLUTION --
CREATE OR REPLACE PROCEDURE update_price_by_cat (categoryId IN NUMBER,
        amount IN NUMBER) AS
    rows_updated NUMBER := 0;
BEGIN
    UPDATE products
    SET list_price = list_price + amount
    WHERE category_id = categoryId
    AND list_price > 0;
    
    rows_updated := sql%rowcount;
    DBMS_OUTPUT.PUT_LINE('Updated rows: ' || rows_updated);
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Unexpected Error!');
END;
/
EXEC update_price_by_cat(2, 1000);

-- Question 4 - Every year, the company increase the price of products whose price is less than the average price of all products by 1%. (list_price * 1.01). 
-- Write a stored procedure named update_price_under_avg. This procedure do not have any parameters. You need to find the average price of all products and store it into a variable of the same type. 
-- If the average price is less than or equal to $1000, update products’ price by 2% if the price of the product is less than the calculated average. 
-- If the average price is greater than $1000, update products’ price by 1% if the price of the product is less than the calculated average. 
-- The query displays an error message if any error occurs. Otherwise, it displays the number of updated rows.
-- Q4 SOLUTION --
CREATE OR REPLACE PROCEDURE update_price_under_avg AS
    rows_updated NUMBER := 0;
    avg_price NUMBER := 0;
BEGIN
    SELECT AVG(list_price)
    INTO avg_price
    FROM products;
    
    IF avg_price > 1000 THEN
        UPDATE products
        SET list_price = list_price * 1.01;
    ELSE
        UPDATE products
        SET list_price = list_price * 1.02;
    END IF;
    
    rows_updated := sql%rowcount;
    DBMS_OUTPUT.PUT_LINE('Updated rows: ' || rows_updated);
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Unexpected Error!');
END;
/
EXEC update_price_under_avg();

-- Question 5 - The company needs a report that shows three category of products based their prices. 
-- The company needs to know if the product price is cheap, fair, or expensive.
-- Write a procedure named product_price_report to show the number of products in each price category
-- Q5 SOLUTION --
CREATE OR REPLACE PROCEDURE product_price_report AS
    rows_updated NUMBER := 0;
    avg_price NUMBER := 0;
    min_price NUMBER := 0;
    max_price NUMBER := 0;
    cheap_count NUMBER := 0;
    fair_count NUMBER := 0;
    exp_count NUMBER := 0;
BEGIN
    SELECT AVG(list_price), MIN(list_price), MAX(list_price)
    INTO avg_price, min_price, max_price
    FROM products;
    
    SELECT COUNT(*)
    INTO cheap_count
    FROM products
    WHERE list_price < (avg_price - min_price)/2;
    
    SELECT COUNT(*)
    INTO exp_count
    FROM products
    WHERE list_price > (max_price - avg_price)/2;
    
    SELECT COUNT(*)
    INTO fair_count
    FROM products
    WHERE list_price BETWEEN (avg_price - min_price)/2 AND (max_price - avg_price)/2;
    
    rows_updated := sql%rowcount;
    DBMS_OUTPUT.PUT_LINE('Cheap: ' || cheap_count);
    DBMS_OUTPUT.PUT_LINE('Fair: ' || fair_count);
    DBMS_OUTPUT.PUT_LINE('Expensive: ' || exp_count);
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Unexpected Error!');
END;
/
EXEC product_price_report();