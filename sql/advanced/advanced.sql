-- advance section
SELECT * from employee_demographics;

-- cte
WITH cte_eg AS
(
SELECT gender, AVG(salary) as avg_sal, MAX(salary) AS max_sal, MIN(salary) as min_sal, COUNT(salary) as tot_sal
FROM employee_demographics dem 
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)

select AVG(avg_sal)
FROM cte_eg;

-- temporary tables, these last as long as you are within the session 
CREATE TEMPORARY TABLE employees_over_50k
SELECT*
FROM employee_salary
WHERE salary > 50000;dept_id

SELECT * 
FROM employees_over_50k;

-- stored prodedures

DELIMITER $$
CREATE PROCEDURE large_sal()
BEGIN
	SELECT*
	FROM employee_salary
	WHERE salary >= 50000;
END $$
DELIMITER ;

CALL large_sal();

-- parameters
DELIMITER $$
CREATE PROCEDURE large_sal2( employee_id_param INT)
BEGIN
	SELECT*
	FROM employee_salary
	WHERE employee_id = employee_id_param;
END $$
DELIMITER ;

CALL large_sal2(1)

-- triggers and events
DELIMITER $$

CREATE TRIGGER employee_insert
AFTER INSERT ON employee_salary
FOR EACH ROW
BEGIN
    INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$

DELIMITER ;


INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id) VALUES
(50, 'John', 'Doe', 'Software Engineer', 80000.00, 101),
(21, 'Jane', 'Smith', 'HR Manager', 90000.00, 102),
(33, 'Alice', 'Johnson', 'Accountant', 75000.00, 103);

select * from employee_demographics;