
-- ######################### Permissions in Postgres ########################## --

-- ============================================================================ --

-- Checking Permissions ---------------------------------------------------------- 

-- Roles ------------------------------------------------------------------------
SELECT *
FROM pg_roles

------------------------------------------------------------------------------------
-- Users ------------------------------------------------------------------------

SELECT *
FROM pg_user

------------------------------------------------------------------------------------
-- Database Owner ---------------------------------------------------------------
SELECT datname AS database_name, pg_get_userbyid(d.datdba) AS owner
FROM pg_database d
WHERE datname = 'V21';

------------------------------------------------------------------------------------
-- Schema Ownership -------------------------------------------------------------

SELECT schema_name, schema_owner
FROM information_schema.schemata
WHERE schema_name = 'your_schema';

------------------------------------------------------------------------------------
-- Owner of Table - Schema and Tablespace + -------------------------------------

SELECT *
FROM pg_tables
WHERE schemaname = 'qbedba' AND tablename = 'qbe_user_query';

------------------------------------------------------------------------------------
-- Table Ownership --------------------------------------------------------------
SELECT *
FROM pg_tables
WHERE schemaname = 'sdedba';

--

SELECT *
FROM pg_tables
WHERE schemaname IN ('sdedba','auddba','bmdba','findba','hrdba','impdba','invdba','isodba','locdba','mdmdba','qbedba','qmsdba','suitedba','techdba','usmdba','vlpdba','webdba','wfmdba','public','ssdx_eng','ssdx_tmp')
AND tableowner NOT IN ('pgdba');

------------------------------------------------------------------------------------
-- Check Owner of Procedure ------------------------------------------------------
SELECT n.nspname AS schema_name, p.proname AS procedure_name, pg_get_userbyid(p.proowner) AS owner
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'sdedba' AND p.proleakproof = false AND p.proisstrict = false AND p.prolang = (SELECT oid FROM pg_language WHERE lanname = 'plpgsql');

------------------------------------------------------------------------------------
-- Check Owner of Function -------------------------------------------------------

SELECT n.nspname AS schema_name, p.proname AS function_name, pg_get_userbyid(p.proowner) AS owner
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'sdedba' AND p.proname = '<function_name>';

------------------------------------------------------------------------------------
-- Check Trigger Owner ------------------------------------------------------------

SELECT t.tgname AS trigger_name,
       t.tgrelid::regclass AS table_name,
       pg_get_userbyid(c.relowner) AS owner
FROM pg_trigger t
JOIN pg_class c ON t.tgrelid = c.oid
WHERE t.tgname = 'trg_usm_menu';

------------------------------------------------------------------------------------
-- Check Sequence Owner ------------------------------------------------------------

SELECT relname AS sequence_name,
       pg_get_userbyid(relowner) AS owner
FROM pg_class
WHERE relkind = 'S'
  AND relname = 'seq_name';
  
------------------------------------------------------------------------------------
-- Check If User Can Create Temporary Tables ---------------------------------------

SELECT datname, rolname, has_database_privilege(rolname, datname, 'TEMP')
FROM pg_database, pg_roles
WHERE has_database_privilege(rolname, datname, 'TEMP') = true
-- AND rolname = 'pguser'
-- and datname = 'vdpsdb';

------------------------------------------------------------------------------------
-- Check Owner of Tablespace -------------------------------------------------------

SELECT spcname AS tablespace_name, 
       pg_catalog.pg_get_userbyid(spcowner) AS owner
FROM pg_tablespace;

------------------------------------------------------------------------------------
-- Check Owner of Extension -------------------------------------------------------

SELECT 
    extname AS extension_name,
    n.nspname AS schema_name,
    pg_catalog.pg_get_userbyid(e.extowner) AS owner
FROM 
    pg_catalog.pg_extension e
JOIN 
    pg_catalog.pg_namespace n ON e.extnamespace = n.oid;

==============================================================================
-- User Privileges on Column, Table, and Schema ---------------------------------

SELECT grantee, table_schema, table_name, column_name, privilege_type
FROM information_schema.column_privileges
WHERE table_schema = 'qbedba'
--  AND table_name = 'qbe_user_query'
--  AND column_name = 'query_name'
--  AND grantee = 'pgdba';

==============================================================================
-- Check ACL - Default privileges - "role=privileges/owner" --------------------

SELECT defaclrole AS role,
       defaclnamespace::regnamespace AS schema,
       defaclobjtype AS object_type,
       defaclacl AS acl
FROM pg_default_acl
WHERE defaclnamespace = 'suitedba'::regnamespace;

==============================================================================
-- ALL TABLE STATS * -------------------------------------------------------------

SELECT
    c.oid AS object_id,
    c.relname AS name,
    n.nspname AS schema,
    a.rolname AS owner,
    c.relkind AS type,
    CASE c.relkind
        WHEN 'r' THEN 'ordinary table'
        WHEN 'i' THEN 'index'
        WHEN 'S' THEN 'sequence'
        WHEN 't' THEN 'TOAST table'
        WHEN 'v' THEN 'view'
        WHEN 'm' THEN 'materialized view'
        WHEN 'c' THEN 'composite type'
        WHEN 'f' THEN 'foreign table'
        WHEN 'p' THEN 'partitioned table'
        WHEN 'I' THEN 'partitioned index'
        ELSE 'unknown'
    END AS type_description,
    c.relpersistence AS persistence,
    CASE c.relpersistence
        WHEN 'p' THEN 'permanent'
        WHEN 'u' THEN 'unlogged'
        WHEN 't' THEN 'temporary'
        ELSE 'unknown'
    END AS persistence_description,
    t.spcname AS tablespace,
    c.relpages AS pages,
    c.reltuples AS estimated_rows,
    c.relhasindex AS has_indexes,
    c.relchecks AS number_of_checks,
    c.relhasrules AS has_rules,
    c.relhastriggers AS has_triggers,
    c.relhassubclass AS has_subclasses
FROM
    pg_class c
    LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
    LEFT JOIN pg_authid a ON a.oid = c.relowner
    LEFT JOIN pg_tablespace t ON t.oid = c.reltablespace
WHERE
    c.relname = 'usm_role_definition';

==============================================================================
-- Check for Grants on Table / Column

SELECT * FROM information_schema.role_column_grants; -- Column grants 

SELECT * FROM information_schema.table_privileges; -- table privileges

SELECT * FROM information_schema.role_table_grants; -- table grants ( Insert/Update/Delete)

==============================================================================
-- Check Create and Usage Privilege for all Users ----------------------------

SELECT
    nspname AS schema_name,
    rolname AS role_name,
    has_schema_privilege(rolname, nspname, 'CREATE') AS create_privilege,
    has_schema_privilege(rolname, nspname, 'USAGE') AS usage_privilege
FROM
    pg_namespace n
JOIN
    pg_roles r
ON
    has_schema_privilege(rolname, n.oid, 'CREATE')
    AND has_schema_privilege(rolname, n.oid, 'USAGE')
-- WHERE rolname = 'pgdba';

==============================================================================
-- Check Tables Permissions

SELECT
    grantee,
    table_catalog,
    table_schema,
    table_name,
    privilege_type
FROM
    information_schema.table_privileges
WHERE
    table_schema = 'sdedba'
AND
	grantee = 'pgdba'
AND 
	table_name = 'ref_customer';

==============================================================================
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
    AND table_name = 'ref_customer'
	AND column_name = 'customer_id';
	
==============================================================================

-- Checking Database Permissions
SELECT
	datname,
    pg_catalog.pg_get_userbyid(datdba) AS owner,
    has_database_privilege('postgres', datname, 'CONNECT') AS can_connect,
    has_database_privilege('postgres', datname, 'CREATE') AS can_create,
    has_database_privilege('postgres', datname, 'TEMPORARY') AS can_create_temp
FROM
    pg_catalog.pg_database
WHERE
    datname = 'vcisdb';

==============================================================================

-- Checking Role Privileges
SELECT
    rolname,
    rolsuper,
    rolinherit,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin,
    rolreplication,
    rolbypassrls
FROM
    pg_catalog.pg_roles
WHERE
    rolname = 'postgres';

==============================================================================
-- Check EXECUTE Permission for a user
SELECT *
   FROM information_schema.routine_privileges
      WHERE specific_name = function_name
        AND grantee = pgdba
        AND privilege_type = 'EXECUTE'

==============================================================================
