--- Tables ---
SELECT table_name FROM dba_tables;

SELECT table_name FROM all_tables ORDER BY table_name;
------
SELECT * FROM all_tables WHERE OWNER = 'OWNER_NAME' ORDER BY table_name;

SELECT * FROM all_tables where owner = 'SDEDBA' ORDER BY table_name;
------
SELECT table_name FROM user_tables;

--- Package ---
SELECT * FROM USER_PROCEDURES WHERE OBJECT_TYPE='PACKAGE' 

SELECT * FROM ALL_PROCEDURES WHERE OBJECT_TYPE='PACKAGE'

--- Object ---
SELECT owner, object_name FROM dba_objects WHERE object_type = 'TABLE';

--- View ---
SELECT view_name FROM all_views;
================================================================================================
-- If User is Locked
ALTER USER SUITEDBA IDENTIFIED BY SUITEDBA ACCOUNT UNLOCK;

================================================================================================
--- WITH ROWNUM select what you want and how many records ---
SELECT *
FROM (
    SELECT employee_id, first_name, last_name, ROWNUM AS row_number
    FROM employees
    ORDER BY employee_id
)
WHERE row_number <= 10;
----------------------

SELECT employee_id, first_name, last_name
FROM (
    SELECT employee_id, first_name, last_name, ROW_NUMBER() OVER (ORDER BY employee_id) AS row_number
    FROM employees
) AS numbered_employees
WHERE row_number <= 10;

================================================================================================
--- Remove Duplication by Partition ---
SELECT *
FROM (
    SELECT employee_id, first_name, last_name,
           ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY first_name) AS row_num
    FROM employees
)
WHERE row_num = 1;

================================================================================================
--- Sequence creation ---
CREATE SEQUENCE sequence_name
START WITH 1
INCREMENT BY 1
NOMAXVALUE;
INSERT INTO table_name (id, column1, column2)
VALUES (sequence_name.nextval, value1, value2);

================================================================================================
--- when retrieving a sequence to use it in a query ---
SELECT sequence_name.nextval FROM dual;

================================================================================================
--- JOIN ---
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

================================================================================================
--- IN ---
SELECT employee_id, first_name, last_name, department_id
FROM employees
WHERE department_id IN (SELECT department_id FROM departments WHERE department_name = 'IT');

================================================================================================
--- WHERE EXISTS ---
SELECT employee_id, first_name, last_name
FROM employees e
WHERE EXISTS (
    SELECT 1 FROM job_history j WHERE j.employee_id = e.employee_id
);

================================================================================================
-- Check for Referential Integrity
SELECT
    a.OWNER AS CHILD_TABLE_OWNER,
    a.TABLE_NAME AS CHILD_TABLE_NAME,
    a.CONSTRAINT_NAME AS CHILD_CONSTRAINT_NAME,
    b.OWNER AS PARENT_TABLE_OWNER,
    b.TABLE_NAME AS PARENT_TABLE_NAME,
    b.CONSTRAINT_NAME AS PARENT_CONSTRAINT_NAME
FROM
    DBA_CONSTRAINTS a
JOIN
    DBA_CONSTRAINTS b ON a.R_CONSTRAINT_NAME = b.CONSTRAINT_NAME
JOIN
    DBA_CONS_COLUMNS c ON a.CONSTRAINT_NAME = c.CONSTRAINT_NAME
WHERE
    a.CONSTRAINT_TYPE = 'R'          -- R stands for Referential Integrity (Foreign Key)
    AND b.TABLE_NAME = 'REF_COM_CITY'    -- Replace with your table name
    AND b.OWNER = 'SDEDBA';       -- Replace with your schema name


