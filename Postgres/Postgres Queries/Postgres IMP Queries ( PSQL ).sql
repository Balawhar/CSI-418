
 -- ############################ Postgres IMP Queries ################################# --

******************************************************************************************

-- All DB's Stats
SELECT 
    A.datname,
    pg_size_pretty(pg_database_size(B.datname)) AS database_size,
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
FROM pg_stat_database A
     JOIN pg_database B ON B.oid = A.datid
ORDER BY
    numbackends DESC;

******************************************************************************************

-- The pg_locks view provides information about the LOCKS held by active processes in the database ( deadlocks	)

SELECT
    pg_stat_activity.datname,
    pg_class.relname,
    pg_locks.transactionid,
    pg_locks.classid,
    pg_locks.objid,
    pg_locks.objsubid,
    pg_locks.virtualtransaction,
    pg_locks.locktype,
    pg_locks.mode,
    pg_locks.granted,
    pg_stat_activity.usename,
	pg_stat_activity.client_addr AS ip_address,
    pg_stat_activity.pid,
	application_name,
    pg_stat_activity.query AS query_snippet,
    age(now(), pg_stat_activity.query_start) AS age
FROM pg_stat_activity
JOIN pg_locks
    ON pg_locks.pid = pg_stat_activity.pid
LEFT OUTER JOIN pg_class
    ON pg_locks.relation = pg_class.oid
ORDER BY pg_stat_activity.query_start;

******************************************************************************************

-- Running ( ACTIVE ) transactions
SELECT
  pid,
  client_addr,
  now() - xact_start AS duration,
  state,
  application_name,
  query
FROM
  pg_stat_activity
WHERE
  xact_start IS NOT NULL
ORDER BY
  duration DESC
LIMIT 10;

******************************************************************************************

-- Queries with long running EXECUTION TIME and CALLS
SELECT 
    calls, 
--     ROUND(total_exec_time::numeric / 60000, 1) AS total_exec_time_minutes, 
    ROUND(total_exec_time::numeric / calls / 1000, 2) AS avg_exec_time_per_call_sec, 
    rows, 
    shared_blks_read, 
    shared_blks_hit,
    temp_blks_read,
    temp_blks_written,
    query
FROM 
    pg_stat_statements
-- ORDER BY 
    -- total_exec_time DESC
ORDER BY
	avg_exec_time_per_call_sec DESC
LIMIT 1000;

******************************************************************************************

-- Connections / Sessions ( Per Database / User / Ip )
SELECT 
    pid, 
    usename, 
    datname, 
    client_addr, 
    state,
	application_name,
    query, 
    backend_start,
	query_start 
FROM 
    pg_stat_activity
WHERE 
    state = 'idle'
-- AND
	-- datname = 'vdpsdb'
-- AND 
	-- usename = 'pgdba'
-- AND 
	-- client_addr = '10.1.8.23'
-- AND
	-- query LIKE 'SET%';

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
    pg_total_relation_size('"' || schemaname || '"."' || tablename || '"') / 1024 AS total_size_kb,
    pg_relation_size('"' || schemaname || '"."' || tablename || '"') / 1024 AS table_size_kb,
    pg_indexes_size('"' || schemaname || '"."' || tablename || '"') / 1024 AS index_size_kb,
    (pg_total_relation_size('"' || schemaname || '"."' || tablename || '"') 
    - pg_relation_size('"' || schemaname || '"."' || tablename || '"') 
    - pg_indexes_size('"' || schemaname || '"."' || tablename || '"')) / 1024 AS toast_size_kb
FROM pg_tables
WHERE schemaname = 'findba'
ORDER BY total_size_kb DESC
LIMIT 100;

******************************************************************************************

-- Size of tables
SELECT
    schemaname,
    tablename,
    pg_size_pretty(total_bytes) AS total_size
FROM (
    SELECT
        pg_catalog.pg_namespace.nspname AS schemaname,
        relname AS tablename,
        pg_relation_size(pg_catalog.pg_class.oid) AS total_bytes
    FROM
        pg_catalog.pg_class
    JOIN
        pg_catalog.pg_namespace ON relnamespace = pg_catalog.pg_namespace.oid
) AS table_sizes
ORDER BY
    total_bytes DESC;
	
******************************************************************************************

-- Checking all Connections on one DB 

SELECT * FROM pg_stat_activity WHERE datname = 'vfds_dev';

-- Removing all Connections on one DB 

SELECT 
    pg_terminate_backend(pid)	  -- Terminate 1 PID
FROM 
    pg_stat_activity
WHERE 
    datname = 'vfds_dev'
    AND pid <> pg_backend_pid();  -- Exclude the current session

--

SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE pid IN (1575783, 1575784, 1575785);

******************************************************************************************

-- Check for tables that are most sequence scanned

SELECT 
  schemaname, 
  relname, 
  Seq_scan, 
  idx_scan seq_tup_read, 
  seq_tup_read / seq_scan as avg_seq_read 
FROM 
  pg_stat_all_tables 
WHERE 
  seq_scan > 0 AND schemaname not in ('pg_catalog', 'information_schema') 
ORDER BY 
  seq_scan DESC LIMIT 30;
  
******************************************************************************************

-- Lock a table/column from Update/Insert for the transaction you are in
SELECT * 
FROM orders 
-- WHERE order_status = 'pending'
FOR SHARE;

******************************************************************************************

-- Alter column type with cast
ALTER TABLE employees
ALTER COLUMN employee_id TYPE integer
-- USING employee_id::integer;
-- USING convert_from(bsn_rule_query_result, 'UTF8')::jsonb; ( from bytea to jsonb )

******************************************************************************************

-- Table Info
select * from pg_stat_user_tables
where relname = 'fin_transaction'