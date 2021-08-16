-- ***********************
-- Name: Jeongseon Yoon
-- ID: 109687202
-- Date: June 04, 2021
-- Purpose: Lab 02 DBS311NDD
-- ***********************

-- Question 1 - For each job title display the number of employees. Sort the result according to the number of employees.
-- Q1 SOLUTION --
SELECT 
    job_title, COUNT(*) AS employees
FROM employees
GROUP BY job_title
ORDER BY employees;

-- Question 2 - Display the highest, lowest, and average customer credit limits. Name these results high,low, and average. 
-- Add a column that shows the difference between the highest and the lowest credit limits named “High and Low Difference”. 
-- Round the average to 2 decimal 
-- Q2 SOLUTION --
SELECT 
    MAX(credit_limit) AS high,
    MIN(credit_limit) AS low,
    ROUND(AVG(credit_limit), 2) AS average,
    MAX(credit_limit) - MIN(credit_limit) AS "High Low Difference"
FROM customers;

-- Question 3 - Display the order id, the total number of products, 
-- and the total order amount for orders with the total amount over $1,000,000. 
-- Sort the result based on total amount from the high to low values.
-- Q3 SOLUTION --
SELECT odr.order_id,
    SUM(itm.quantity) AS total_items,
    SUM(itm.quantity * itm.unit_price) AS total_amount
FROM orders odr
JOIN order_items itm ON odr.order_id = itm.order_id
GROUP BY odr.order_id
HAVING SUM(itm.quantity * itm.unit_price) > 1000000
ORDER BY total_amount DESC;

-- Question 4 - Display the warehouse id, warehouse name, and the total number of products for each warehouse. 
-- Sort the result according to the warehouse ID.
-- Q4 SOLUTION --
SELECT war.warehouse_id, war.warehouse_name, SUM(inv.quantity) AS total_products
FROM warehouses war
JOIN inventories inv ON war.warehouse_id = inv.warehouse_id
GROUP BY war.warehouse_id, war.warehouse_name
ORDER BY warehouse_id;

-- Question 5 - For each customer display customer number, customer full name, and the total number of orders issued by the customer.
-- Q5 SOLUTION --
SELECT
    cus.customer_id, cus.name AS "customer name", COUNT(odr.order_id) AS "total number OF orders"
FROM customers cus
LEFT JOIN orders odr ON cus.customer_id = odr.customer_id
GROUP BY cus.customer_id, cus.name
HAVING cus.name LIKE 'O%e%' OR cus.name LIKE '%t'
ORDER BY 3 DESC;

-- Question 6 - Write a SQL query to show the total and the average sale amount for each category. 
-- Round the average to 2 decimal places.
-- Q6 SOLUTION --
SELECT pdt.category_id,
    SUM(itm.unit_price * itm.quantity) AS total_amount,
    ROUND(AVG(itm.unit_price * itm.quantity), 2) AS average_amount
FROM orders odr
JOIN order_items itm ON odr.order_id = itm.order_id
JOIN products pdt ON itm.product_id = pdt.product_id
GROUP BY pdt.category_id;
