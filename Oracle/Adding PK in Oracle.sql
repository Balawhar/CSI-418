
-- Adding Primary key to a table in Oracle --

SELECT constraint_name 
FROM user_constraints 
WHERE table_name = 'QMS_CASE_ROLE' 
  AND constraint_type = 'P';

************************************************************

BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM user_constraints
        WHERE table_name = 'QMS_CASE_ROLE'
          AND constraint_name = 'PK_QMS_CASE_ROLE_ID'
    ) THEN
        EXECUTE IMMEDIATE 'ALTER TABLE QMSDBA.QMS_CASE_ROLE 
                           ADD CONSTRAINT PK_QMS_CASE_ROLE_ID PRIMARY KEY (CASE_ID)';
    END IF;
END;
/

************************************************************

DECLARE
    v_exists NUMBER;
BEGIN
    -- Check for the existence of the first unique constraint
    SELECT COUNT(*)
    INTO v_exists
    FROM user_constraints
    WHERE table_name = 'QMS_CASE_ROLE'
      AND constraint_name = 'PK_QMS_CASE_ROLE_CASE_ID';

    IF v_exists = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE QMSDBA.QMS_CASE_ROLE 
                           ADD CONSTRAINT PK_QMS_CASE_ROLE_CASE_ID UNIQUE (CASE_ID)';
    END IF;

    -- Check for the existence of the second unique constraint
    SELECT COUNT(*)
    INTO v_exists
    FROM user_constraints
    WHERE table_name = 'QMS_CASE_ROLE'
      AND constraint_name = 'PK_QMS_CASE_ROLE_ROLE_ID';

    IF v_exists = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE QMSDBA.QMS_CASE_ROLE 
                           ADD CONSTRAINT PK_QMS_CASE_ROLE_ROLE_ID UNIQUE (ROLE_ID)';
    END IF;
END;
/