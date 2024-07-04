-- Subqueries in SELECT and WHERE Clauses

SELECT
    e.employee_id,
    e.name,
    e.salary,
    (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) AS avg_department_salary
FROM
    employees e
WHERE
    e.salary > (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id);

-- This query selects employees who earn more than the average salary in their department.