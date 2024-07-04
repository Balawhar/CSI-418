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
====================================================================================================================
-- If User is Locked
-- SQL
ALTER USER SUITEDBA IDENTIFIED BY SUITEDBA ACCOUNT UNLOCK;
====================================================================================================================
-- Check if the table exists
SELECT table_name
FROM information_schema.tables
WHERE table_name = 'ref_com_commission';
=======================================================================================================================
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
====================================================================================================================
--- Remove Duplication by Partition ---
SELECT *
FROM (
    SELECT employee_id, first_name, last_name,
           ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY first_name) AS row_num
    FROM employees
)
WHERE row_num = 1;
====================================================================================================================
--- Sequence creation ---
CREATE SEQUENCE sequence_name
START WITH 1
INCREMENT BY 1
NOMAXVALUE;
INSERT INTO table_name (id, column1, column2)
VALUES (sequence_name.nextval, value1, value2);
====================================================================================================================
--- when retrieving a sequence to use it in a query ---
SELECT sequence_name.nextval FROM dual;
====================================================================================================================
--- JOIN ---
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;
====================================================================================================================
--- IN ---
SELECT employee_id, first_name, last_name, department_id
FROM employees
WHERE department_id IN (SELECT department_id FROM departments WHERE department_name = 'IT');
====================================================================================================================
--- WHERE EXISTS ---
SELECT employee_id, first_name, last_name
FROM employees e
WHERE EXISTS (
    SELECT 1 FROM job_history j WHERE j.employee_id = e.employee_id
);
====================================================================================================================
---  ---

