-- Window Functions

SELECT
    employee_id,
    name,
    department_id,
    salary,
    AVG(salary) OVER (PARTITION BY department_id) AS avg_salary,
    RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM
    employees;

-- This query calculates the average salary and the rank of each employee’s salary within their department.