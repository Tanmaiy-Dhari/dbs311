-- ***********************
-- Name: Jeongseon Yoon
-- ID: 109687202
-- Date: June 18, 2021
-- Purpose: Lab 04 DBS311NDD
-- ***********************

-- Question 1 - Display cities that no warehouse is located in them. (use set operators to answer this question)
-- Q1 SOLUTION --
SELECT city 
FROM locations
MINUS
SELECT loc.city
FROM warehouses war
JOIN locations loc 
ON war.location_id = loc.location_id;

-- Question 2 - Display the category ID, category name, and the number of products in category 1, 2, and 5. 
-- In your result, display first the number of products in category 5, then category 1 and then 2.
-- Q2 SOLUTION --
SELECT cat.category_id, cat.category_name, COUNT(*) 
FROM product_categories cat
JOIN products pro
ON cat.category_id = pro.category_id
WHERE cat.category_id IN (1, 2, 5)
GROUP BY cat.category_id, cat.category_name
ORDER BY 3 DESC;

-- Question 3 - Display product ID for products whose quantity in the inventory is less than to 5. 
-- (You are not allowed to use JOIN for this question.)
-- Q3 SOLUTION --
SELECT product_id
FROM inventories
WHERE quantity < 5;

-- Question 4 - We need a single report to display all warehouses and the state that they are located in
-- and all states regardless of whether they have warehouses in them or not. (Use set operators in you answer.)
-- Q4 SOLUTION --
SELECT war.warehouse_name, loc.state
FROM warehouses war
JOIN locations loc
ON war.location_id = loc.location_id
UNION
SELECT war.warehouse_name, loc.state
FROM locations loc
LEFT JOIN warehouses war
ON loc.location_id = war.location_id;