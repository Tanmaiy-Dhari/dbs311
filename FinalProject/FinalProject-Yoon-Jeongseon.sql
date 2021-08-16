--NAME: Jeongseon Yoon
--Student ID: 109687202
--Date: August 13th, 2021
--Purpose: Final Project - DBS311NDD

-- Section A

-- QUESTION 1:
-- Write a query which lists the employee (from EMPLOYEE table) with the highest total
-- compensation (includes SALARY, BONUS and COMMISSION) by department and job type.
-- The result set should have department, job type, employee number, total compensation.
-- The result set should be ordered by department, then, job
-- WHAT TO HAND IN: Provide your query. Provide the result set.
-- Q1 SOLUTION --
SELECT
    emp.workdept AS "department", 
    emp.job AS "job type", 
    emp.empno AS "employee number", 
    (emp.salary + emp.comm + emp.bonus) AS "total compensation"
FROM employee emp
JOIN (
    SELECT 
        workdept,
        job, 
        MAX(salary + comm + bonus) AS highestTotal
    FROM employee
    GROUP BY workdept, job
) high ON (emp.salary + emp.comm + emp.bonus) = high.highestTotal
ORDER BY 1, 2
;

-- Q1 OUTPUT --
dep job type employ total compensation
--- -------- ------ ------------------
A00 CLERK    000120              52190
A00 PRES     000010             157970
A00 SALESREP 000110              71120
B01 MANAGER  000020              98350
C01 ANALYST  000130              76204
C01 MANAGER  000030             102110
D11 DESIGNER 200220              72827
D11 MANAGER  000060              75330
D21 CLERK    000240              51661
D21 MANAGER  000070              99763
E01 MANAGER  000050              84189

dep job type employ total compensation
--- -------- ------ ------------------
E11 MANAGER  000090              92730
E11 OPERATOR 200280              48850
E21 FIELDREP 000330              47900
E21 MANAGER  000100              88742

15 rows selected. 


-- QUESTION 2:
-- Write a query which shows the complete list of last names from both the EMPLOYEE table
-- and STAFF table. Make sure your query is case insensitive (ie SMITH = Smith = smith).
-- Make sure names are not duplicated. We only want to see each name once in the result set.
-- Display the names with the initial character as a capital (ie: Smith, Jones, etc).
-- Output should be in ascending order (alphabetical order)
-- WHAT TO HAND IN: Provide your query. Provide the result set.
-- Q2 SOLUTION --
SELECT INITCAP(lastname) AS "last name"
FROM employee
UNION
SELECT INITCAP(name) AS "last name"
FROM staff
ORDER BY 1
;

-- Q2 OUTPUT --
last name      
---------------
Abrahams
Adamson
Alonzo
Brown
Burke
Daniels
Davis
Edwards
Fraye
Gafney
Geyer

last name      
---------------
Gonzales
Gounot
Graham
Haas
Hanes
Hemminger
Henderson
James
Jefferson
John
Johnson

last name      
---------------
Jones
Kermisch
Koonitz
Kwan
Lea
Lee
Lu
Lucchessi
Lundquist
Lutz
Marenghi

last name      
---------------
Marino
Mehta
Molinare
Monteverde
Natz
Naughton
Ngan
Nicholls
O'Brien
O'Connell
Orlando

last name      
---------------
Parker
Perez
Pernal
Pianka
Plotz
Pulaski
Quigley
Quill
Quintana
Rothman
Sanders

last name      
---------------
Schneider
Schwartz
Scoutten
Setright
Smith
Sneider
Spenser
Springer
Stern
Thompson
Walker

last name      
---------------
Wheeler
Williams
Wilson
Wong
Yamaguchi
Yamamoto
Yoshimura

73 rows selected. 


-- QUESTION 3:
-- Write a query which shows where we have two employees assigned to the same employee number, 
-- when looking across both EMPLOYEE table and STAFF table.
-- The output should be ordered first by employee number, then by last name
-- WHAT TO HAND IN: Provide your query. Provide the result set.
-- Q3 SOLUTION --
SELECT empno, lastname
FROM employee emp
WHERE EXISTS (SELECT 1 FROM staff WHERE id = TO_NUMBER(emp.empno))
ORDER BY 1, 2
;

-- Q3 OUTPUT --
EMPNO  LASTNAME       
------ ---------------
000010 HAAS           
000020 THOMPSON       
000030 KWAN           
000050 GEYER          
000060 STERN          
000070 PULASKI        
000090 HENDERSON      
000100 SPENSER        
000110 LUCCHESSI      
000120 O'CONNELL      
000130 QUINTANA       

EMPNO  LASTNAME       
------ ---------------
000140 NICHOLLS       
000150 ADAMSON        
000160 PIANKA         
000170 YOSHIMURA      
000180 SCOUTTEN       
000190 WALKER         
000200 BROWN          
000210 JONES          
000220 LUTZ           
000230 JEFFERSON      
000240 MARINO         

EMPNO  LASTNAME       
------ ---------------
000250 SMITH          
000260 JOHNSON        
000270 PEREZ          
000280 SCHNEIDER      
000290 PARKER         
000300 SMITH          
000310 SETRIGHT       
000320 MEHTA          
000330 LEE            
000340 GOUNOT         

32 rows selected. 


-- QUESTION 4:
-- Write a query which lists all employees across both the STAFF and EMPLOYEE table, which have an 'oo' OR a 'z' in their last name.
-- This query should be case insensitive, meaning both a 'Z' and a 'z' count for the condition, as an example.
-- The output should be ordered by lastname.
-- WHAT TO HAND IN: Provide your query. Provide the result set.
-- Q4 SOLUTION --
SELECT lastname
FROM employee
WHERE LOWER(lastname) LIKE '%oo%' OR LOWER(lastname) LIKE '%z%'
UNION ALL
SELECT name
FROM staff
WHERE LOWER(name) LIKE '%oo%' OR LOWER(name) LIKE '%z%'
ORDER BY 1
;

-- Q4 OUTPUT --
LASTNAME       
---------------
ALONZO
Gonzales
Koonitz
LUTZ
NATZ
PEREZ
Plotz
SCHWARTZ

8 rows selected. 


-- QUESTION 5:
-- Write a query which looks at the EMPLOYEE table and, for each department, compares the
-- manager's total compensation (SALARY, BONUS and COMMISSION) to the top paid
-- employee's total compensation and displays output if the top paid employee in that
-- department makes within $10,000 in total compensation as compared to their manager.
-- The output should include department, manager's total compensation and top paid employee's total compensation
-- If a department has no non-managers - OR - has no manager, assume total compensation is 0
-- WHAT TO HAND IN: Provide your query. Provide the result set.
-- Q5 SOLUTION --
SELECT emp_top.workdept,
    NVL(mgr.totalCompensation, 0) AS "manager�s total compensation",
    emp_top.totalCompensation AS "employee�s total compensation"
FROM (
    SELECT workdept, MAX(salary + bonus + comm) AS totalCompensation
    FROM employee emp
    WHERE job <> 'MANAGER'
    GROUP BY workdept
) emp_top
LEFT JOIN (
    SELECT workdept, (salary + bonus + comm) AS totalCompensation
    FROM employee
    WHERE job = 'MANAGER'
) mgr ON emp_top.workdept = mgr.workdept
WHERE emp_top.totalCompensation <= 10000 
;

-- Q5 OUTPUT --
no rows selected

-- QUESTION 6:
-- Write a query which looks across both the EMPLOYEE and STAFF table and 
-- returns the total "variable pay" (COMMISSION + BONUS) for each employee.
-- If an employee does not make either, the output should be 0
-- The output should include the employee's last name and total variable pay
-- The output should be ordered by a case insensitive view of their last name in alphabetical order
-- WHAT TO HAND IN: Provide your query. Provide the result set.
-- Q6 SOLUTION --
SELECT LOWER(lastname) AS "employee's last name", NVL(comm + bonus, 0) AS "total variable pay"
FROM employee
UNION ALL
SELECT LOWER(name) AS "employee's last name", NVL(comm, 0) AS "total variable pay"
FROM staff
ORDER BY 1
;

-- Q6 OUTPUT --
employee's last total variable pay
--------------- ------------------
abrahams                     236.5
adamson                       2522
alonzo                        2407
brown                         2817
burke                         55.5
daniels                          0
davis                        806.1
edwards                       1285
fraye                            0
gafney                         188
geyer                         4014

employee's last total variable pay
--------------- ------------------
gonzales                       844
gounot                        2407
graham                       200.3
haas                          5220
hanes                            0
hemminger                     5220
henderson                     2980
james                        128.2
jefferson                     2174
john                          2987
johnson                       1680

employee's last total variable pay
--------------- ------------------
jones                         1862
jones                            0
kermisch                     110.1
koonitz                     1386.7
kwan                          3860
lea                              0
lee                           2530
lu                               0
lucchessi                     4620
lundquist                   189.65
lutz                          2987

employee's last total variable pay
--------------- ------------------
marenghi                         0
marino                        2901
mehta                         1996
molinare                         0
monteverde                    2901
natz                          2874
naughton                       180
ngan                         206.6
nicholls                      2874
o'brien                     846.55
o'connell                     2940

employee's last total variable pay
--------------- ------------------
orlando                       2940
parker                        1527
perez                         2690
pernal                      612.45
pianka                        2180
plotz                            0
pulaski                       3593
quigley                     650.25
quill                            0
quintana                      2404
rothman                       1152

employee's last total variable pay
--------------- ------------------
sanders                          0
schneider                     2600
schwartz                      2600
scoutten                      2207
scoutten                      84.2
setright                      1572
smith                        992.8
smith                         1934
smith                         1820
sneider                      126.5
spenser                       2592

employee's last total variable pay
--------------- ------------------
springer                      1572
stern                         3080
thompson                      4100
walker                        2036
wheeler                      513.3
williams                    637.65
wilson                       811.5
wong                          2530
yamaguchi                     75.6
yamamoto                      2474
yoshimura                     2474

77 rows selected. 


-- QUESTION 7:
-- Write a stored procedure for the EMPLOYEE table which takes, as input, an employee number
-- and a rating of either 1, 2 or 3.
-- The stored procedure should perform the following changes:
-- If the employee was rated a 1 - they receive a $10,000 salary increase, additional $300 in
-- bonus and an additional 5% of salary as commission
-- If the employee was rated a 2 - they receive a $5,000 salary increase, additional $200 in
-- bonus and an additional 2% of salary as commission
-- If the employee was rated a 3 - they receive a $2,000 salary increase with no change to their variable pay
-- Make sure you handle two types of errors: (1) A non-existent employee - and - (2) A nonvalid
-- rating. Both should have an appropriate message.
-- The stored procedure should return the employee number, previous compensation and new
-- compensation (all three compensation components showed separately)
-- EMP OLD SALARY OLD BONUS OLD COMM NEW SALARY NEW BONUS NEW COMM
-- Demonstrate that your stored procedure works correctly by running it 5 times: Three times
-- with a valid employee number and a 1 rating, 2 rating and 3 rating. Once with an invalid
-- employee number. Once with an invalid rating level.
-- WHAT TO HAND IN: A copy of your stored procedure and the output of the 5 calls described above.
-- Q7 SOLUTION --
CREATE OR REPLACE PROCEDURE calculate_compensation(
    empNum IN OUT employee.empno%TYPE,
    rating IN NUMBER,
    oldSalary OUT employee.salary%TYPE,
    oldBonus OUT employee.bonus%TYPE,
    oldComm OUT employee.comm%TYPE,
    newSalary OUT employee.salary%TYPE,
    newBonus OUT employee.bonus%TYPE,
    newComm OUT employee.comm%TYPE) AS
BEGIN
    SELECT salary, NVL(bonus, 0), NVL(comm, 0)
    INTO oldSalary, oldBonus, oldComm
    FROM employee
    WHERE empno = empNum;--
    
    IF rating = 1 THEN
        newSalary := oldSalary + 10000;
        newBonus := oldBonus + 300;
        newComm := oldSalary * 0.05;
        DBMS_OUTPUT.PUT_LINE(empNum || ' ' || oldSalary || ' ' || oldBonus || ' ' || oldComm || ' ' || newSalary || ' ' || newBonus || ' ' || newComm);
    ELSIF rating = 2 THEN
        newSalary := oldSalary + 5000;
        newBonus := oldBonus + 200;
        newComm := oldSalary * 0.02;
        DBMS_OUTPUT.PUT_LINE(empNum || ' ' || oldSalary || ' ' || oldBonus || ' ' || oldComm || ' ' || newSalary || ' ' || newBonus || ' ' || newComm);
    ELSIF rating = 3 THEN
        newSalary := oldSalary + 2000;
        newBonus := 0;
        newComm := 0;
        DBMS_OUTPUT.PUT_LINE(empNum || ' ' || oldSalary || ' ' || oldBonus || ' ' || oldComm || ' ' || newSalary || ' ' || newBonus || ' ' || newComm);
     ELSE
        DBMS_OUTPUT.PUT_LINE('Invalid rating (rating = ' || rating || ')!');
    END IF;
        
   
EXCEPTION
WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No Data Found!');
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Unexpected Error!');
END;
/

-- Demonstration 1: a valid employee number and 1 rating
DECLARE
    empNum CHAR(6) := '000150';
    rating NUMBER := 1;
    oldSalary NUMBER(9,2) := 0;
    oldBonus NUMBER(9,2) := 0;
    oldComm NUMBER(9,2) := 0;
    newSalary NUMBER(9,2) := 0;
    newBonus NUMBER(9,2) := 0;
    newComm NUMBER(9,2) := 0;
BEGIN
    calculate_compensation(empNum, rating, oldSalary, oldBonus, oldComm, newSalary, newBonus, newComm);
END;
/
-- Demonstration 2: a valid employee number and 2 rating
DECLARE
    empNum CHAR(6) := '000150';
    rating NUMBER := 2;
    oldSalary NUMBER(9,2) := 0;
    oldBonus NUMBER(9,2) := 0;
    oldComm NUMBER(9,2) := 0;
    newSalary NUMBER(9,2) := 0;
    newBonus NUMBER(9,2) := 0;
    newComm NUMBER(9,2) := 0;
BEGIN
    calculate_compensation(empNum, rating, oldSalary, oldBonus, oldComm, newSalary, newBonus, newComm);
END;
/
-- Demonstration 3: a valid employee number and 3 rating
DECLARE
    empNum CHAR(6) := '000150';
    rating NUMBER := 3;
    oldSalary NUMBER(9,2) := 0;
    oldBonus NUMBER(9,2) := 0;
    oldComm NUMBER(9,2) := 0;
    newSalary NUMBER(9,2) := 0;
    newBonus NUMBER(9,2) := 0;
    newComm NUMBER(9,2) := 0;
BEGIN
    calculate_compensation(empNum, rating, oldSalary, oldBonus, oldComm, newSalary, newBonus, newComm);
END;
/
-- Demonstration 4: a valid employee number and invalid rating
DECLARE
    empNum CHAR(6) := '000150';
    rating NUMBER := 4;
    oldSalary NUMBER(9,2) := 0;
    oldBonus NUMBER(9,2) := 0;
    oldComm NUMBER(9,2) := 0;
    newSalary NUMBER(9,2) := 0;
    newBonus NUMBER(9,2) := 0;
    newComm NUMBER(9,2) := 0;
BEGIN
    calculate_compensation(empNum, rating, oldSalary, oldBonus, oldComm, newSalary, newBonus, newComm);
END;
/
-- Demonstration 5: a invalid employee number
DECLARE
    empNum CHAR(6) := '999999';
    rating NUMBER := 1;
    oldSalary NUMBER(9,2) := 0;
    oldBonus NUMBER(9,2) := 0;
    oldComm NUMBER(9,2) := 0;
    newSalary NUMBER(9,2) := 0;
    newBonus NUMBER(9,2) := 0;
    newComm NUMBER(9,2) := 0;
BEGIN
    calculate_compensation(empNum, rating, oldSalary, oldBonus, oldComm, newSalary, newBonus, newComm);
END;
/

-- Q7 OUTPUT --
Procedure CALCULATE_COMPENSATION compiled

PL/SQL procedure successfully completed.
PL/SQL procedure successfully completed.
PL/SQL procedure successfully completed.
PL/SQL procedure successfully completed.
PL/SQL procedure successfully completed.

000150 55280 500 2022 65280 800 2764

000150 55280 500 2022 60280 700 1105.6

000150 55280 500 2022 57280 0 0

Invalid rating (rating = 4)!

No Data Found!


-- QUESTION 8:
-- Write a stored procedure for the EMPLOYEE table which takes employee number and
-- education level upgrade as input - and - increases the education level of the employee based
-- on the input. Valid input is:
-- "H" (for high school diploma) - and - this will update the edlevel to 16
-- "C" (for college diploma) - and - this will update the edlevel to 19
-- "U" (for university degree) - and - this will update the edlevel to 20
-- "M" (for masters) - and - this will update the edlevel to 23
-- "P" (for PhD) - and - this will update the edlevel to 25
-- Make sure you handle the error condition of incorrect education level input - and - nonexistent employee number
-- Also make sure you never reduce the existing education level of the employee. 
-- They can only stay the same or go up.
-- A message should be provided for all three error cases.
-- When no errors occur, the output should look like:
-- EMP OLD EDUCATION NEW EDUCATION
-- WHAT TO HAND IN: A copy of your stored procedure and the output of the a set of calls which test all
-- input conditions and error handling. Total of 8 calls and 8 output.
-- Q8 SOLUTION --
CREATE OR REPLACE PROCEDURE update_edlevel(
    empNum IN OUT employee.empno%TYPE,
    edLevelUp IN CHAR,
    oldEdLevel OUT employee.edlevel%TYPE,
    newEdLevel OUT employee.edlevel%TYPE) AS
BEGIN
    SELECT edLevel
    INTO oldEdLevel
    FROM employee
    WHERE empno = empNum;--
    
    IF edLevelUp = 'H' THEN
        newEdLevel := 16;
    ELSIF edLevelUp = 'C' THEN
        newEdLevel := 19;
    ELSIF edLevelUp = 'U' THEN
        newEdLevel := 20;
    ELSIF edLevelUp = 'M' THEN
        newEdLevel := 23;
    ELSIF edLevelUp = 'P' THEN
        newEdLevel := 25;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Incorrect education level input (education level input = ' || edLevelUp || ')!');
    END IF;
    
    IF newEdLevel > 0 THEN
        IF newEdLevel > oldEdLevel THEN
            UPDATE employee
            SET edlevel = newEdLevel
            WHERE empno = empNum;--
            
            DBMS_OUTPUT.PUT_LINE(empNum || ' ' || oldEdLevel || ' ' || newEdLevel);
        ELSE
            DBMS_OUTPUT.PUT_LINE('The education level was not updated!');
        END IF;
    END IF;
    
EXCEPTION
WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No Data Found!');
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Unexpected Error!');
END;
/

-- Demonstration 1: a valid employee number and education level input 'H'
DECLARE
    empNum CHAR(6) := '000290';
    levelUp CHAR := 'H';
    oldEdLevel NUMBER := 0;
    newEdLevel NUMBER := 0;
BEGIN
    update_edlevel(empNum, levelUp, oldEdLevel, newEdLevel);
END;
/
-- Demonstration 2: a valid employee number and education level input 'C'
DECLARE
    empNum CHAR(6) := '000290';
    levelUp CHAR := 'C';
    oldEdLevel NUMBER := 0;
    newEdLevel NUMBER := 0;
BEGIN
    update_edlevel(empNum, levelUp, oldEdLevel, newEdLevel);
END;
/
-- Demonstration 3: a valid employee number and education level input 'U'
DECLARE
    empNum CHAR(6) := '000290';
    levelUp CHAR := 'U';
    oldEdLevel NUMBER := 0;
    newEdLevel NUMBER := 0;
BEGIN
    update_edlevel(empNum, levelUp, oldEdLevel, newEdLevel);
END;
/
-- Demonstration 4: a valid employee number and education level input 'M'
DECLARE
    empNum CHAR(6) := '000290';
    levelUp CHAR := 'M';
    oldEdLevel NUMBER := 0;
    newEdLevel NUMBER := 0;
BEGIN
    update_edlevel(empNum, levelUp, oldEdLevel, newEdLevel);
END;
/
-- Demonstration 5: a valid employee number and education level input 'P'
DECLARE
    empNum CHAR(6) := '000290';
    levelUp CHAR := 'P';
    oldEdLevel NUMBER := 0;
    newEdLevel NUMBER := 0;
BEGIN
    update_edlevel(empNum, levelUp, oldEdLevel, newEdLevel);
END;
/
-- Demonstration 6: a valid employee number and invalid education level input 
DECLARE
    empNum CHAR(6) := '000290';
    levelUp CHAR := 'Z';
    oldEdLevel NUMBER := 0;
    newEdLevel NUMBER := 0;
BEGIN
    update_edlevel(empNum, levelUp, oldEdLevel, newEdLevel);
END;
/
-- Demonstration 7: a valid employee number and no update education level
DECLARE
    empNum CHAR(6) := '000290';
    levelUp CHAR := 'H';
    oldEdLevel NUMBER := 0;
    newEdLevel NUMBER := 0;
BEGIN
    update_edlevel(empNum, levelUp, oldEdLevel, newEdLevel);
END;
/
-- Demonstration 8: a invalid employee number
DECLARE
    empNum CHAR(6) := '999999';
    levelUp CHAR := 'P';
    oldEdLevel NUMBER := 0;
    newEdLevel NUMBER := 0;
BEGIN
    update_edlevel(empNum, levelUp, oldEdLevel, newEdLevel);
END;
/

-- Q8 OUTPUT --
Procedure UPDATE_EDLEVEL compiled

PL/SQL procedure successfully completed.
PL/SQL procedure successfully completed.
PL/SQL procedure successfully completed.
PL/SQL procedure successfully completed.
PL/SQL procedure successfully completed.
PL/SQL procedure successfully completed.
PL/SQL procedure successfully completed.
PL/SQL procedure successfully completed.

000290 12 16

000290 16 19

000290 19 20

000290 20 23

000290 23 25

Incorrect education level input (education level input = Z)!

The education level was not updated!

No Data Found!


-- QUESTION 9:
-- Write a function called PHONE which takes an employee number as input and displays a full
-- phone number for that employee, using the PHONENO value as part of the function.
-- PHONE(100) should run for employee 100
-- This function should convert the existing PHONENO value into a full phone number which
-- looks like "(416) 123-xxxx" where xxxx is the existing PHONENO value.
-- This function will return the full phone number.
-- WHAT TO HAND IN: A copy of the code for your function - no execution required yet
-- Q9 SOLUTION --
CREATE OR REPLACE FUNCTION PHONE(empNum IN employee.empno%TYPE)
    RETURN CHAR
AS
    v_phoneNo employee.empno%TYPE;
BEGIN
    SELECT phoneno
    INTO v_phoneNo
    FROM employee
    WHERE empno = empNum;--
    
RETURN '(416) 123-' || v_phoneNo;

EXCEPTION
WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No Data Found!');
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Unexpected Error!');
END;
/

-- Q9 OUTPUT --
Function PHONE compiled

PL/SQL procedure successfully completed.


-- QUESTION 10:
-- Execute an UPDATE command which adds a new column to your EMPLOYEE table called PHONENUM as CHAR(14)
-- Write a stored procedure which calls your PHONE function.
-- This stored procedure should go through a loop for all records where the department number
-- begins with a E and updates the value of PHONENUM with the output of the PHONE function
-- For each row, as it is updated the following should be printed
-- DEPT EMP PHONENO PHONENUM
-- WHAT TO HAND IN: A copy of the code for your stored procedure - and - the output, as described
-- above, from executing your stored procedure - and - the output of a SELECT WORKDEPT, PHONENO,
-- PHONENUM FROM EMPLOYEE
-- Q10 SOLUTION --
ALTER TABLE employee
ADD phonenum CHAR(16);

CREATE OR REPLACE PROCEDURE updatePhone AS
    v_empno employee.empno%TYPE;
    v_dept employee.workdept%TYPE;
    v_phoneno employee.phoneno%TYPE;
    v_phonenum employee.phonenum%TYPE;
    
    CURSOR emp_cursor IS
    SELECT empno, workdept, phoneno
    FROM employee
    WHERE workdept LIKE 'E%';
BEGIN
    FOR emp IN emp_cursor
    LOOP
        v_phonenum := PHONE(emp.empno);
        UPDATE employee
        SET phonenum = v_phonenum
        WHERE empno = emp.empno;

        DBMS_OUTPUT.PUT_LINE(emp.workdept || ' ' || emp.empno || ' ' || emp.phoneno || ' ' || v_phonenum);

    END LOOP;
    IF emp_cursor%ISOPEN THEN
        CLOSE emp_cursor;
    END IF;
 
EXCEPTION
WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No Data Found!');
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Unexpected Error!');
END;
/

EXEC updatePhone;

SELECT *
FROM employee
;

-- Q10 OUTPUT --
Procedure UPDATEPHONE compiled

PL/SQL procedure successfully completed.

E01 000050 6789 (416) 123-6789  
E11 000090 5498 (416) 123-5498  
E21 000100 0972 (416) 123-0972  
E11 000280 8997 (416) 123-8997  
E11 000290 4502 (416) 123-4502  
E11 000300 2095 (416) 123-2095  
E11 000310 3332 (416) 123-3332  
E21 000320 9990 (416) 123-9990  
E21 000330 2103 (416) 123-2103  
E21 000340 5698 (416) 123-5698  
E11 200280 8997 (416) 123-8997  
E11 200310 3332 (416) 123-3332  
E21 200330 2103 (416) 123-2103  
E21 200340 5698 (416) 123-5698 

EMPNO  FIRSTNAME    M LASTNAME        WOR PHON HIREDATE  JOB         EDLEVEL S BIRTHDATE     SALARY      BONUS       COMM PHONENUM       
------ ------------ - --------------- --- ---- --------- -------- ---------- - --------- ---------- ---------- ---------- ---------------
000010 CHRISTINE    I HAAS            A00 3978 01-JAN-95 PRES             18 F 24-AUG-63     152750       1000       4220                
000020 MICHAEL      L THOMPSON        B01 3476 10-OCT-03 MANAGER          18 M 02-FEB-78      94250        800       3300                
000030 SALLY        A KWAN            C01 4738 05-APR-05 MANAGER          20 F 11-MAY-71      98250        800       3060                
000050 JOHN         B GEYER           E01 6789 17-AUG-79 MANAGER          16 M 15-SEP-55      80175        800       3214 (416)123-6789  
000060 IRVING       F STERN           D11 6423 14-SEP-03 MANAGER          16 M 07-JUL-75      72250        500       2580                
000070 EVA          D PULASKI         D21 7831 30-SEP-05 MANAGER          16 F 26-MAY-03      96170        700       2893                
000090 EILEEN       W HENDERSON       E11 5498 15-AUG-00 MANAGER          16 F 15-MAY-71      89750        600       2380 (416)123-5498  
000100 THEODORE     Q SPENSER         E21 0972 19-JUN-00 MANAGER          14 M 18-DEC-80      86150        500       2092 (416)123-0972  
000110 VINCENZO     G LUCCHESSI       A00 3490 16-MAY-88 SALESREP         19 M 05-NOV-59      66500        900       3720                
000120 SEAN           O'CONNELL       A00 2167 05-DEC-93 CLERK            14 M 18-OCT-72      49250        600       2340                
000130 DELORES      M QUINTANA        C01 4578 28-JUL-01 ANALYST          16 F 15-SEP-55      73800        500       1904                

EMPNO  FIRSTNAME    M LASTNAME        WOR PHON HIREDATE  JOB         EDLEVEL S BIRTHDATE     SALARY      BONUS       COMM PHONENUM       
------ ------------ - --------------- --- ---- --------- -------- ---------- - --------- ---------- ---------- ---------- ---------------
000140 HEATHER      A NICHOLLS        C01 1793 15-DEC-06 ANALYST          18 F 19-JAN-76      68420        600       2274                
000150 BRUCE          ADAMSON         D11 4510 12-FEB-02 DESIGNER         16 M 17-MAY-77      55280        500       2022                
000160 ELIZABETH    R PIANKA          D11 3782 11-OCT-06 DESIGNER         17 F 12-APR-80      62250        400       1780                
000170 MASATOSHI    J YOSHIMURA       D11 2890 15-SEP-99 DESIGNER         16 M 05-JAN-81      44680        500       1974                
000180 MARILYN      S SCOUTTEN        D11 1682 07-JUL-03 DESIGNER         17 F 21-FEB-79      51340        500       1707                
000190 JAMES        H WALKER          D11 2986 26-JUL-04 DESIGNER         16 M 25-JUN-82      50450        400       1636                
000200 DAVID          BROWN           D11 4501 03-MAR-02 DESIGNER         16 M 29-MAY-71      57740        600       2217                
000210 WILLIAM      T JONES           D11 0942 11-APR-98 DESIGNER         17 M 23-FEB-03      68270        400       1462                
000220 JENNIFER     K LUTZ            D11 0672 29-AUG-98 DESIGNER         18 F 19-MAR-78      49840        600       2387                
000230 JAMES        J JEFFERSON       D21 2094 21-NOV-96 CLERK            14 M 30-MAY-80      42180        400       1774                
000240 SALVATORE    M MARINO          D21 3780 05-DEC-04 CLERK            17 M 31-MAR-02      48760        600       2301                

EMPNO  FIRSTNAME    M LASTNAME        WOR PHON HIREDATE  JOB         EDLEVEL S BIRTHDATE     SALARY      BONUS       COMM PHONENUM       
------ ------------ - --------------- --- ---- --------- -------- ---------- - --------- ---------- ---------- ---------- ---------------
000250 DANIEL       S SMITH           D21 0961 30-OCT-99 CLERK            15 M 12-NOV-69      49180        400       1534                
000260 SYBIL        P JOHNSON         D21 8953 11-SEP-05 CLERK            16 F 05-OCT-76      47250        300       1380                
000270 MARIA        L PEREZ           D21 9001 30-SEP-06 CLERK            15 F 26-MAY-03      37380        500       2190                
000280 ETHEL        R SCHNEIDER       E11 8997 24-MAR-97 OPERATOR         17 F 28-MAR-76      36250        500       2100 (416)123-8997  
000290 JOHN         R PARKER          E11 4502 30-MAY-06 OPERATOR         25 M 09-JUL-85      35340        300       1227 (416)123-4502  
000300 PHILIP       X SMITH           E11 2095 19-JUN-02 OPERATOR         14 M 27-OCT-76      37750        400       1420 (416)123-2095  
000310 MAUDE        F SETRIGHT        E11 3332 12-SEP-94 OPERATOR         12 F 21-APR-61      35900        300       1272 (416)123-3332  
000320 RAMLAL       V MEHTA           E21 9990 07-JUL-95 FIELDREP         16 M 11-AUG-62      39950        400       1596 (416)123-9990  
000330 WING           LEE             E21 2103 23-FEB-06 FIELDREP         14 M 18-JUL-71      45370        500       2030 (416)123-2103  
000340 JASON        R GOUNOT          E21 5698 05-MAY-77 FIELDREP         16 M 17-MAY-56      43840        500       1907 (416)123-5698  
200010 DIAN         J HEMMINGER       A00 3978 01-JAN-95 SALESREP         18 F 14-AUG-73      46500       1000       4220                

EMPNO  FIRSTNAME    M LASTNAME        WOR PHON HIREDATE  JOB         EDLEVEL S BIRTHDATE     SALARY      BONUS       COMM PHONENUM       
------ ------------ - --------------- --- ---- --------- -------- ---------- - --------- ---------- ---------- ---------- ---------------
200120 GREG           ORLANDO         A00 2167 05-MAY-02 CLERK            14 M 18-OCT-72      39250        600       2340                
200140 KIM          N NATZ            C01 1793 15-DEC-06 ANALYST          18 F 19-JAN-76      68420        600       2274                
200170 KIYOSHI        YAMAMOTO        D11 2890 15-SEP-05 DESIGNER         16 M 05-JAN-81      64680        500       1974                
200220 REBA         K JOHN            D11 0672 29-AUG-05 DESIGNER         18 F 19-MAR-78      69840        600       2387                
200240 ROBERT       M MONTEVERDE      D21 3780 05-DEC-04 CLERK            17 M 31-MAR-84      37760        600       2301                
200280 EILEEN       R SCHWARTZ        E11 8997 24-MAR-97 OPERATOR         17 F 28-MAR-66      46250        500       2100 (416)123-8997  
200310 MICHELLE     F SPRINGER        E11 3332 12-SEP-94 OPERATOR         12 F 21-APR-61      35900        300       1272 (416)123-3332  
200330 HELENA         WONG            E21 2103 23-FEB-06 FIELDREP         14 F 18-JUL-71      35370        500       2030 (416)123-2103  
200340 ROY          R ALONZO          E21 5698 05-JUL-97 FIELDREP         16 M 17-MAY-56      31840        500       1907 (416)123-5698  

42 rows selected. 


-- Section B

-- QUESTION 1:
-- Load in the documents into a collection called "music" from the dbs311.final.json file
-- WHAT TO HAND IN: The output from a db.music.find()
-- Q1 SOLUTION --
> db.music.find()
{ "_id" : ObjectId("611694e1926ceb64e61bd94e"), "artist" : "Pink Floyd", "albums" : [ { "title" : "The Dark Side of the Moon", "year" : 1973 }, { "title" : "The Wall", "year" : 1979 }, { "title" : "The Division Bell", "year" : 1994 }, { "title" : "Animals", "year" : 1977 }, { "title" : "Wish You Were Here", "year" : 1975 } ], "singers" : "David Gilmore and Roger Waters" }
{ "_id" : ObjectId("611694e1926ceb64e61bd94f"), "artist" : "Led Zeppelin", "albums" : [ { "title" : "Led Zeppelin I", "year" : 1969 }, { "title" : "Led Zeppelin 2", "year" : 1969 }, { "title" : "Led Zeppelin 3", "year" : 1970 }, { "title" : "Led Zeppelin 4", "year" : 1971 } ], "singers" : "Robert Plant" }
{ "_id" : ObjectId("611694e1926ceb64e61bd950"), "artist" : "Rush", "albums" : [ { "title" : "A Farewell to Kings", "year" : 1977 }, { "title" : "Moving Pictures", "year" : 1981 }, { "title" : "2112", "year" : 1976 }, { "title" : "Fly By Night", "year" : 1975 } ], "singers" : "Geddy Lee" }
{ "_id" : ObjectId("611694e1926ceb64e61bd951"), "artist" : "AC/DC", "albums" : [ { "title" : "High Voltage", "year" : 1976 }, { "title" : "Back in Black", "year" : 1980 }, { "title" : "Dirty Deeds Done Dirt Cheap", "year" : 1976 }, { "title" : "Highway to Hell", "year" : 1979 } ], "singers" : "Bon Scott" }

-- QUESTION 2:
-- Insert a new document into the collection, following the same structure as in the music collection, as follows:
-- Artist is "Scorpions"
-- Albums are: "Lovedrive" in 1979; "Blackout" in 1982, "Love at first sting" in 1984, "Eye to Eye" in 1999
-- Singer is: Klaus Meine
-- WHAT TO HAND IN: The insert command -? and - the return code - and - the output from a
-- db.music.find()
-- Q2 SOLUTION --
> db.music.insertOne({"artist" : "Scorpions", "albums" : [ { "title" : "Lovedrive", "year" : 1979 }, { "title" : "Blackout", "year" : 1982 }, { "title" : "Love at first sting", "year" : 1984 }, { "title" : "Eye to Eye", "year" : 1999 } ], "singers" : "Robert PlantKlaus Meine" });
{
        "acknowledged" : true,
        "insertedId" : ObjectId("611689639dd82d45c5ee3f32")
}

> db.music.find()
{ "_id" : ObjectId("611694e1926ceb64e61bd94e"), "artist" : "Pink Floyd", "albums" : [ { "title" : "The Dark Side of the Moon", "year" : 1973 }, { "title" : "The Wall", "year" : 1979 }, { "title" : "The Division Bell", "year" : 1994 }, { "title" : "Animals", "year" : 1977 }, { "title" : "Wish You Were Here", "year" : 1975 } ], "singers" : "David Gilmore and Roger Waters" }
{ "_id" : ObjectId("611694e1926ceb64e61bd94f"), "artist" : "Led Zeppelin", "albums" : [ { "title" : "Led Zeppelin I", "year" : 1969 }, { "title" : "Led Zeppelin 2", "year" : 1969 }, { "title" : "Led Zeppelin 3", "year" : 1970 }, { "title" : "Led Zeppelin 4", "year" : 1971 } ], "singers" : "Robert Plant" }
{ "_id" : ObjectId("611694e1926ceb64e61bd950"), "artist" : "Rush", "albums" : [ { "title" : "A Farewell to Kings", "year" : 1977 }, { "title" : "Moving Pictures", "year" : 1981 }, { "title" : "2112", "year" : 1976 }, { "title" : "Fly By Night", "year" : 1975 } ], "singers" : "Geddy Lee" }
{ "_id" : ObjectId("611694e1926ceb64e61bd951"), "artist" : "AC/DC", "albums" : [ { "title" : "High Voltage", "year" : 1976 }, { "title" : "Back in Black", "year" : 1980 }, { "title" : "Dirty Deeds Done Dirt Cheap", "year" : 1976 }, { "title" : "Highway to Hell", "year" : 1979 } ], "singers" : "Bon Scott" }
{ "_id" : ObjectId("61169508b5651b204a73ff9b"), "artist" : "Scorpions", "albums" : [ { "title" : "Lovedrive", "year" : 1979 }, { "title" : "Blackout", "year" : 1982 }, { "title" : "Love at first sting", "year" : 1984 }, { "title" : "Eye to Eye", "year" : 1999 } ], "singers" : "Robert PlantKlaus Meine" }

-- QUESTION 3:
-- Run a query which will output all of the bands and albums which hit the market in either the 1960s OR the 1990s.
-- The result set should include band, album title and year - nothing else (ie: no "_Id")
-- WHAT TO HAND IN: The query - and - the output as described above
-- Q3 SOLUTION --
> db.music.aggregate ([{$unwind: '$albums'}, {$match: {"$or" : [{"albums.year" : {"$gte" : 1960, "$lte" : 1969}}, {"albums.year" : {"$gte" : 1990, "$lte" : 1999}}]}}, { "$project": { "artist": 1, "albums": 1, "_id": 0 } }]);
{ "artist" : "Pink Floyd", "albums" : { "title" : "The Division Bell", "year" : 1994 } }
{ "artist" : "Led Zeppelin", "albums" : { "title" : "Led Zeppelin I", "year" : 1969 } }
{ "artist" : "Led Zeppelin", "albums" : { "title" : "Led Zeppelin 2", "year" : 1969 } }
{ "artist" : "Scorpions", "albums" : { "title" : "Eye to Eye", "year" : 1999 } }

-- QUESTION 4:
-- Run a query which reads a list of years and displays the bands and their albums which delivered in any year in the list
-- The result set should include band, album title and year ? nothing else (ie: no "_id")
-- Use a list of years which includes: 1971, 1973, 1975, 1977 and 1979
-- WHAT TO HAND IN: A copy of your query - and - the output as described above
-- Q4 SOLUTION --
> db.music.aggregate ([{ $unwind: '$albums'}, { $match: {"albums.year" : {"$in": [1971, 1973, 1975, 1977, 1979]}}}, { "$project": { "artist": 1, "albums": 1, "_id": 0 } }]);
{ "artist" : "Pink Floyd", "albums" : { "title" : "The Dark Side of the Moon", "year" : 1973 } }
{ "artist" : "Pink Floyd", "albums" : { "title" : "The Wall", "year" : 1979 } }
{ "artist" : "Pink Floyd", "albums" : { "title" : "Animals", "year" : 1977 } }
{ "artist" : "Pink Floyd", "albums" : { "title" : "Wish You Were Here", "year" : 1975 } }
{ "artist" : "Led Zeppelin", "albums" : { "title" : "Led Zeppelin 4", "year" : 1971 } }
{ "artist" : "Rush", "albums" : { "title" : "A Farewell to Kings", "year" : 1977 } }
{ "artist" : "Rush", "albums" : { "title" : "Fly By Night", "year" : 1975 } }
{ "artist" : "AC/DC", "albums" : { "title" : "Highway to Hell", "year" : 1979 } }
{ "artist" : "Scorpions", "albums" : { "title" : "Lovedrive", "year" : 1979 } }
>

-- QUESTION 5:
-- Run a set of commands which will add in a new attribute to each document called "Guitarist"
-- The values should be as follows:
-- For Rush - the guitarist is "Alex Lifeson"
-- For Scorpions - the guitarist is "Mathias Jabs"
-- For AC/DC - the guitarist is "Malcolm Young"
-- For Pink Floyd - the guitarist is "David Gilmore" and "Roger Waters" (should be a list)
-- For Led Zeppelin - the guitarist is "Jimmy Page"
-- WHAT TO HAND IN: A copy of your update commands - the return codes - and - the output from a
-- db.music.find() once all updates are complete (only do this at the end)
-- Q5 SOLUTION --
> db.music.updateOne({"artist": "Rush"}, {"$set": {"Guitarist": "Alex Lifeson"}});
{ "acknowledged" : true, "matchedCount" : 1, "modifiedCount" : 1 }
> db.music.updateOne({"artist": "Scorpions"}, {"$set": {"Guitarist": "Mathias Jabs"}});
{ "acknowledged" : true, "matchedCount" : 1, "modifiedCount" : 1 }
> db.music.updateOne({"artist": "AC/DC"}, {"$set": {"Guitarist": "Malcolm Young"}});
{ "acknowledged" : true, "matchedCount" : 1, "modifiedCount" : 1 }
> db.music.updateOne({"artist": "Pink Floyd"}, {"$set": {"Guitarist": ["David Gilmore", "Roger Waters"]}});
{ "acknowledged" : true, "matchedCount" : 1, "modifiedCount" : 1 }
> db.music.updateOne({"artist": "Led Zeppelin"}, {"$set": {"Guitarist": "Jimmy Page"}});
{ "acknowledged" : true, "matchedCount" : 1, "modifiedCount" : 1 }

> db.music.find()
{ "_id" : ObjectId("611694e1926ceb64e61bd94e"), "artist" : "Pink Floyd", "albums" : [ { "title" : "The Dark Side of the Moon", "year" : 1973 }, { "title" : "The Wall", "year" : 1979 }, { "title" : "The Division Bell", "year" : 1994 }, { "title" : "Animals", "year" : 1977 }, { "title" : "Wish You Were Here", "year" : 1975 } ], "singers" : "David Gilmore and Roger Waters", "Guitarist" : [ "David Gilmore", "Roger Waters" ] }
{ "_id" : ObjectId("611694e1926ceb64e61bd94f"), "artist" : "Led Zeppelin", "albums" : [ { "title" : "Led Zeppelin I", "year" : 1969 }, { "title" : "Led Zeppelin 2", "year" : 1969 }, { "title" : "Led Zeppelin 3", "year" : 1970 }, { "title" : "Led Zeppelin 4", "year" : 1971 } ], "singers" : "Robert Plant", "Guitarist" : "Jimmy Page" }
{ "_id" : ObjectId("611694e1926ceb64e61bd950"), "artist" : "Rush", "albums" : [ { "title" : "A Farewell to Kings", "year" : 1977 }, { "title" : "Moving Pictures", "year" : 1981 }, { "title" : "2112", "year" : 1976 }, { "title" : "Fly By Night", "year" : 1975 } ], "singers" : "Geddy Lee", "Guitarist" : "Alex Lifeson" }
{ "_id" : ObjectId("611694e1926ceb64e61bd951"), "artist" : "AC/DC", "albums" : [ { "title" : "High Voltage", "year" : 1976 }, { "title" : "Back in Black", "year" : 1980 }, { "title" : "Dirty Deeds Done Dirt Cheap", "year" : 1976 }, { "title" : "Highway to Hell", "year" : 1979 } ], "singers" : "Bon Scott", "Guitarist" : "Malcolm Young" }
{ "_id" : ObjectId("61169508b5651b204a73ff9b"), "artist" : "Scorpions", "albums" : [ { "title" : "Lovedrive", "year" : 1979 }, { "title" : "Blackout", "year" : 1982 }, { "title" : "Love at first sting", "year" : 1984 }, { "title" : "Eye to Eye", "year" : 1999 } ], "singers" : "Robert PlantKlaus Meine", "Guitarist" : "Mathias Jabs" }

-- QUESTION 6:
-- Run a query which shows each album and the year from the Scorpions
-- Run a command which increments each of the years by 5 for every album by Scorprions
-- Run a query which shows each album and the year from the Scorpions
-- WHAT TO HAND IN: A copy of all commands – the return codes – and – the output of the query commands
-- Q6 SOLUTION --
> db.music.aggregate([{$unwind: '$albums'}, {$match: {"artist" : "Scorpions"}}, { "$project": { "artist": 1, "albums": 1, "_id": 0 } }]);
{ "artist" : "Scorpions", "albums" : { "title" : "Lovedrive", "year" : 1979 } }
{ "artist" : "Scorpions", "albums" : { "title" : "Blackout", "year" : 1982 } }
{ "artist" : "Scorpions", "albums" : { "title" : "Love at first sting", "year" : 1984 } }
{ "artist" : "Scorpions", "albums" : { "title" : "Eye to Eye", "year" : 1999 } }

> db.music.update({ "artist" : "Scorpions" }, {$inc: {"albums.$[].year" : 5}}, { multi: true });
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })

> db.music.aggregate([{$unwind: '$albums'}, {$match: {"artist" : "Scorpions"}}, { "$project": { "artist": 1, "albums": 1, "_id": 0 } }]);
{ "artist" : "Scorpions", "albums" : { "title" : "Lovedrive", "year" : 1984 } }
{ "artist" : "Scorpions", "albums" : { "title" : "Blackout", "year" : 1987 } }
{ "artist" : "Scorpions", "albums" : { "title" : "Love at first sting", "year" : 1989 } }
{ "artist" : "Scorpions", "albums" : { "title" : "Eye to Eye", "year" : 2004 } }

-- QUESTION 7:
-- Run a command which removes the document for the Scorpions
-- Run a command which removes the album “The Wall” from Pink Floyd
-- Run a command which removes all albums that hit the market in the 1970s from all bands
-- WHAT TO HAND IN: A copy of the commands above – the return codes – and – the output from a db.music.find()
-- Q7 SOLUTION --
> db.music.remove({"artist": "Scorpions"})
WriteResult({ "nRemoved" : 1 })

> db.music.update({"artist": "Pink Floyd"}, {$pull: {"albums": {"title": "The Wall"}}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })

> db.music.update({}, {$pull: {"albums": {"year": {"$gte" : 1970, "$lte" : 1979}}}}, {multi: true})
WriteResult({ "nMatched" : 4, "nUpserted" : 0, "nModified" : 4 })

> db.music.find()
{ "_id" : ObjectId("611694e1926ceb64e61bd94e"), "artist" : "Pink Floyd", "albums" : [ { "title" : "The Division Bell", "year" : 1994 } ], "singers" : "David Gilmore and Roger Waters", "Guitarist" : [ "David Gilmore", "Roger Waters" ] }
{ "_id" : ObjectId("611694e1926ceb64e61bd94f"), "artist" : "Led Zeppelin", "albums" : [ { "title" : "Led Zeppelin I", "year" : 1969 }, { "title" : "Led Zeppelin 2", "year" : 1969 } ], "singers" : "Robert Plant", "Guitarist" : "Jimmy Page" }
{ "_id" : ObjectId("611694e1926ceb64e61bd950"), "artist" : "Rush", "albums" : [ { "title" : "Moving Pictures", "year" : 1981 } ], "singers" : "Geddy Lee", "Guitarist" : "Alex Lifeson" }
{ "_id" : ObjectId("611694e1926ceb64e61bd951"), "artist" : "AC/DC", "albums" : [ { "title" : "Back in Black", "year" : 1980 } ], "singers" : "Bon Scott", "Guitarist" : "Malcolm Young" }

