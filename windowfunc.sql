-------------------Windows Functions-------------------------------------------------
SELECT first_name, department, (SELECT COUNT(*) FROM employees e2 
									 WHERE e1.department = e2.department)
FROM employees e1
GROUP BY department, first_name

SELECT first_name, department,
COUNT(*) OVER(PARTITION BY department)
FROM employees e1

SELECT first_name, department,
SUM(salary) OVER(PARTITION BY department)
FROM employees e1

SELECT first_name, department,
COUNT(*) OVER(PARTITION BY department) dept_count,
region_id,
COUNT(*) OVER(PARTITION BY region_id) reg_count
FROM employees e2

-- A window is basically a group of data or a data set that you want to compute an aggregation on
-- and the window changes based on the partition 


SELECT first_name, department, --> then third
COUNT(*) OVER (PARTITION BY department) --> Finally window function will execute
FROM employees --> Executes first
WHERE region_id = 3 --> Then second


SELECT first_name, hire_date, salary,
SUM(salary) OVER(ORDER BY hire_date RANGE BETWEEN UNBOUNDED PRECEDING 
				AND CURRENT ROW) as running_total_of_salaries
FROM employees



SELECT first_name, hire_date, department, salary,
SUM(salary) OVER(PARTITION BY department ORDER BY hire_date) as running_total_of_salaries
FROM employees 

SELECT first_name, hire_date, department, salary,
SUM(salary) OVER(ORDER BY hire_date ROWS BETWEEN 1 PRECEDING 
				 AND CURRENT ROW)
FROM employees 

-------------- RANK(), FIRST_VALUE, NTILE ----------------------------------------------------
SELECT first_name, email, department, salary,
RANK() OVER(PARTITION BY department ORDER BY salary DESC )
FROM employees

SELECT * FROM (
SELECT first_name, email, department, salary,
RANK() OVER(PARTITION BY department ORDER BY salary DESC )
FROM employees ) a

WHERE rank = 5

--> NTILE --> based on department partition it divides by 5
SELECT first_name, email, department, salary,
NTILE(5) OVER(PARTITION BY department ORDER BY salary DESC ) salary_bucket
FROM employees

SELECT first_name, email, department, salary,
FIRST_VALUE(salary) OVER(PARTITION BY department ORDER BY salary DESC ) first_value
FROM employees

SELECT first_name, email, department, salary,
nth_value(salary, 5) OVER(PARTITION BY department ORDER BY salary DESC ) nth_value
FROM employees

SELECT first_name,last_name, salary,
LEAD(salary) OVER() next_salary
FROM employees

SELECT first_name,last_name, salary,
LAG(salary) OVER() previous_salary
FROM employees

SELECT last_name,salary,closest_higher_salary FROM (
SELECT department, last_name, salary,
LAG(salary) OVER(ORDER BY salary desc) closest_higher_salary
FROM employees
	) a
WHERE closest_higher_salary IS NOT NULL
LIMIT 1


SELECT department, last_name, salary,
LEAD(salary) OVER(ORDER BY salary desc) closest_lower_salary
FROM employees

-----------------------------------------GROUPING SETS, ROLLUP, CUBE------------------------

SELECT * FROM sales
ORDER BY continent, country, city

SELECT continent, SUM(units_sold)
FROM sales
GROUP BY continent

SELECT country, SUM(units_sold)
FROM sales
GROUP BY country

SELECT city, SUM(units_sold)
FROM sales
GROUP BY city


SELECT continent, country, city, SUM(units_sold)
FROM sales
GROUP BY GROUPING SETS (continent, country, city, ())


SELECT continent, country, city, SUM(units_sold)
FROM sales
GROUP BY ROLLUP (continent, country, city)



SELECT continent, country, city, SUM(units_sold)
FROM sales
GROUP BY CUBE (continent, country, city)






