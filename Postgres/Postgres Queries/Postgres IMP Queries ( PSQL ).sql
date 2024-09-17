
 -- ############################ Postgres IMP Queries ################################# --

******************************************************************************************

-- All DB's Stats
SELECT 
    datname,
    numbackends AS connections,
    xact_commit AS commits,
    xact_rollback AS rollbacks,
    blks_read AS blocks_read,
    blks_hit AS cache_hits,
    tup_returned AS rows_returned,
    tup_fetched AS rows_fetched,
    tup_inserted AS rows_inserted,
    tup_updated AS rows_updated,
    tup_deleted AS rows_deleted
FROM pg_stat_database
ORDER BY datname;

******************************************************************************************

-- Table Locks
SELECT
  pg_stat_activity.pid,
  pg_locks.locktype,
  pg_locks.mode,
  pg_locks.granted,
  pg_locks.relation::regclass AS relation,
  now() - pg_stat_activity.query_start AS duration,
  pg_stat_activity.query
FROM
  pg_locks
JOIN
  pg_stat_activity ON pg_locks.pid = pg_stat_activity.pid
WHERE
  pg_locks.relation IS NOT NULL
ORDER BY
  duration DESC;

******************************************************************************************

-- Running ( ACTIVE ) transactions
SELECT
  pid,
  client_addr,
  now() - xact_start AS duration,
  state,
  query
FROM
  pg_stat_activity
WHERE
  xact_start IS NOT NULL
ORDER BY
  duration DESC
LIMIT 10;

******************************************************************************************

-- query to find dependencies for a specific table
SELECT
    dep.classid,
    dep.objid,
    dep.objsubid,
    dep.refclassid,
    dep.refobjid,
    dep.refobjsubid,
    dep.deptype,
    c1.relname AS dependent_object,
    c2.relname AS referenced_object
FROM
    pg_depend dep
JOIN
    pg_class c1 ON dep.objid = c1.oid
JOIN
    pg_class c2 ON dep.refobjid = c2.oid
JOIN
    pg_namespace n1 ON c1.relnamespace = n1.oid
JOIN
    pg_namespace n2 ON c2.relnamespace = n2.oid
WHERE
--     n1.nspname || '.' || c1.relname = 'suitedba.cfg_object_def'
     n2.nspname || '.' || c2.relname = 'suitedba.cfg_object_def';

******************************************************************************************

-- ALL TABLE STATS ------------------------------------------------------------------------

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
-- WHERE
--     c.relname = 'usm_role_definition';

******************************************************************************************

-- Table activity

SELECT 
    schemaname,
    relname,
    seq_scan AS sequential_scans,
    seq_tup_read AS sequential_tuples_read,
    idx_scan AS index_scans,
    idx_tup_fetch AS index_tuples_fetched,
    n_tup_ins AS rows_inserted,
    n_tup_upd AS rows_updated,
    n_tup_del AS rows_deleted,
    n_live_tup AS live_rows,
    n_dead_tup AS dead_rows
FROM pg_stat_user_tables
ORDER BY schemaname, relname;

******************************************************************************************

-- Check for grants on a schema / table / column 

SELECT
    table_schema,
    table_name,
    column_name,
    privilege_type
FROM
    information_schema.column_privileges
WHERE
    grantee = 'pgdba'
    AND table_schema ='sdedba'
    AND table_name = 'ref_customer'
-- 	AND column_name = 'customer_id';

******************************************************************************************

-- Check for Databases Size

SELECT 
    datname AS database_name,
    pg_size_pretty(pg_database_size(datname)) AS size
FROM 
    pg_database;
		
******************************************************************************************

-- ### Check Size of every Table in every Schema ### --					
SELECT
        tablename::TEXT AS table_name,
        pg_total_relation_size('"' || schemaname || '"."' || tablename || '"') AS total_size,
        pg_relation_size('"' || schemaname || '"."' || tablename || '"') AS table_size,
        pg_indexes_size('"' || schemaname || '"."' || tablename || '"') AS index_size,
        pg_total_relation_size('"' || schemaname || '"."' || tablename || '"') 
        - pg_relation_size('"' || schemaname || '"."' || tablename || '"') 
        - pg_indexes_size('"' || schemaname || '"."' || tablename || '"') AS toast_size
    FROM pg_tables
	order by total_size DESC
--  WHERE schemaname = 'sdedba';

******************************************************************************************

-- Checking all Connections on one DB 

SELECT * FROM pg_stat_activity WHERE datname = 'vdpsdb';

-- Removing all Connections on one DB 

SELECT 
    pg_terminate_backend(pid)
FROM 
    pg_stat_activity
WHERE 
    datname = 'vdpsdb'
    AND pid <> pg_backend_pid();  -- Exclude the current session

******************************************************************************************