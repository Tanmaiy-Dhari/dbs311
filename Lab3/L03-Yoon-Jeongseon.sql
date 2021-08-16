-- ***********************
-- Name: Jeongseon Yoon
-- ID: 109687202
-- Date: June 11, 2021
-- Purpose: Lab 03 DBS311NDD
-- ***********************

-- Question 1 - Write a SQL query to display the last name and hire date of all employees who were hired before the employee with ID 107 got hired but after March 2016. 
-- Sort the result by the hire date and then employee ID.
-- Q1 SOLUTION --
SELECT 
    last_name, hire_date
FROM employees
WHERE hire_date < (SELECT hire_date FROM employees WHERE employee_id = 107)
    AND hire_date > TO_DATE('20160401', 'YYYYMMDD')
ORDER BY hire_date, employee_id;

-- Question 2 - Write a SQL query to display customer name and credit limit for customers with lowest credit limit. 
-- Sort the result by customer ID.
-- Q2 SOLUTION --
SELECT 
    name, credit_limit
FROM customers
WHERE credit_limit = (SELECT MIN(credit_limit) FROM customers)
ORDER BY customer_id;

-- Question 3 - Write a SQL query to display the product ID, product name, and list price of the highest paid product(s) in each category.
-- Sort by category ID and the product ID.
-- Q3 SOLUTION --
SELECT pro.category_id, pro.product_id, pro.product_name, pro.list_price
FROM products pro
WHERE pro.list_price = (
    SELECT MAX(pro2.list_price)
    FROM products pro2 
    WHERE pro2.category_id = pro.category_id
)
ORDER BY pro.category_id, pro.product_id;

-- Question 4 - Write a SQL query to display the category ID and the category name of the most expensive (highest list price) product(s).
-- Q4 SOLUTION --
SELECT cat.category_id, cat.category_name
FROM products pro
JOIN product_categories cat
    ON pro.category_id = cat.category_id
WHERE pro.list_price = (SELECT MAX(list_price) FROM products);

-- Question 5 - Write a SQL query to display product name and list price for products in category 1 which have the list price less than the lowest list price in ANY category. 
-- Sort the output by top list prices first and then by the product ID.
-- Q5 SOLUTION --
SELECT product_name, list_price
FROM products
WHERE category_id = 1
AND list_price < ANY(SELECT MIN(list_price) FROM products GROUP BY category_id)
ORDER BY list_price DESC, product_id;

-- Question 6 - Display the maximum price (list price) of the category(s) that has the lowest price product.
-- Q6 SOLUTION --
SELECT MAX(list_price)
FROM products
WHERE category_id = (
    SELECT category_id 
    FROM products
    WHERE list_price = (
        SELECT MIN(list_price)
        FROM products
    )
);

