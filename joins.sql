-- Joins
--------------------SELF JOIN-----------------------------------------------
SELECT first_name, country
FROM employees e, regions r
WHERE e.region_id = r.region_id


SELECT first_name, email, division
FROM employees e, departments d
WHERE e.department = d.department
AND email IS NOT NULL

SELECT first_name, email, e.department division
FROM employees e, departments d, regions r
WHERE e.department = d.department
AND e.region_id = r.region_id
AND email IS NOT NULL

SELECT * FROM regions

SELECT r.country, count(employee_id)
FROM employees e, regions r -- (SELECT * FROM regions) r --> Both are same
WHERE e.region_id = r.region_id
GROUP BY r.country

------------------------INNER, LEFT, RIGHT JOINS------------------------------------------------------
SELECT first_name, country
FROM employees e INNER JOIN regions r
ON e.region_id = r.region_id

SELECT first_name, email, division
FROM employees e INNER JOIN departments d
ON e.department = d.department
WHERE email IS NOT NULL

SELECT first_name, email, division, r.country
FROM employees e 
INNER JOIN departments d ON e.department = d.department
INNER JOIN regions r ON e.region_id = r.region_id --> This join joining with the result of the first inner join (employees & department table)
WHERE email IS NOT NULL

SELECT DISTINCT department FROM employees
-- 27 departments

SELECT DISTINCT department FROM departments
-- 24 departments

SELECT DISTINCT e.department, d.department
FROM employees e
INNER JOIN departments d ON e.department = d.department
-- 23 matching records (from emp & dept table) will be returned

SELECT DISTINCT e.department, d.department
FROM employees e
LEFT JOIN departments d ON e.department = d.department
--> It will return all the data from left (emp)table and then right (dep)table 

SELECT DISTINCT e.department, d.department
FROM employees e
RIGHT JOIN departments d ON e.department = d.department
--> It will return all the data from right (dep)table and then right (emp)table 

SELECT DISTINCT e.department as employees_department, d.department as departments_department
FROM employees e
LEFT JOIN departments d ON e.department = d.department
WHERE d.department IS NULL

SELECT DISTINCT e.department as employees_department, d.department as departments_department
FROM employees e
FULL OUTER JOIN departments d ON e.department = d.department

---------------------UNION, UNION ALL, EXCEPT Clause-----------------------------------------------------------------

-- UNION will return unique data so no need to include DISTINCT
SELECT department FROM employees
UNION  
SELECT department FROM departments 

-- UNION ALL will return all the data including duplicates
SELECT DISTINCT department FROM employees --> 27 records
UNION ALL --> Combines both records --> 27 + 24 => 51 total records
SELECT department FROM departments --> 24 records


--> Queries should have same number of columns and datatypes when using UNION, UNION ALL

(SELECT DISTINCT department 
FROM employees 
UNION ALL 
SELECT department 
FROM departments 
UNION 
SELECT country
FROM regions) ---> it will consider as a single query => ORDER BY Clause should come at last
ORDER BY department 

--> EXCLUDE the common data from the two table or we can say it will ignore the data from the second table

SELECT DISTINCT department FROM employees
EXCEPT  
SELECT department FROM departments 

SELECT department FROM departments
EXCEPT 
SELECT DISTINCT department FROM employees 

SELECT department, COUNT(*)
FROM employees 
GROUP BY department
UNION ALL
SELECT 'TOTAL', COUNT(*)
FROM employees

-- Cartesian Product using no joins or using CROSS JOIN
SELECT * 
FROM employees, departments --> returns 24000 records (1000 emp records * 24 dept records)

SELECT * 
FROM employees CROSS JOIN departments --> returns 24000 records (1000 emp records * 24 dept records)

(SELECT first_name, department, hire_date, country
FROM employees e
INNER JOIN regions r ON e.region_id = r.region_id
WHERE hire_date = (SELECT MIN(hire_date) FROM employees e2)
LIMIT 1)
UNION
SELECT first_name, department, hire_date, country
FROM employees e
INNER JOIN regions r ON e.region_id = r.region_id
WHERE hire_date = (SELECT MAX(hire_date) FROM employees e2)
ORDER BY hire_date


SELECT hire_date, salary,
(SELECT SUM(salary)FROM employees e2 WHERE e2.hire_date BETWEEN e.hire_date - 90 AND e.hire_date) as spending_pattern
FROM employees e
ORDER BY hire_date

------------------Creating Views----------------------------------------------------------------------------------------

CREATE VIEW v_employee_information as
SELECT first_name,email, e.department, salary, division, region, country
FROM employees e, departments d, regions r
WHERE e.department = d.department
AND e.region_id = r.region_id
