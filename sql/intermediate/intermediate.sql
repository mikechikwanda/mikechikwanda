-- Inner Join: Returns only matching rows from both tables
SELECT dem.first_name, dem.last_name, sal.occupation
FROM parks_and_recreation.employee_demographics AS dem
INNER JOIN parks_and_recreation.employee_salary AS sal
    ON dem.employee_id = sal.employee_id;

-- Left (Outer) Join: Returns all records from the left table, with matching rows from the right table
SELECT dem.employee_id, dem.first_name, dem.last_name, sal.occupation
FROM parks_and_recreation.employee_demographics AS dem
LEFT JOIN parks_and_recreation.employee_salary AS sal
    ON dem.employee_id = sal.employee_id;

-- Right Join: Returns all records from the right table, with matching rows from the left table
SELECT dem.employee_id, dem.first_name, dem.last_name, sal.occupation
FROM parks_and_recreation.employee_demographics AS dem
RIGHT JOIN parks_and_recreation.employee_salary AS sal
    ON dem.employee_id = sal.employee_id;

-- Self Join: Matches employees in consecutive order by ID
SELECT emp1.employee_id AS emp_santa, emp1.first_name AS santa_name,
       emp2.employee_id AS emp_id, emp2.first_name AS emp_name
FROM employee_salary emp1
JOIN employee_salary emp2
    ON emp1.employee_id + 1 = emp2.employee_id;

-- Joining Multiple Tables: Combining three tables
SELECT *
FROM parks_and_recreation.employee_demographics AS dem
INNER JOIN parks_and_recreation.employee_salary AS sal
    ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS pd
    ON sal.dept_id = pd.department_id;

-- UNION: Combines rows from both queries (removes duplicates)
SELECT first_name, last_name FROM employee_demographics
UNION
SELECT first_name, last_name FROM employee_salary;

-- UNION ALL: Combines rows from both queries (includes duplicates)
SELECT first_name, last_name FROM employee_demographics
UNION ALL
SELECT first_name, last_name FROM employee_salary;

-- Example UNION use case: Categorizing employees based on age and salary
SELECT first_name, last_name, 'old man' AS label 
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'old woman' AS label 
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'high pay' AS label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name;

-- case statements

SELECT 
	CONCAT(first_name, ' ', last_name) as full_name,
    salary as sal,
CASE
	WHEN salary > 50000 THEN salary * 1.05
    WHEN salary < 50000 THEN salary * 1.07
    ELSE salary
END as new_salary,
CASE 
	WHEN dept_id = 6 THEN salary * 1.10
END as bonus
FROM employee_salary;

-- sub queries
SELECT CONCAT(first_name,' ',last_name) AS full_names
FROM employee_demographics
WHERE employee_id IN 
	(SELECT employee_id
    FROM employee_salary
    WHERE employee_id = 1)
;