-- ##### Permissions in Postgres ##### --

-- Checking Schema Permissions
SELECT
    nspname AS schema_name,
    pg_catalog.pg_get_userbyid(nspowner) AS owner,
    has_schema_privilege('postgres', nspname, 'CREATE') AS can_create,
    has_schema_privilege('postgres', nspname, 'USAGE') AS can_use
FROM
    pg_catalog.pg_namespace
WHERE
    nspname = 'ssdx_tmp';

--

-- Check all schema permissions
SELECT
    nspname AS schema_name,
    pg_catalog.pg_get_userbyid(nspowner) AS owner,
    has_schema_privilege('postgres', nspname, 'CREATE') AS can_create,
    has_schema_privilege('postgres', nspname, 'USAGE') AS can_use
FROM
    pg_catalog.pg_namespace;


==============================================================================

-- Checking Tables Permissions
SELECT
    grantee,
    table_catalog,
    table_schema,
    table_name,
    privilege_type
FROM
    information_schema.table_privileges
WHERE
    table_schema = 'ssdx_tmp';

--

-- Check all table permissions in all schemas
SELECT
    grantee,
    table_catalog,
    table_schema,
    table_name,
    privilege_type
FROM
    information_schema.table_privileges;


==============================================================================

-- Checking Database Permissions
    datname,
    pg_catalog.pg_get_userbyid(datdba) AS owner,
    has_database_privilege('postgres', datname, 'CONNECT') AS can_connect,
    has_database_privilege('postgres', datname, 'CREATE') AS can_create,
    has_database_privilege('postgres', datname, 'TEMPORARY') AS can_create_temp
FROM
    pg_catalog.pg_database
WHERE
    datname = 'v21';

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

-- GRANT
GRANT USAGE ON SCHEMA your_schema TO your_user;
GRANT SELECT ON ALL TABLES IN SCHEMA your_schema TO your_user;

==============================================================================