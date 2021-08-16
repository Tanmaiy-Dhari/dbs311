-- ***********************
-- Name: Jeongseon Yoon
-- ID: 109687202
-- Date: May 27, 2021
-- Purpose: Lab 01 DBS311NDD
-- ***********************

-- Question 1 - Write a query to display the tomorrow’s date in the following format:
-- January 10th of year 2019
-- the result will depend on the day when you RUN/EXECUTE this query. 
-- Label the column “Tomorrow”.
-- Q1 SOLUTION --
SELECT 
    TO_CHAR(SYSDATE + 1, 'Month') || ' ' || 
    TO_CHAR(SYSDATE + 1, 'ddth') || ' of year ' || 
    TO_CHAR(SYSDATE + 1, 'YYYY') AS "Tomorrow" 
FROM dual;

-- Question 2 - Define an SQL variable called “tomorrow”, assign it a value of tomorrow’s date and use it in an SQL statement.
-- DEFINE tomorrow datetime = SYSDATE + 1; -- This doesn't work in Oracle SQL Developer
-- Q2 SOLUTION --
DEFINE tomorrow = SYSDATE + 1;
SELECT 
    TO_CHAR(&tomorrow, 'Month') || ' ' || 
    TO_CHAR(&tomorrow, 'ddth') || ' of year ' || 
    TO_CHAR(&tomorrow, 'YYYY') AS "Tomorrow" 
FROM dual;
UNDEFINE tomorrow;

-- Question 3 - For each product in category 2, 3, and 5, show product ID, product name, list price, and
-- the new list price increased by 2%. Display a new list price as a whole number.
-- In your result, add a calculated column to show the difference of old and new list prices.
-- Sort the result according to category ID first and then based on product ID.
-- Q3 SOLUTION --
DEFINE newListPrice = ROUND(list_price + list_price * 0.02);
SELECT product_id AS "Product ID", product_name AS "Product Name", list_price,
    &newListPrice AS "New Price",
    &newListPrice - list_price AS "Price Difference"
FROM products
WHERE category_id in (2, 3, 5)
ORDER BY category_id, product_id;
UNDEFINE newListPrice;

-- Question 4 - For employees whose manager ID is 2, write a query that displays the employee’s Full Name and Job Title in the following format:
-- Summer, Payne is Public Accountant.
-- Q4 SOLUTION --
SELECT last_name || ', ' || first_name || ' is ' || job_title || '.' AS "Employee Info"
FROM employees
WHERE manager_id = 2
ORDER BY employee_id;

-- Question 5 - For each employee hired before October 2016, display the employee’s last name, hire date 
-- and calculate the number of YEARS between TODAY and the date the employee was hired.
-- • Label the column Years worked.
-- • Order your results by the number of years employed. Round the number of years employed up to the closest whole number.
-- Q5 SOLUTION --
SELECT
    last_name AS "Last Name",
    hire_date AS "Hire Date",
    ROUND((sysdate - hire_date)/356) AS "Years Worked"
FROM employees
ORDER BY 2, 3;

-- Question 6 - Display each employee’s last name, hire date, and the review date, 
-- which is the first Tuesday after a year of service, but only for those hired after January 1, 2016.
-- • Label the column REVIEW DAY.
-- • Format the dates to appear in the format like:
--   TUESDAY, August the Thirty-First of year 2016
--   You can use ddspth to have the above format for the day.
-- • Sort by review date
-- Q6 SOLUTION --
DEFINE tuesday = NEXT_DAY(ADD_MONTHS(hire_date, 12), 'TUESDAY');
SELECT last_name, hire_date, 
    TO_CHAR(&tuesday, 'DAY') || ', ' || TO_CHAR(&tuesday, 'Month') || ' the ' || TO_CHAR(&tuesday, 'Ddspth') || ' of year ' || TO_CHAR(&tuesday, 'YYYY')  AS "REVIEW DAY"
FROM employees
WHERE hire_date >= TO_DATE('January 1, 2016', 'MONTH DD, YYYY')
ORDER BY 3;
UNDEFINE tuesday;

-- Question 7 - For all warehouses, display warehouse id, warehouse name, city, and state. 
-- For warehouses with the null value for the state column, display “unknown”. 
-- Sort the result based on the warehouse ID.
-- Q6 SOLUTION --
SELECT war.warehouse_id, war.warehouse_name, loc.city, NVL(loc.state, 'unknown')
FROM warehouses war
JOIN locations loc ON war.location_id = loc.location_id
ORDER BY warehouse_id;