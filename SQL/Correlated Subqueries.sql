-- Correlated Subqueries

SELECT
    e.employee_id,
    e.name,
    e.salary,
    (SELECT AVG(salary) FROM employees e2 WHERE e2.department_id = e.department_id AND e2.salary > e.salary) AS avg_higher_salary
FROM
    employees e;

-- This query finds the average salary of employees within the same department who earn more than the current employee.