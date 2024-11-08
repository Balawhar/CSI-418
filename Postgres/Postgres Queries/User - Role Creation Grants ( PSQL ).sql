
-- ########################  User / Role Creation & Grants ######################## --

=======================================================================================

-- Create Database --------------------------------------------------------------------
CREATE DATABASE mtbdb
    WITH
    OWNER = pgdba
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = vcis_data
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- Terminate All Connections on a Database --------------------------------------------
SELECT
  pg_terminate_backend(pid)
FROM
  pg_stat_activity
WHERE
  datname = 'testdb'
  AND pid <> pg_backend_pid();

-- Create schema with owner
CREATE SCHEMA sdedba AUTHORIZATION pgdba;

-- User/Role Creation
CREATE ROLE pgdba WITH LOGIN PASSWORD '12345678';

-- No Inherit 
ALTER ROLE pgdba NOINHERIT;

=======================================================================================

-- Predefined Roles

GRANT pg_read_all_data TO pgdba;
/*
Read all data (tables, views, sequences), as if having SELECT rights on those objects, and USAGE rights on all schemas, even without having it explicitly. This role does not have the role attribute BYPASSRLS set. If RLS is being used, an administrator may wish to set BYPASSRLS on roles which this role is GRANTed to.
*/

GRANT pg_write_all_data TO pgdba;
/*
Write all data (tables, views, sequences), as if having INSERT,
UPDATE, and DELETE rights on those objects, and USAGE
rights on all schemas, even without having it explicitly. This role
does not have the role attribute BYPASSRLS set. If RLS is being used, an administrator may wish to set BYPASSRLS on roles which this role is GRANTed to.
*/


----------------------------------------------------------------------------------------

GRANT pg_read_all_settings TO pgdba;
/*
Read all configuration variables, even those normally visible only
to superusers.
*/

GRANT pg_read_all_stats TO pgdba;
/*
Read all pg_stat_* views and use various statistics related extensions, even those normally visible only to superusers.
*/

GRANT pg_stat_scan_tables TO pgdba;
/* 
Execute monitoring functions that may take ACCESS SHARE
locks on tables, potentially for a long time.
*/

GRANT pg_monitor TO pgdba;
/* 
Read/execute various monitoring views and functions. This role
is a member of pg_read_all_settings, pg_read_all_stats and pg_stat_scan_tables.
*/

GRANT pg_database_owner TO pgdba;
/*
None. Membership consists, implicitly, of the current database
owner.
*/

GRANT pg_signal_backend TO pgdba;
/* 
Signal another backend to cancel a query or terminate its session.
*/

GRANT pg_read_server_files TO pgdba;
/*
Allow reading files from any location the database can access on
the server with COPY and other file-access functions.
*/

GRANT pg_write_server_files TO pgdba;
/* 
Allow writing to files in any location the database can access on
the server with COPY and other file-access functions.
*/

GRANT pg_execute_server_program TO pgdba;
/* 
Allow executing programs on the database server as the user the
database runs as with COPY and other functions which allow executing a server-side program.
*/

GRANT pg_checkpoint TO pgdba;
/* 
Allow executing the CHECKPOINT command.
*/

GRANT pg_use_reserved_connections TO pgdba;
/*
Allow use of connection slots reserved via reserved_connections.
*/

GRANT pg_create_subscription TO pgdba;
/* 
Allow users with CREATE permission on the database to issue
CREATE SUBSCRIPTION
*/

=======================================================================================
-- Usage / Select / Execute / Grants --------------------------------------------------

-- Grant Connect
GRANT CONNECT ON DATABASE testdb TO pgdba;

-- Grant Usage to Schema
GRANT USAGE ON SCHEMA sdedba TO pgdba;

-- Grant SELECT, INSERT, UPDATE, DELETE ONLY
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sdedba TO pgdba;

-- + SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, and TRIGGER.
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA sdedba TO pgdba;

-- Grant All on Schema
GRANT ALL PRIVILEGES ON SCHEMA sdedba TO pgdba;

-- Grant Execute only for FUNCTIONS
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA sdedba TO pgdba;
-- Grant All for FUNCTIONS
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA sdedba TO pgdba;

-- Grant Execute only for PROCEDURES
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA sdedba TO pgdba;
-- Grant All for PROCEDURES
GRANT ALL PRIVILEGES ON ALL PROCEDURES IN SCHEMA sdedba TO pgdba;

-- Grant on Sequences
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA sdedba TO pgdba;

-- TABLE Grants ------------------------------------------------
-- Grant SELECT access on the specific TABLE
GRANT SELECT ON TABLE sdedba.my_table TO pgdba;
-- Grant All on Table
GRANT ALL PRIVILEGES ON TABLE your_schema.your_table TO your_username;

-- COLUMN Grants ------------------------------------------------
-- Grant SELECT on columns column1 and column2
GRANT SELECT (column1, column2) ON TABLE sdedba.my_table TO pgdba;
-- Grant INSERT on columns column1 and column2
GRANT INSERT (column1, column2) ON TABLE sdedba.my_table TO pgdba;
-- Grant UPDATE on columns column1 and column2
GRANT UPDATE (column1, column2) ON TABLE sdedba.my_table TO pgdba;

=======================================================================================
-- Create Grants --------------------------------------------------------------

-- Grant Create on Schema
GRANT CREATE ON SCHEMA sdedba TO pgdba;

-- Grant on Tablespace
GRANT ALL ON TABLESPACE VCIS_INDEX TO pgdba;

-- Grant on Trigger
GRANT TRIGGER ON TABLE usmdba.usm_menu TO pgdba;

-- Grant Create on Tablespace
GRANT CREATE ON TABLESPACE VCIS_INDEX TO pgdba;

-- Grant Create DB
GRANT CREATEDB TO pgdba;

=======================================================================================
-- Alter Ownership --------------------------------------------------------------

-- Change owner of DB
ALTER DATABASE testdb OWNER TO pgdba;

-- Change owner of Schema
ALTER SCHEMA your_schema OWNER TO pgdba;

-- Change Owner of Table
ALTER TABLE your_schema.your_table OWNER TO pgdba;

-- Change Owner of Procedure or Function
ALTER PROCEDURE schema_name.procedure_name OWNER TO pgdba;
--
ALTER FUNCTION schema_name.procedure_name OWNER TO pgdba;

-- Change Owner of Sequence
ALTER SEQUENCE my_schema.my_sequence OWNER TO new_owner;

-- Change Owner of Tablespace
ALTER TABLESPACE VCIS_DATA OWNER TO pgdba;
ALTER TABLESPACE VCIS_INDEX OWNER TO pgdba;

-- Change owner of extension
ALTER EXTENSION extension_name OWNER TO new_owner;

-- Grant RLS
ALTER ROLE pgdba WITH BYPASSRLS;

=======================================================================================
-- Revokes --------------------------------------------------------------

-- Database Revokes
REVOKE ALL ON DATABASE testdb FROM pgdba;
REVOKE ALL PRIVILEGES ON DATABASE testdb FROM pgdba;
REVOKE TEMPORARY ON DATABASE testdb FROM pgdba; -- Revoke Creating Temporary tables

-- Schema Revokes
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA sdedba FROM pgdba;
REVOKE CREATE ON SCHEMA sdedba FROM pgdba;
REVOKE USAGE ON SCHEMA sdedba FROM pgdba;
REVOKE SELECT ON ALL TABLES IN SCHEMA sdedba FROM pgdba;

-- Table Revokes
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA sdedba FROM pgdba;
REVOKE SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sdedba FROM pgdba;
REVOKE ALL PRIVILEGES ON TABLE sdedba.table_name FROM pgdba;
REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLE sdedba.table_name FROM pgdba;
REVOKE SELECT, INSERT ON sdedba.table_name FROM pgdba;

-- Column Revokes
REVOKE SELECT (column1, column2) ON TABLE sdedba.my_table FROM pgdba;
REVOKE INSERT (column1, column2) ON TABLE sdedba.my_table FROM pgdba;
REVOKE UPDATE (column1, column2) ON TABLE sdedba.my_table FROM pgdba;

-- Function - Procedure Revokes
--
-- Sequence Revokes
--
=======================================================================================
-- Alter Default Privileges For Newly Created Tables & Objects  ---------------------------

ALTER DEFAULT PRIVILEGES IN SCHEMA sdedba GRANT SELECT ON TABLES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA sdedba GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA sdedba GRANT ALL PRIVILEGES ON TABLES TO pgdba;
--
ALTER DEFAULT PRIVILEGES IN SCHEMA sdedba GRANT SELECT, UPDATE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA sdedba GRANT ALL PRIVILEGES ON SEQUENCES TO pgdba;
--
ALTER DEFAULT PRIVILEGES IN SCHEMA sdedba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA sdedba GRANT ALL PRIVILEGES ON FUNCTIONS TO pgdba;
--
ALTER DEFAULT PRIVILEGES IN SCHEMA sdedba GRANT EXECUTE ON PROCEDURES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA sdedba GRANT ALL PRIVILEGES ON PROCEDURES TO pgdba;
--------------------------------------------------------------------------------------

-- Allows the role to use the specified user-defined types
ALTER DEFAULT PRIVILEGES IN SCHEMA sdedba GRANT USAGE ON TYPES TO pgdba;

-- Allows the role to use the specified domains
ALTER DEFAULT PRIVILEGES IN SCHEMA sdedba GRANT USAGE ON DOMAINS TO pgdba;

-- Classic Syntax
ALTER DEFAULT PRIVILEGES /* FOR ROLE role_name */ IN SCHEMA schema_name GRANT privilege_list ON object_type TO target_role;
-- Any new table created by the postgres role in the sdedba schema will automatically grant SELECT, INSERT, UPDATE, and DELETE privileges to the pgdba role
ALTER DEFAULT PRIVILEGES /* FOR ROLE postgres */ IN SCHEMA sdedba GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO pgdba;

=======================================================================================

-- Change Role & User  --------------------------------------------------------------

-- SET SESSION AUTHORIZATION 'pgdba';
-- Select session_user;
-- RESET SESSION AUTHORIZATION;  ( Revert to Original )
--------------------------
-- SET ROLE pguser;
-- Select current_user;
-- RESET ROLE;  ( Revert to Original )

--------------------------------------------------------------------------------------
-- Drop User & Dependants

REASSIGN OWNED BY testuser TO pgdba;
DROP OWNED BY testuser;
DROP USER testuser;

=======================================================================================
-- Check for Grants on Table / Column

SELECT * FROM information_schema.role_column_grants; -- Column grants 

SELECT * FROM information_schema.table_privileges; -- table privileges

SELECT * FROM information_schema.role_table_grants; -- table grants ( Insert/Update/Delete)

=======================================================================================

-- Check for grants on a schema / table *

SELECT
    table_schema,
    table_name,
    column_name,
    privilege_type
FROM
    information_schema.column_privileges
WHERE
    grantee = 'pgdba'
    AND table_schema = 'sdedba'
    AND table_name = 'my_table';
	
=======================================================================================

-- Check for TABLESPACE for every table that is null / not null
		  SELECT n.nspname AS schemaname, 
       c.relname AS tablename,
       COALESCE(t.spcname, (SELECT spcname 
                            FROM pg_tablespace 
                            WHERE oid = (SELECT dattablespace 
                                         FROM pg_database 
                                         WHERE datname = current_database())
                           )) AS tablespace
FROM pg_tables p
JOIN pg_class c ON p.tablename = c.relname
JOIN pg_namespace n ON c.relnamespace = n.oid
LEFT JOIN pg_tablespace t ON c.reltablespace = t.oid
-- WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
  AND COALESCE(t.spcname, (SELECT spcname 
                           FROM pg_tablespace 
                           WHERE oid = (SELECT dattablespace 
                                        FROM pg_database 
                                        WHERE datname = current_database())
                          )) IS NOT NULL;
						  
--------------------------------------------------------------------------------------						  
						  
-- Check for TABLESPACE for every table with their DEFAULT
SELECT 
    n.nspname AS schemaname, 
    c.relname AS tablename,
    CASE 
        WHEN c.reltablespace = 0 THEN 'DEFAULT (' || d.spcname || ')'  -- Default tablespace
        ELSE t.spcname  -- Specific tablespace set for the table
    END AS tablespace
FROM pg_class c
JOIN pg_namespace n ON c.relnamespace = n.oid
LEFT JOIN pg_tablespace t ON c.reltablespace = t.oid
LEFT JOIN pg_tablespace d ON d.oid = (SELECT dattablespace FROM pg_database WHERE datname = current_database())
WHERE c.relkind = 'r'  -- Only tables
AND n.nspname NOT IN ('pg_catalog', 'information_schema')
ORDER BY schemaname, tablename;	

=======================================================================================
-- All schemas

SELECT schema_name 
FROM information_schema.schemata
WHERE schema_name NOT IN ('information_schema', 'pg_catalog')
--
-- pg_toast - topology 
auddba,bmdba,findba,hrdba,impdba,invdba,isodba,locdba,mdmdba,qbedba,qmsdba,sdedba,suitedba,techdba,usmdba,vlpdba,webdba,wfmdba,public,cdsdba,ssdx_eng,ssdx_tmp

=======================================================================================
-- Create / Import Table with Grants / Privileges
 
 CREATE TABLE "SUITEDBA"."CFG_OBJECT_SESSION_BSNGP" 
   (	"SESSION_ID" NUMBER(10,0), 
	"BSN_GROUP_ID" NUMBER(10,0), 
	"CREATION_DATE" DATE DEFAULT SYSDATE, 
	"CREATED_BY" NUMBER(10,0), 
	"UPDATE_DATE" DATE, 
	"UPDATED_BY" NUMBER(10,0)
   )  
  TABLESPACE "vcis_data" ;
 
 GRANT REFERENCES ON "SUITEDBA"."CFG_OBJECT_SESSION_BSNGP" TO "pgdba";
GRANT UPDATE ON "SUITEDBA"."CFG_OBJECT_SESSION_BSNGP" TO "pgdba";
GRANT SELECT ON "SUITEDBA"."CFG_OBJECT_SESSION_BSNGP" TO "pgdba";
GRANT INSERT ON "SUITEDBA"."CFG_OBJECT_SESSION_BSNGP" TO "pgdba";
GRANT DELETE ON "SUITEDBA"."CFG_OBJECT_SESSION_BSNGP" TO "pgdba";

GRANT SELECT ON "SUITEDBA"."CFG_OBJECT_SESSION_BSNGP" TO "pguser";

------------------------------------------------------------------------
-- Create Tablespace

CREATE TABLESPACE mtb_data
  LOCATION '/u01/pgsql/mtb_data';

ALTER TABLESPACE mtb_data
  OWNER TO pgdba;

GRANT CREATE ON TABLESPACE mtb_data TO pgdba;

GRANT CREATE ON TABLESPACE mtb_data TO pguser;

=======================================================================================

-- GRANT CREATE SCRIPTS ---------------------------------------------------------------

=======================================================================================
-- Grant CREATE Objects in every SCHEMA

DO
$$
DECLARE
    schema_record RECORD;
BEGIN
    -- Loop through all schemas excluding system schemas
    FOR schema_record IN
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    LOOP
        -- Grant CREATE privilege on each schema to pgdba
        EXECUTE format('GRANT CREATE ON SCHEMA %I TO pgdba;', schema_record.schema_name);
    END LOOP;
END
$$;

=======================================================================================

-- CHANGE OWNER SCRIPTS ---------------------------------------------------------------

=======================================================================================
-- Changing OWNER of All SCHEMAS From Postgres To Pgdba on All Database ( Script ) ----
DO
$$
DECLARE
    schema_record RECORD;
BEGIN
    -- Loop through all schemas owned by postgres
    FOR schema_record IN
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_owner = 'Postgres'
    LOOP
        -- Change the owner of each schema to pgdba
        EXECUTE format('ALTER SCHEMA %I OWNER TO pgdba;', schema_record.schema_name);
    END LOOP;
END
$$;

----------------------------------------------------------------------------------------
-- Changing OWNER of All Tables From Postgres To Pgdba on All Database ( Script ) ------

DO $$ 
DECLARE
    table_rec RECORD;
BEGIN
    -- Loop through all tables in all schemas owned by 'postgres'
    FOR table_rec IN
        SELECT schemaname, tablename
        FROM pg_tables
        WHERE schemaname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
          AND tableowner = 'postgres'
    LOOP
        -- Construct and execute the ALTER TABLE command
        BEGIN
            EXECUTE 'ALTER TABLE ' || quote_ident(table_rec.schemaname) || '.' || quote_ident(table_rec.tablename) || ' OWNER TO pgdba';
        EXCEPTION
            WHEN others THEN
                RAISE NOTICE 'Failed to change ownership of %.%: %', table_rec.schemaname, table_rec.tablename, SQLERRM;
        END;
    END LOOP;
END $$;

----------------------------------------------------------------------------------------
-- Change OWNER of PROCEDURES ( Script ) ----------------------------------------------- 

DO $$ 
DECLARE
    proc_rec RECORD;
BEGIN
    -- Loop through all procedures in all schemas owned by 'postgres'
    FOR proc_rec IN
        SELECT n.nspname AS schemaname, p.proname AS procname, pg_get_function_identity_arguments(p.oid) AS arguments
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        JOIN pg_authid a ON p.proowner = a.oid
        WHERE n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
          AND a.rolname = 'postgres'
          AND p.prokind = 'p'  -- Ensure we're selecting procedures
    LOOP
        -- Construct and execute the ALTER PROCEDURE command
        BEGIN
            EXECUTE 'ALTER PROCEDURE ' || quote_ident(proc_rec.schemaname) || '.' || quote_ident(proc_rec.procname) || '(' || proc_rec.arguments || ') OWNER TO pgdba';
        EXCEPTION
            WHEN others THEN
                RAISE NOTICE 'Failed to change ownership of %.%(%): %', proc_rec.schemaname, proc_rec.procname, proc_rec.arguments, SQLERRM;
        END;
    END LOOP;
END $$;

------------------------------------------------------------------------------------------
-- Change OWNER of FUNCTIONS ( Script ) -------------------------------------------------- 

DO $$ 
DECLARE
    proc_rec RECORD;
    arg_list TEXT;
BEGIN
    -- Loop through all procedures in all schemas owned by 'postgres'
    FOR proc_rec IN
        SELECT n.nspname AS schemaname, p.proname AS procname, oidvectortypes(p.proargtypes) AS arguments
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        JOIN pg_authid a ON p.proowner = a.oid
        WHERE n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
          AND a.rolname = 'postgres'
    LOOP
        -- Construct the argument list
        arg_list := proc_rec.arguments;
        -- Construct and execute the ALTER FUNCTION command
        BEGIN
            EXECUTE 'ALTER FUNCTION ' || quote_ident(proc_rec.schemaname) || '.' || quote_ident(proc_rec.procname) || '(' || arg_list || ') OWNER TO pgdba';
        EXCEPTION
            WHEN others THEN
                RAISE NOTICE 'Failed to change ownership of %.%(%): %', proc_rec.schemaname, proc_rec.procname, arg_list, SQLERRM;
        END;
    END LOOP;
END $$;

------------------------------------------------------------------------------------------
-- Change OWNER of SEQUENCES Owner ( Script ) --------------------------------------------

DO
$$
DECLARE
    schema_name TEXT;
    seq_record RECORD;
BEGIN
    -- List of schemas excluding system schemas
    FOR schema_name IN 
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    LOOP
        -- Iterate over all sequences in the current schema owned by postgres
        FOR seq_record IN 
            SELECT sequence_schema, sequence_name
            FROM information_schema.sequences
            WHERE sequence_schema = schema_name AND sequence_owner = 'postgres'
        LOOP
            -- Change the owner of each sequence
            EXECUTE format('ALTER SEQUENCE %I.%I OWNER TO pgdba;', seq_record.sequence_schema, seq_record.sequence_name);
        END LOOP;
    END LOOP;
END
$$;

------------------------------------------------------------------------------------------
-- Change OWNER of TRIGGERS ( Script ) ---------------------------------------------------

DO $$ 
DECLARE
    trigger_rec RECORD;
BEGIN
    -- Loop through all triggers in all schemas owned by 'postgres'
    FOR trigger_rec IN
        SELECT n.nspname AS schemaname, 
               t.tgname AS triggername, 
               pg_get_triggerdef(t.oid) AS triggerdef
        FROM pg_trigger t
        JOIN pg_class c ON t.tgrelid = c.oid
        JOIN pg_namespace n ON c.relnamespace = n.oid
        JOIN pg_authid a ON c.relowner = a.oid  -- Use relowner to check table owner
        WHERE n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
          AND a.rolname = 'postgres'
    LOOP
        -- Construct and execute the ALTER TRIGGER command
        BEGIN
            EXECUTE 'ALTER TRIGGER ' || quote_ident(trigger_rec.triggername) || ' ON ' || quote_ident(trigger_rec.schemaname) || '.' || quote_ident(trigger_rec.triggerdef) || ' OWNER TO pgdba';
        EXCEPTION
            WHEN others THEN
                RAISE NOTICE 'Failed to change ownership of %.%: %', trigger_rec.schemaname, trigger_rec.triggername, SQLERRM;
        END;
    END LOOP;
END $$;

------------------------------------------------------------------------------------------
-- Change OWNER of EXTENSIONS ( Script ) -------------------------------------------------

DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT extname AS extension_name
        FROM pg_catalog.pg_extension
        WHERE pg_catalog.pg_get_userbyid(extowner) = 'postgres'
    LOOP
        RAISE NOTICE 'Changing owner of extension % to pgdba', rec.extension_name;
        EXECUTE format('ALTER EXTENSION %I OWNER TO pgdba;', rec.extension_name);
    END LOOP;
END $$;

------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Change TABLESPACE of TABLES and INDEXES ( Script ) ------------------------------------

-- Define the target tablespaces

DO $$
DECLARE
    table_tablespace TEXT := 'vdfs_data';
    index_tablespace TEXT := 'vdfs_index';
    rec RECORD;
BEGIN
    -- Change the tablespace of all tables
    FOR rec IN
        SELECT n.nspname AS schemaname, 
			   c.relname AS tablename,
		       t.spcname AS tablespace
		FROM pg_tables p
		JOIN pg_class c ON p.tablename = c.relname
		JOIN pg_namespace n ON c.relnamespace = n.oid
		LEFT JOIN pg_tablespace t ON c.reltablespace = t.oid
		WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')-- Exclude system schemas
    LOOP
        EXECUTE format('ALTER TABLE %I.%I SET TABLESPACE %I',
                        rec.schemaname, rec.tablename, table_tablespace);
    END LOOP;
    
    -- Change the tablespace of all indexes
    FOR rec IN
	SELECT i.schemaname,
		   i.indexname,
		   t.spcname AS tablespace
	FROM pg_indexes i
	JOIN pg_class c ON i.indexname = c.relname
	LEFT JOIN pg_tablespace t ON c.reltablespace = t.oid
	WHERE i.schemaname NOT IN ('pg_catalog', 'information_schema') -- Exclude system schemas
    LOOP
        EXECUTE format('ALTER INDEX %I.%I SET TABLESPACE %I',
                        rec.schemaname, rec.indexname, index_tablespace);
    END LOOP;
END $$;

-- Default Tablespace + Alter
SELECT datname, pg_tablespace.spcname 
FROM pg_database 
JOIN pg_tablespace ON pg_database.dattablespace = pg_tablespace.oid
WHERE datname = 'mydatabase';
--
ALTER DATABASE mydatabase SET TABLESPACE mytablespace;

=======================================================================================

-- SCRIPTS ----------------------------------------------------------------------------

=======================================================================================
-- Grant USAGE Privileges on SCHEMAS --------------------------------------------------
 
DO
$$
DECLARE
    schema_record RECORD;
BEGIN
    -- Loop through all schemas
    FOR schema_record IN
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    LOOP
        -- Grant USAGE on each schema to pgdba
        EXECUTE format('GRANT USAGE ON SCHEMA %I TO pgdba;', schema_record.schema_name);
    END LOOP;
END
$$;

----------------------------------------------------------------------------------------
-- Grant All PRIVILEGES on Tables in Schema --------------------------------------------
-- SELECT / INSERT / UPDATE / DELETE / TRUNCATE / REFERENCES / TRIGGER
DO
$$
DECLARE
    schema_record RECORD;
    table_record RECORD;
BEGIN
    -- Loop through all schemas excluding system schemas
    FOR schema_record IN
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    LOOP
        -- Loop through all tables in the current schema
        FOR table_record IN
            SELECT table_name
            FROM information_schema.tables
            WHERE table_schema = schema_record.schema_name
        LOOP
            -- Grant ALL PRIVILEGES on each table to pgdba
            EXECUTE format('GRANT ALL PRIVILEGES ON TABLE %I.%I TO pgdba;', schema_record.schema_name, table_record.table_name);
        END LOOP;
    END LOOP;
END
$$;






















-- Scripts for these

/*
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sdedba TO pgdba;

-- + SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, and TRIGGER.
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA sdedba TO pgdba;

-- Grant All on Schema
GRANT ALL PRIVILEGES ON SCHEMA sdedba TO pgdba;

-- Grant Execute only for FUNCTIONS
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA sdedba TO pgdba;
-- Grant All for FUNCTIONS
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA sdedba TO pgdba;

-- Grant Execute only for PROCEDURES
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA sdedba TO pgdba;
-- Grant All for PROCEDURES
GRANT ALL PRIVILEGES ON ALL PROCEDURES IN SCHEMA sdedba TO pgdba;

-- Grant on Sequences
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA sdedba TO pgdba;

*/
























=======================================================================================

-- NEWLY CREATED OBJECTS SCRIPTS ------------------------------------------------------

=======================================================================================
-- Grants on all NEWLY created TABLES in each SCHEMA ----------------------------------
-- SELECT / INSERT / UPDATE / DELETE / TRUNCATE / REFERENCES / TRIGGER
DO
$$
DECLARE
    schema_record RECORD;
BEGIN
    -- Loop through all schemas excluding system schemas
    FOR schema_record IN
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    LOOP
        -- Set default privileges to grant SELECT on tables to pgdba
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT SELECT ON TABLES TO pgdba;', schema_record.schema_name);
        
        -- Set default privileges to grant INSERT on tables to pgdba
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT INSERT ON TABLES TO pgdba;', schema_record.schema_name);
        
        -- Set default privileges to grant UPDATE on tables to pgdba
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT UPDATE ON TABLES TO pgdba;', schema_record.schema_name);
        
        -- Set default privileges to grant DELETE on tables to pgdba
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT DELETE ON TABLES TO pgdba;', schema_record.schema_name);
        
        -- Set default privileges to grant TRUNCATE on tables to pgdba
        -- EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT TRUNCATE ON TABLES TO pgdba;', schema_record.schema_name);
        
        -- Set default privileges to grant REFERENCES on tables to pgdba
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT REFERENCES ON TABLES TO pgdba;', schema_record.schema_name);
        
        -- Set default privileges to grant TRIGGER on tables to pgdba
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT TRIGGER ON TABLES TO pgdba;', schema_record.schema_name);
    END LOOP;
END
$$;

----------------------------------------------------------------------------------------
-- Grants on all NEWLY created SEQUENCES / FUNCTIONS / PROCEDURES / TYPES / DOMAINS ----

DO $$
DECLARE
    schema_name text;
BEGIN
    FOR schema_name IN
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_name NOT IN ('pg_catalog', 'information_schema')
    LOOP
        EXECUTE format('
            ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT SELECT, UPDATE ON SEQUENCES TO pgdba;
            ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT ALL PRIVILEGES ON SEQUENCES TO pgdba;

            ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT EXECUTE ON FUNCTIONS TO pgdba;
            ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT ALL PRIVILEGES ON FUNCTIONS TO pgdba;

            ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT EXECUTE ON PROCEDURES TO pgdba;
            ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT ALL PRIVILEGES ON PROCEDURES TO pgdba;

            ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT USAGE ON TYPES TO pgdba;
            ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT USAGE ON DOMAINS TO pgdba;
            ',
            schema_name, schema_name, schema_name, schema_name, schema_name, schema_name, schema_name, schema_name, schema_name, schema_name
        );
    END LOOP;
END $$;



=======================================================================================

-- REVOKE SCRIPTS ---------------------------------------------------------------------

=======================================================================================

-- Revoke All Privileges on All Schemas -----------------------------------------------

DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    LOOP
        EXECUTE 'REVOKE ALL PRIVILEGES ON SCHEMA ' || quote_ident(r.schema_name) || ' FROM pguser';
    END LOOP;
END $$;

----------------------------------------------------------------------------------------
-- Revoke All Privileges on All Tables -------------------------------------------------

DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT table_schema, table_name
        FROM information_schema.tables
        WHERE table_schema NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    LOOP
        EXECUTE 'REVOKE ALL PRIVILEGES ON TABLE ' || quote_ident(r.table_schema) || '.' || quote_ident(r.table_name) || ' FROM pguser';
    END LOOP;
END $$;

----------------------------------------------------------------------------------------
-- Revoke All Privileges on Functions --------------------------------------------------

DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT routine_schema, routine_name
        FROM information_schema.routines
        WHERE routine_schema NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    LOOP
        EXECUTE 'REVOKE ALL PRIVILEGES ON FUNCTION ' || quote_ident(r.routine_schema) || '.' || quote_ident(r.routine_name) || ' FROM pguser';
    END LOOP;
END $$;

-----------------------------------------------------------------------------------------
-- Revoke All Privileges on All Sequences -----------------------------------------------

DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT sequence_schema, sequence_name
        FROM information_schema.sequences
        WHERE sequence_schema NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    LOOP
        EXECUTE 'REVOKE ALL PRIVILEGES ON SEQUENCE ' || quote_ident(r.sequence_schema) || '.' || quote_ident(r.sequence_name) || ' FROM pguser';
    END LOOP;
END $$;












































DO $$
DECLARE
    r RECORD;
    s RECORD;
BEGIN
    -- Loop through all schemas
    FOR r IN (SELECT nspname FROM pg_namespace WHERE nspname NOT IN ('pg_catalog', 'information_schema')) LOOP
        -- Loop through all sequences in the current schema
        FOR s IN (SELECT sequencename FROM pg_sequences WHERE schemaname = r.nspname) LOOP
            -- Execute the GRANT statement
            EXECUTE 'GRANT ALL PRIVILEGES ON SEQUENCE ' || quote_ident(r.nspname) || '.' || quote_ident(s.sequencename) || ' TO pgdba';
        END LOOP;
    END LOOP;
END $$;





-- Grant on All Sequences in Schema
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA auddba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA bmdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA findba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA hrdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA impdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA invdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA isodba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA locdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA mdmdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA qbedba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA qmsdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA sdedba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA suitedba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA techdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA usmdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA vlpdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA webdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA wfmdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA ssdx_eng TO pgdba;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA ssdx_tmp TO pgdba;

-- Grant USAGE on all newly created sequences in each schema
ALTER DEFAULT PRIVILEGES IN SCHEMA auddba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA bmdba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA findba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA hrdba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA impdba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA invdba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA isodba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA locdba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA mdmdba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA qbedba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA qmsdba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA sdedba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA suitedba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA techdba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA usmdba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA vlpdba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA webdba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA wfmdba GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA ssdx_eng GRANT USAGE ON SEQUENCES TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA ssdx_tmp GRANT USAGE ON SEQUENCES TO pgdba;

---------------------------------------------------------------------------

-- in All Functions in Schema
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA auddba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA bmdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA findba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA hrdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA impdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA invdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA isodba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA locdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA mdmdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA qbedba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA qmsdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA sdedba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA suitedba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA techdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA usmdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA vlpdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA webdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA wfmdba TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA ssdx_eng TO pgdba;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA ssdx_tmp TO pgdba;

-- Grant EXECUTE on all newly created functions and procedures in each schema
ALTER DEFAULT PRIVILEGES IN SCHEMA auddba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA bmdba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA findba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA hrdba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA impdba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA invdba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA isodba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA locdba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA mdmdba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA qbedba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA qmsdba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA sdedba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA suitedba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA techdba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA usmdba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA vlpdba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA webdba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA wfmdba GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA ssdx_eng GRANT EXECUTE ON FUNCTIONS TO pgdba;
ALTER DEFAULT PRIVILEGES IN SCHEMA ssdx_tmp GRANT EXECUTE ON FUNCTIONS TO pgdba;