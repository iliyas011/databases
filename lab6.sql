--CREATE  database  lab6;

--part 1
CREATE TABLE employeese
(
    emp_id   INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id  INT,
    salary   DECIMAL(10, 2)
);

CREATE TABLE departments
(
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location  VARCHAR(50)
);
CREATE TABLE projects
(
    project_id   INT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id      INT,
    budget       DECIMAL(10, 2)
);


INSERT INTO employeese (emp_id, emp_name, dept_id, salary)
VALUES
    (1, 'John Smith', 101, 50000),
    (2, 'Jane Doe', 102, 60000),
    (3, 'Mike Johnson', 101, 55000),
    (4, 'Sarah Williams', 103, 65000),
    (5, 'Tom Brown', NULL, 45000);

INSERT INTO departments (dept_id, dept_name, location) VALUES
                                                           (101, 'IT', 'Building A'),
                                                           (102, 'HR', 'Building B'),
                                                           (103, 'Finance', 'Building C'),
                                                           (104, 'Marketing', 'Building D');

INSERT INTO projects (project_id, project_name, dept_id,
                      budget) VALUES
                                  (1, 'Website Redesign', 101, 100000),
                                  (2, 'Employee Training', 102, 50000),
                                  (3, 'Budget Analysis', 103, 75000),
                                  (4, 'Cloud Migration', 101, 150000),
                                  (5, 'AI Research', NULL, 200000);


-- part 2
-- CROSS JOIN
SELECT e.emp_name, d.dept_name
FROM employeese e CROSS JOIN departments d;
-- they have 20 rows  the result

SELECT  e.emp_name , d.dept_name
FROM  employeese e, departments d;

SELECT  e.emp_name , d.dept_name
FROM employeese e
         INNER JOIN  departments d on TRUE;

SELECT  e.emp_name , p.project_name
FROM  employeese e  CROSS JOIN  projects p;

-- part 3
-- INNER JOIN
SELECT e.emp_name, d.dept_name, d.location
FROM employeese e
         INNER JOIN departments d ON e.dept_id = d.dept_id;
-- I  have 4 rows .
--  Tom Brown not included  because your  dept_id  is  NULL

SELECT emp_name, dept_name, location
FROM employeese
         INNER JOIN departments USING (dept_id);
-- There arent duplicate dert_id colmns in the output

SELECT emp_name, dept_name, location
FROM employeese
         NATURAL INNER JOIN departments;

SELECT e.emp_name, d.dept_name, p.project_name
FROM employeese e
         INNER JOIN departments d ON e.dept_id = d.dept_id
         INNER JOIN projects p ON d.dept_id = p.dept_id;


-- part 4
-- left join
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS
                                dept_dept, d.dept_name
FROM employeese e
         LEFT JOIN departments d ON e.dept_id = d.dept_id;

-- Tom Brown displays Null  emp_dept and dept_name

SELECT emp_name, dept_name, location
FROM employeese
         LEFT JOIN departments USING (dept_id);

SELECT e.emp_name, e.dept_id
FROM employeese e
         LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;

SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
FROM departments d
         LEFT JOIN employeese e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY employee_count DESC;


-- part 5
-- RIGHT JOIN
SELECT e.emp_name, d.dept_name
FROM employeese e
         RIGHT JOIN departments d ON e.dept_id = d.dept_id;


SELECT e.emp_name, d.dept_name
FROM employeese e
         LEFT JOIN departments d ON e.dept_id = d.dept_id;

SELECT d.dept_name, d.location
FROM employeese e
         RIGHT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;


-- part 6
-- FULL JOIN
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS
                                dept_dept, d.dept_name
FROM employeese e
         FULL JOIN departments d ON e.dept_id = d.dept_id;

-- NULL LEFT IN marketing
-- Null right in TOM BROWN

SELECT d.dept_name, p.project_name, p.budget
FROM departments d
         FULL JOIN projects p ON d.dept_id = p.dept_id;

SELECT
    CASE
        WHEN e.emp_id IS NULL THEN 'Department without
employees'
        WHEN d.dept_id IS NULL THEN 'Employee without
department'
        ELSE 'Matched'
        END AS record_status,
    e.emp_name,
    d.dept_name
FROM employeese e
         FULL JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL OR d.dept_id IS NULL;

-- PART 7

SELECT e.emp_name, d.dept_name, e.salary
FROM employeese e
         LEFT JOIN departments d ON e.dept_id = d.dept_id AND
                                    d.location = 'Building A';


SELECT e.emp_name, d.dept_name, e.salary
FROM employeese e
         LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';

-- INNER JOIN with ON filter
SELECT e.emp_name, d.dept_name, e.salary
FROM employeese e
         INNER JOIN departments d ON e.dept_id = d.dept_id AND d.location = 'Building A';

-- INNER JOIN with WHERE filter
SELECT e.emp_name, d.dept_name, e.salary
FROM employeese e
         INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';

-- part 8
SELECT
    d.dept_name,
    e.emp_name,
    e.salary,
    p.project_name,
    p.budget
FROM departments d
         LEFT JOIN employeese e ON d.dept_id = e.dept_id
         LEFT JOIN projects p ON d.dept_id = p.dept_id
ORDER BY d.dept_name, e.emp_name;

ALTER TABLE employeese ADD COLUMN manager_id INT;

UPDATE employeese SET manager_id = 3 WHERE emp_id = 1;
UPDATE employeese SET manager_id = 3 WHERE emp_id = 2;
UPDATE employeese SET manager_id = NULL WHERE emp_id = 3;
UPDATE employeese SET manager_id = 3 WHERE emp_id = 4;
UPDATE employeese SET manager_id = 3 WHERE emp_id = 5;

SELECT
    e.emp_name AS employee,
    m.emp_name AS manager
FROM employeese e
         LEFT JOIN employeese m ON e.manager_id = m.emp_id;

SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM departments d
         INNER JOIN employeese e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 50000;

-- 1 left join  return only left table matching from the right . INNER jOIN return only mathcing rows from both
-- 2 CROSS JOIN  return all records from both table
-- 3 for outer joins: The filter in ON is applied before the join , where - after
-- 4  5 * 10 = 50
-- 5 Joins across all columns with the same name
-- 6 Unexpected results when adding columns with the same names
-- 7 SELECT * FROM B RIGHT JOIN A ON  B.id  = A.id
-- 8 When all records from both tables are needed, with missing matches identified


SELECT e.emp_name, d.dept_name
FROM employeese e
         LEFT JOIN departments d ON e.dept_id = d.dept_id
UNION
SELECT e.emp_name, d.dept_name
FROM employeese e
         RIGHT JOIN departments d ON e.dept_id = d.dept_id;

SELECT e.emp_name, d.dept_name
FROM employeese e
         INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IN (
    SELECT dept_id
    FROM projects
    GROUP BY dept_id
    HAVING COUNT(*) > 1
);

WITH RECURSIVE org_hierarchy AS (
    SELECT
        emp_id,
        emp_name,
        manager_id,
        1 as level
    FROM employeese
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        oh.level + 1
    FROM employeese e
             INNER JOIN org_hierarchy oh ON e.manager_id = oh.emp_id
)
SELECT * FROM org_hierarchy ORDER BY level, emp_name;

SELECT
    e1.emp_name AS employee1,
    e2.emp_name AS employee2,
    d.dept_name
FROM employeese e1
         INNER JOIN employeese e2 ON e1.dept_id = e2.dept_id AND e1.emp_id < e2.emp_id
         INNER JOIN departments d ON e1.dept_id = d.dept_id
ORDER BY d.dept_name, e1.emp_name;

