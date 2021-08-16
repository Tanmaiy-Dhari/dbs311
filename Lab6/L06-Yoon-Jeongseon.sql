-- ***********************
-- Student Name: Jeongseon Yoon
-- Student ID: 109687202
-- Date: July 8th, 2021
-- Purpose: Lab 06 - DBS311NDD
-- ***********************

-- Question 1 - Write a store procedure that gets an integer number n and calculates and displays its factorial.
-- Example:
--   0! = 1
--   2! = fact(2) = 2 * 1 = 2
--   3! = fact(3) = 3 * 2 * 1 = 6
--   n! = fact(n) = n * (n-1) * (n-2) * . . . * 1
-- Q1 SOLUTION --
CREATE OR REPLACE PROCEDURE factorial (intNum IN NUMBER) AS
    factorialVal NUMBER := 1;
    num NUMBER := intNum;
    i NUMBER := 0;
BEGIN
    IF num != 0 THEN
        DBMS_OUTPUT.PUT(num || '! = fact' || '(' || num || ') = ');
        WHILE (num > 0) LOOP
            IF i > 0 THEN
                DBMS_OUTPUT.PUT(' * ');
            END IF;
            DBMS_OUTPUT.PUT(num);
            factorialVal := factorialVal * num;
            num := num - 1;
            i := i + 1;
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT(num || '!');
    END IF;
    DBMS_OUTPUT.PUT_LINE(' = ' || factorialVal);
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Unexpected Error!');
END;
/
EXEC factorial(0);
EXEC factorial(2);
EXEC factorial(3);

-- Question 2 - The company wants to calculate the employees’ annual salary:
-- The first year of employment, the amount of salary is the base salary which is $10,000.
-- Every year after that, the salary increases by 5%.
-- Write a stored procedure named calculate_salary which gets an employee ID and for that
-- employee calculates the salary based on the number of years the employee has been working in the company. 
-- (Use a loop construct to calculate the salary).
-- The procedure calculates and prints the salary.
-- Sample output:
-- First Name: first_name
-- Last Name: last_name
-- Salary: $999,999
-- If the employee does not exists, the procedure displays a proper message.
-- Q2 SOLUTION --
CREATE OR REPLACE PROCEDURE calculate_salary (empNum IN NUMBER) AS
    firstName VARCHAR2(255);
    lastName VARCHAR2(255);
    years NUMBER := 0;
    salary NUMBER := 0;
BEGIN
    SELECT first_name, last_name, TRUNC((SYSDATE - hire_date)/365)
    INTO firstName, lastName, years
    FROM employees
    WHERE employee_id = empNum;
    
    salary := 10000;
    IF years >= 1 THEN
        LOOP
            salary := salary + salary * 0.05;
            EXIT WHEN years < 1;
            years := years - 1;
        END LOOP;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('First name: ' || firstName);
    DBMS_OUTPUT.PUT_LINE('Last name: ' || lastName);
    DBMS_OUTPUT.PUT_LINE('Salary: ' || TO_CHAR(salary,'$999,999'));
EXCEPTION
WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too Many Rows Returned!');
WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No Data Found!');
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Unexpected Error!');
END;
/
EXEC calculate_salary(4);

-- Question 3 - Write a stored procedure named warehouses_report to print the warehouse ID, warehouse name, 
-- and the city where the warehouse is located in the following format for all warehouses:
-- Warehouse ID:
-- Warehouse name:
-- City:
-- State:
-- If the value of state does not exist (null), display “no state”.
-- The value of warehouse ID ranges from 1 to 9.
-- You can use a loop to find and display the information of each warehouse inside the loop.
-- (Use a loop construct to answer this question. Do not use cursors.)
-- Q3 SOLUTION --
CREATE OR REPLACE PROCEDURE warehouses_report AS
    warehouseID NUMBER := 0;
    warehouseName warehouses.warehouse_name%type;
    city VARCHAR2(50);
    state VARCHAR2(50);
BEGIN
    FOR id IN 1..9 LOOP
        SELECT war.warehouse_id, war.warehouse_name, loc.city, loc.state
        INTO warehouseID, warehouseName, city, state
        FROM warehouses war
        JOIN locations loc ON war.location_id = loc.location_id
        WHERE war.warehouse_id = id;
        
        DBMS_OUTPUT.PUT_LINE('Warehouse ID: ' ||warehouseID);
        DBMS_OUTPUT.PUT_LINE('Warehouse name: ' ||warehouseName);
        DBMS_OUTPUT.PUT_LINE('City: ' || city);
        IF state IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('State: no state');
        ELSE
            DBMS_OUTPUT.PUT_LINE('State: ' || state);
        END IF;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Unexpected Error!');
END;
/
EXEC warehouses_report;
