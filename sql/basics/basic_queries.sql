-- 1. SELECT Statement: Selects all columns from the given table in a particular database
SELECT * 
FROM parks_and_recreation.employee_demographics;

-- 2. Filtering Data with WHERE
-- Returns those aged above 30
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE age > 30;

-- 3. Logical Operators
-- Returns only females with age above 30
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE age > 30 AND gender = 'Female';

-- Notice the use of NOT
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE NOT gender = 'Male';

-- 4. Using Ranges (BETWEEN)
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE age BETWEEN 30 AND 40;

-- 5. Pattern Matching with LIKE
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE 'L%';

-- 6. Sorting Data with ORDER BY
-- Sort by age in descending order
SELECT * 
FROM parks_and_recreation.employee_demographics
ORDER BY age DESC;

-- Sort by multiple columns
SELECT * 
FROM parks_and_recreation.employee_demographics
ORDER BY gender ASC, age DESC;

-- 7. Limiting Output with LIMIT
SELECT * 
FROM parks_and_recreation.employee_demographics
LIMIT 5;

-- 8. Aggregate Functions
-- Counts the total number of employees
SELECT COUNT(*) 
FROM parks_and_recreation.employee_demographics;

-- Finds the average age of employees
SELECT AVG(age) 
FROM parks_and_recreation.employee_demographics;

-- Finds the minimum age among employees
SELECT MIN(age) 
FROM parks_and_recreation.employee_demographics;

-- Finds the sum of all employee ages
SELECT SUM(age) 
FROM parks_and_recreation.employee_demographics;

-- 9. Grouping Data with GROUP BY
-- Groups employees by gender and counts the number of employees per gender
SELECT gender, COUNT(*) 
FROM parks_and_recreation.employee_demographics
GROUP BY gender;

-- 10. Filtering Groups with HAVING
-- Groups employees by gender and returns only those with an average age greater than 30
SELECT gender, AVG(age) 
FROM parks_and_recreation.employee_demographics
GROUP BY gender
HAVING AVG(age) > 30;

-- 11. Combining Results with UNION
-- Combines the list of female and male first names
SELECT first_name 
FROM parks_and_recreation.employee_demographics 
WHERE gender = 'Female'
UNION
SELECT first_name 
FROM parks_and_recreation.employee_demographics 
WHERE gender = 'Male';

-- 12. Using UNION ALL for All Results (Including Duplicates)
-- Combines the list of female and male first names, including duplicates
SELECT first_name 
FROM parks_and_recreation.employee_demographics 
WHERE gender = 'Female'
UNION ALL
SELECT first_name 
FROM parks_and_recreation.employee_demographics 
WHERE gender = 'Male';

-- 13. Aliasing Columns and Tables
-- Renames columns in the result set for better readability
SELECT first_name AS "Employee First Name", last_name AS "Employee Last Name"
FROM parks_and_recreation.employee_demographics;

-- 14. Subqueries (Nested Queries)
-- Retrieves employees with a salary greater than the average salary
SELECT first_name, salary
FROM parks_and_recreation.employee_salary
WHERE salary > (SELECT AVG(salary) FROM parks_and_recreation.employee_salary);

-- Using IN with Subqueries
-- Retrieves employees whose ID appears in the list of employees with a salary greater than 50,000
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE employee_id IN (SELECT employee_id FROM parks_and_recreation.employee_salary WHERE salary > 50000);
