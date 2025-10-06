
CREATE TABLE employees (
                           employee_id SERIAL PRIMARY KEY,
                           first_name VARCHAR(50),
                           last_name VARCHAR(50),
                           department VARCHAR(50),
                           salary NUMERIC(10,2),
                           hire_date DATE,
                           manager_id INTEGER,
                           email VARCHAR(100)
);
CREATE TABLE projects (
                          project_id SERIAL PRIMARY KEY,
                          project_name VARCHAR(100),
                          budget NUMERIC(12,2),
                          start_date DATE,
                          end_date DATE,
                          status VARCHAR(20)
);
CREATE TABLE assignments (
                             assignment_id SERIAL PRIMARY KEY,
                             employee_id INTEGER REFERENCES employees(employee_id),
                             project_id INTEGER REFERENCES projects(project_id),
                             hours_worked NUMERIC(5,1),
                             assignment_date DATE;

--task 1.1
SELECT
    first_name || ' ' || last_name AS full_name,
    department,
    salary
FROM employees;
--task 1.2
SELECT DISTINCT department
FROM employees;
--task 1.3
SELECT
    project_name,
    budget,
    CASE
        WHEN budget > 150000 THEN 'Large'
        WHEN budget BETWEEN 100000 AND 150000 THEN 'Medium'
        ELSE 'Small'
        END AS budget_category
FROM projects;
--task 1.4
SELECT
    first_name || ' ' || last_name AS employee_name,
    COALESCE(email, 'No email provided') AS email
FROM employees;

--part 2

--task 2.1
SELECT *
FROM employees
WHERE hire_date > '2020-01-01';

--task 2.2

SELECT *
FROM employees
WHERE salary BETWEEN 60000 AND 70000;

--task 2.3
SELECT *
FROM employees
WHERE last_name LIKE 'S%' OR last_name LIKE 'J%';

--task 2.4
SELECT *
FROM employees
WHERE manager_id IS NOT NULL
  AND department = 'IT';

-- Prat 3

-- task 3.1
SELECT
    UPPER(first_name || ' ' || last_name) AS employee_name_upper,
    LENGTH(last_name) AS last_name_length,
    SUBSTRING(email FROM 1 FOR 3) AS email_prefix
FROM employees;

--task 3.2

SELECT
    first_name || ' ' || last_name AS employee_name,
    salary AS monthly_salary,
    salary * 12 AS annual_salary,
    ROUND(salary, 2) AS monthly_salary_rounded,
    salary * 0.1 AS raise_amount,
    salary * 1.1 AS new_salary
FROM employees;


-- task 3.3

SELECT
    FORMAT('Project: %s - Budget: $%s - Status: %s',
           project_name, budget, status) AS project_info
FROM projects;

--task 3.4

SELECT
    first_name || ' ' || last_name AS employee_name,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) AS years_with_company
FROM employees;

-- Part 4
-- task 4.1
SELECT
    department,
    ROUND(AVG(salary), 2) AS average_salary
FROM employees
GROUP BY department;

--task 4.2

SELECT
    p.project_name,
    SUM(a.hours_worked) AS total_hours_worked
FROM projects p
         JOIN assignments a ON p.project_id = a.project_id
GROUP BY p.project_id, p.project_name;

--task 4.3

SELECT
    department,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 1;

--task 4.4
SELECT
    MAX(salary) AS maximum_salary,
    MIN(salary) AS minimum_salary,
    SUM(salary) AS total_payroll
FROM employees;

-- Part 5
-- task 5.1


SELECT
    employee_id,
    first_name || ' ' || last_name AS full_name,
    salary
FROM employees
WHERE salary > 65000 OR hire_date > '2020-01-01'
ORDER BY salary DESC;


--task 5.2
SELECT
    employee_id,
    first_name || ' ' || last_name AS full_name,
    salary,
    department
FROM employees
WHERE department = 'IT'

INTERSECT

SELECT
    employee_id,
    first_name || ' ' || last_name AS full_name,
    salary,
    department
FROM employees
WHERE salary > 65000;

--task 5.3

SELECT employee_id, first_name, last_name
FROM employees

EXCEPT

SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
         JOIN assignments a ON e.employee_id = a.employee_id;

--Part 6
--task 6.1
SELECT *
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM assignments a
    WHERE a.employee_id = e.employee_id
);


--task 6.2
SELECT *
FROM employees
WHERE employee_id IN (
    SELECT DISTINCT a.employee_id
    FROM assignments a
             JOIN projects p ON a.project_id = p.project_id
    WHERE p.status = 'Active'
);


--task 6.3
SELECT
    employee_id,
    first_name || ' ' || last_name AS full_name,
    salary,
    department
FROM employees
WHERE salary > ANY (
    SELECT salary
    FROM employees
    WHERE department = 'Sales'
);

--Part 7

--Task 7.1
SELECT
    e.first_name || ' ' || e.last_name AS employee_name,
    e.department,
    e.salary,
    ROUND(AVG(a.hours_worked), 1) AS avg_hours_worked,
    (SELECT COUNT(*) + 1
     FROM employees e2
     WHERE e2.department = e.department AND e2.salary > e.salary) AS salary_rank
FROM employees e
         LEFT JOIN assignments a ON e.employee_id = a.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.department, e.salary
ORDER BY e.department, salary_rank;

--task 7.2
SELECT
    p.project_name,
    SUM(a.hours_worked) AS total_hours,
    COUNT(DISTINCT a.employee_id) AS employees_assigned
FROM projects p
         JOIN assignments a ON p.project_id = a.project_id
GROUP BY p.project_id, p.project_name
HAVING SUM(a.hours_worked) > 150;
--task 7,3
SELECT
    department,
    COUNT(*) AS total_employees,
    ROUND(AVG(salary), 2) AS average_salary,
    (SELECT first_name || ' ' || last_name
     FROM employees e2
     WHERE e2.department = e1.department
     ORDER BY salary DESC
     LIMIT 1) AS highest_paid_employee,
    GREATEST(MAX(salary), 0) AS max_salary_display,
    LEAST(MIN(salary), 1000000) AS min_salary_display
FROM employees e1
GROUP BY department;