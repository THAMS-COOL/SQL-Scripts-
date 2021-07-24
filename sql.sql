--Execute this query in pgadmin of test DB
--===============================================================================

SELECT *
FROM employees
WHERE department LIKE 'F%nitu%'

SELECT *
FROM employees
ORDER BY employee_id DESC

SELECT *
FROM employees
ORDER BY department DESC

SELECT *
FROM employees
ORDER BY salary DESC

-- Exclude Duplicate
SELECT DISTINCT department as sorted_dept
FROM employees
ORDER BY 1
--LIMIT 10
FETCH FIRST 4 ROWS ONLY

-- Without using distinct Keyword
SELECT department
FROM employees
GROUP BY department

-- SQL Functions

SELECT UPPER(first_name), LOWER(department)
FROM employees

SELECT LENGTH(first_name), first_name
FROM employees

SELECT LENGTH(TRIM('    Hello There  '))

SELECT first_name ||' ' || last_name as full_name, (salary > 140000) as status
FROM employees
ORDER BY salary desc

SELECT department, ('Clothing' IN (department)) -- Boolean Experession
from employees


SELECT 'This is the test data' test_data

-- Starts from 9 for in 4 charactors

SELECT SUBSTRING('This is the test data' FROM 9 FOR 4) test_data_extract

SELECT department, REPLACE(department, 'Clothing', 'Attire') modified_data FROM departments

SELECT department, 
REPLACE(department, 'Clothing', 'Attire') modified_data,
department || ' department' as "Complete Department Name"
FROM departments

SELECT POSITION('@' IN email)
FROM employees

SELECT SUBSTRING(email, POSITION('@' IN email))
FROM employees

SELECT COALESCE(email, 'NONE') as email
FROM employees

-- Aggregate Functions

SELECT COUNT(*), make
FROM cars
GROUP BY make

SELECT make 
FROM cars
GROUP BY make

SELECT SUM(salary), department
FROM employees
WHERE region_id in (4,5,6,7)
GROUP BY department

SELECT COUNT(employee_id),department
FROM employees
GROUP BY department

SELECT department,COUNT(*) total_number_employees, ROUND(AVG(salary)) avg_sal, 
MIN(salary) min_sal, MAX(salary) max_sal
FROM employees
WHERE salary > 70000
GROUP BY department
ORDER BY total_number_employees desc

SELECT department,gender,COUNT(*)
FROM employees
GROUP BY department, gender
ORDER BY department

-- Having --> To filter aggregate (grouped) data use HAVING clause

SELECT department,COUNT(*)
FROM employees
GROUP BY department
HAVING count(*) > 35
ORDER BY department


SELECT first_name, count(*) as employee_count
FROM employees
GROUP BY first_name
HAVING count(*) > 1
ORDER BY employee_count DESC

-- Without using distinct Keyword
SELECT department
FROM employees
GROUP BY department


SELECT SUBSTRING(email, POSITION('@' IN email)+ 1) as email_domain, COUNT(*) as _count
FROM employees
WHERE email IS NOT NULL
GROUP BY email_domain
ORDER BY _count DESC


SELECT gender, region_id, MIN(salary) as min_sal, MAX(salary) as max_sal, round(AVG(salary)) as avg_sal
FROM employees
--WHERE 1 = 1
GROUP BY gender, region_id
ORDER BY gender desc, region_id asc


-- Aliasing Sources of Data
--=================================================================

SELECT first_name, last_name, * 
FROM employees

SELECT e.department, d.department
FROM employees e, departments d

-- Sub Queries
------------------------------------------------
SELECT * FROM employees
WHERE department NOT IN (SELECT department FROM departments)

SELECT * 
FROM (SELECT * FROM employees WHERE salary > 150000) a -- We need to aillas

SELECT a.first_name, a.last_name
FROM (SELECT * FROM employees WHERE salary > 150000) a

SELECT a.employee_name, a.yearly_salary
FROM (SELECT first_name employee_name, salary yearly_salary 
	  FROM employees WHERE salary > 150000) a

SELECT employee_name, yearly_salary
FROM (SELECT first_name employee_name, salary yearly_salary 
	  FROM employees WHERE salary > 150000) a


SELECT a.employee_name, a.yearly_salary,department
FROM (SELECT first_name employee_name, salary yearly_salary 
	  FROM employees WHERE salary > 150000) a,
	  (SELECT department FROM departments) b

SELECT first_name, last_name, salary, (SELECT first_name FROM employees limit 1)
FROM employees

SELECT *
FROM employees
WHERE department IN (SELECT department FROM departments
					 WHERE division = 'Electronics' )
	 
SELECT * 
FROM employees e
WHERE e.salary > 130000
AND region_id IN (SELECT region_id FROM regions 
	 			  WHERE country = 'Asia' OR country = 'Canada')

SELECT first_name, department,salary,(SELECT MAX(salary) FROM employees), (SELECT MAX(salary) FROM employees) - salary
FROM employees
WHERE region_id IN (SELECT region_id FROM regions 
	 			    WHERE country IN ('Asia', 'Canada'))
					


SELECT * FROM employees
WHERE region_id IN (SELECT region_id FROM regions WHERE country = 'United States')

SELECT * FROM employees
WHERE region_id > ANY (SELECT region_id FROM regions WHERE country = 'United States')

SELECT * FROM employees
WHERE region_id > ALL (SELECT region_id FROM regions WHERE country = 'United States') 

SELECT *
FROM employees e
WHERE e.hire_date > ALL (SELECT hire_date FROM employees WHERE department = 'Maintenance')
AND department IN (SELECT department FROM departments
					 WHERE division = 'Kids' ) 

SELECT *
FROM employees e
WHERE department = ANY (SELECT department FROM departments
					 WHERE division = 'Kids' ) 
AND e.hire_date > ALL (SELECT hire_date FROM employees 
					   WHERE department = 'Maintenance')

SELECT salary FROM (
SELECT salary, count(*)
FROM employees
GROUP BY salary
ORDER BY count(*) desc, salary desc
LIMIT 1 ) a

SELECT salary 
FROM employees
GROUP BY salary
HAVING count(*) >= ALL (SELECT COUNT(*) FROM employees
					    GROUP BY salary)
ORDER BY salary desc
LIMIT 1
----------------------------------------------------------------------------------

SELECT min(id),name
FROM dupes
GROUP BY name

SELECT * 
FROM dupes
WHERE id IN (SELECT min(id) 
			 FROM dupes 
			 GROUP BY name
)


SELECT ROUND(AVG(salary)) 
FROM employees
WHERE salary NOT IN (
(SELECT MIN(salary) FROM employees),
(SELECT MAX(salary) FROM employees)
)

--================================================================================
--CASE
---------------------------------------------------------------------------
SELECT first_name, salary,
CASE 
	WHEN salary < 100000 THEN 'UNDER PAID'
	WHEN salary > 100000 AND salary < 160000 THEN 'PAID WELL'
	ELSE 'EXECUTIVE'
END as category
FROM employees
ORDER BY salary desc


SELECT a.category, COUNT(*) FROM (
	SELECT first_name, salary,
	CASE 
		WHEN salary < 100000 THEN 'UNDER PAID'
		WHEN salary > 100000 AND salary < 160000 THEN 'PAID WELL'
		ELSE 'EXECUTIVE'
	END as category
	FROM employees
	ORDER BY salary desc
	) a
GROUP BY a.category

-- To Transpose 

SELECT SUM(CASE WHEN salary < 100000 THEN 1 ELSE 0 END) as under_paid,
SUM(CASE WHEN salary > 100000 AND salary < 150000 THEN 1 ELSE 0 END) as paid_well,
SUM(CASE WHEN salary > 150000 THEN 1 ELSE 0 END) as executive
FROM employees

-- Transposing the data using the CASE Clause

SELECT department, count(*)
FROM employees
WHERE department IN ('Sports', 'Tools', 'Clothing', 'Computers')
GROUP BY department

SELECT SUM(CASE WHEN department = 'Sports' THEN 1 ELSE 0 END) as sports_employees,
SUM(CASE WHEN department = 'Tools' THEN 1 ELSE 0 END) as tools_employees,
SUM(CASE WHEN department = 'Clothing' THEN 1 ELSE 0 END) as clothing_employees,
SUM(CASE WHEN department = 'Computers' THEN 1 ELSE 0 END) as computers_employees
FROM employees


SELECT first_name,
CASE WHEN region_id = 1 THEN (SELECT country FROM regions WHERE region_id = 1) END region_1,
CASE WHEN region_id = 2 THEN (SELECT country FROM regions WHERE region_id = 2) END region_2,
CASE WHEN region_id = 3 THEN (SELECT country FROM regions WHERE region_id = 3) END region_3,
CASE WHEN region_id = 4 THEN (SELECT country FROM regions WHERE region_id = 4) END region_4,
CASE WHEN region_id = 5 THEN (SELECT country FROM regions WHERE region_id = 5) END region_5,
CASE WHEN region_id = 6 THEN (SELECT country FROM regions WHERE region_id = 6) END region_6,
CASE WHEN region_id = 7 THEN (SELECT country FROM regions WHERE region_id = 7) END region_7
FROM employees

SELECT * from regions

SELECT COUNT(a.region_1) + COUNT(a.region_2) + COUNT(a.region_3) as united_states, 
COUNT(a.region_4) + COUNT(a.region_5) as asia, COUNT(a.region_6) + COUNT(a.region_7) as canada 
FROM (
SELECT first_name,
CASE WHEN region_id = 1 THEN (SELECT country FROM regions WHERE region_id = 1) END region_1,
CASE WHEN region_id = 2 THEN (SELECT country FROM regions WHERE region_id = 2) END region_2,
CASE WHEN region_id = 3 THEN (SELECT country FROM regions WHERE region_id = 3) END region_3,
CASE WHEN region_id = 4 THEN (SELECT country FROM regions WHERE region_id = 4) END region_4,
CASE WHEN region_id = 5 THEN (SELECT country FROM regions WHERE region_id = 5) END region_5,
CASE WHEN region_id = 6 THEN (SELECT country FROM regions WHERE region_id = 6) END region_6,
CASE WHEN region_id = 7 THEN (SELECT country FROM regions WHERE region_id = 7) END region_7
FROM employees ) a


-- Correlated Sub Queries --> Joining the results of 2 or more sub queries 
--===============================================================================

SELECT first_name, salary
FROM employees e1
WHERE salary > (SELECT round(AVG(salary))
			   FROM employees e2 WHERE e1.region_id = e2.region_id)
			   

SELECT first_name, department, salary,
(SELECT round(AVG(salary))
			   FROM employees e2 WHERE e1.department = e2.department) as avg_department_salary
FROM employees e1


SELECT department, (SELECT MAX(salary) FROM employees WHERE department = d.department)
FROM departments d
WHERE 38 < (SELECT COUNT(*) FROM employees e 
			WHERE d.department = e.department)

SELECT department, first_name, salary,
CASE
	WHEN salary = max_by_department THEN 'Highest Salary'
	WHEN salary = min_by_department THEN 'Lowest Salary'
	END as salary_in_department
FROM (
SELECT department, first_name, salary,
	(SELECT MAX(salary) FROM employees e2
	WHERE e1.department = e2.department) as max_by_department,
	(SELECT MIN(salary) FROM employees e2
	WHERE e1.department = e2.department) as min_by_department	
FROM employees e1
	) a
WHERE salary IN (max_by_department, min_by_department)
ORDER BY department -- or 1




























