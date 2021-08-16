--NAME: Jeongseon Yoon
--Student ID: 109687202
--Date: July 9th, 2021
--Purpose: Midterm Project - DBS311NDD

-- QUESTION 1:
-- Write a query which shows the common last names of any individuals in both tables. 
-- Make sure you ignore case (Smith=SMITH=smith). 
-- Make sure duplicates are removed. Alphabetically order the results.
-- Q1 SOLUTION --
SELECT LOWER(lastname) AS "Last Name"
FROM employee
INTERSECT
SELECT LOWER(name)
FROM staff
ORDER BY 1;

-- QUESTION 2:
-- Write a query which shows the employee IDs that are unique to the employee table. 
-- Order the employee IDs in descending order. 
-- An employee ID Is the same in both tables if the integer value of the ID matches.
-- Q2 SOLUTION --
SELECT TO_NUMBER(empno) AS "Employee ID" 
FROM employee
MINUS
SELECT id 
FROM staff
ORDER BY 1 DESC;

-- QUESTION 3:
-- We want to add a new column to the employee table. 
-- We want to provide a new column with a more complete phone number. 
-- Right now the PHONENO column only shows the last 4 digits.
-- We want a new column which is called PHONE and consists of ###-###-####. 
-- The last 4-digits are already in the PHONENO column.
-- The first three digits should be 416 and the next three should be 123.
-- To improve clarity in the table, we also want to rename the PHONENO column to PHONEEXT.
-- Show all the commands used to accomplish this, then, select all data for employees who have the last name of 'smith' (case insensitive).
-- Q3 SOLUTION --
ALTER TABLE employee
ADD phone VARCHAR2(20);

UPDATE employee
SET phone = '416-123-' || phoneno;

ALTER TABLE employee
RENAME COLUMN phoneno TO phoneext;

SELECT * FROM employee
WHERE LOWER(lastname) = 'smith';

-- QUESTION 4:
-- Show a list of employee id, names, department, years and job of any employee in the staff table who makes a total amount more than their manager or has more years of service than their manager.
-- Make sure to include both salary and commission when calculating the total amount someone makes.
-- Exclude staff in department 10 from the query.
-- Order the results by department then name
-- Q4 SOLUTION --
SELECT id, name, dept, job, years
FROM staff sta
WHERE sta.dept <> 10
AND (
    sta.salary + sta.comm > 
       (SELECT salary + comm
        FROM staff 
        WHERE dept = sta.dept 
        AND job = 'Mgr')
    OR sta.years > 
        (SELECT years
        FROM staff 
        WHERE dept = sta.dept 
        AND job = 'Mgr')
)
ORDER BY sta.dept, sta.name;

-- QUESTION 5:
-- Show a list of all employees, their department and their jobs, from the staff table, that are in the same department as 'Graham'
-- Order by name alphabetically. Exclude 'Graham' from the result set.
-- Q5 SOLUTION --
SELECT name, dept, job
FROM staff
WHERE dept = (
    SELECT dept 
    FROM staff 
    WHERE name = 'Graham'
)
AND name <> 'Graham'
ORDER BY name;

-- QUESTION 6:
-- Show the list of employee names, job and variable pay, from the employee table, who have the lowest and highest variable pay (includes commission and bonus) by job category.
-- The name should be formatted: lastname, firstname with the first character capitalized and all other characters in lower case. (ie: King, Les). 
-- The title of this column should be “Name”.
-- The variable pay column should be called “Variable Pay”.
-- Order the results by highest variable pay to lowest variable pay.
-- Q6 SOLUTION --
SELECT INITCAP(emp.lastname) || ', ' || INITCAP(emp.firstname) AS "Name",
    emp.job AS "Job",
    (emp.bonus + emp.comm) AS "Variable Pay"
FROM employee emp,
(
    SELECT
        job,
        MAX(bonus + comm) AS maxPay,
        MIN(bonus + comm) AS minPay
    FROM employee
    GROUP BY job
) jobGrp
WHERE emp.job = jobGrp.job
AND (emp.bonus + emp.comm) IN (jobGrp.maxPay, jobGrp.minPay)
ORDER BY 2, 3 DESC
;

-- QUESTION 7:
-- Using the staff table, show all employees who have an 'il' in their name - or - their name ends with an 's'. 
-- Make sure your query is case insensitive.
-- You just need to display the name of the employee in your output. 
-- Order them alphabetically.
-- Q7 SOLUTION --
SELECT name
FROM staff
WHERE LOWER(name) LIKE '%il%'
OR LOWER(name) LIKE '%s'
ORDER BY 1;

-- QUESTION 8:
-- Using the staff table, display the employee name, job, salary and commission for all employees 
-- with a salary less than the salary of all people with a manager job 
-- or full compensation less than the full compensation of all the people with a sales job.
-- Full compensation is the sum of both salary and commission.
-- Exclude people with a sales job from the output.
-- Q8 SOLUTION --
SELECT name, job, salary, comm
FROM staff
WHERE
job <> 'Sales'
AND (
    salary <
        ALL(SELECT salary FROM staff WHERE job = 'Mgr')
    OR (salary + comm) <
        ALL(SELECT (salary + comm) FROM staff WHERE job = 'Sales')
);

-- QUESTION 9:
-- From the employee table, calculate the average compensation for each job category where the employee has 16 or more years of education.
-- Display the job and average compensation in the result set.
-- Exclude people who are clerks
-- Make sure to include salary, commission and bonus when looking at employee compensation
-- Order the output by the average salary in ascending order
-- Q9 SOLUTION --
SELECT 
    job, 
    AVG(salary + comm + bonus) AS "average compensation"
FROM employee
WHERE edlevel >= 16
AND LOWER(job) <> 'clerk'
GROUP BY job
ORDER BY 2;

-- QUESTION 10:
-- Show the first name, last name, hire date, birth date, education level and years of service
-- for employees who are both in the staff table and the employee table
-- An individual is the same individual if a case insensitive comparison of last name matches.
-- Q10 SOLUTION --
SELECT emp.firstname, emp.lastname, emp.hiredate, emp.birthdate, emp.edlevel,
    TRUNC((SYSDATE - emp.hiredate)/365) AS "years of service"
FROM employee emp
JOIN staff sta ON LOWER(emp.lastname) = LOWER(sta.name);

