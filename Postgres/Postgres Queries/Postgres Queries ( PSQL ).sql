
-- ############################ Monitoring in Postgres ############################# --

--------------------- ######## Postgres Important Tables ######## ---------------------

SELECT * FROM pg_stats;
SELECT * FROM information_schema.tables;
SELECT * FROM pg_stat_all_tables;
SELECT * FROM pg_tables;
--
SELECT * FROM pg_stat_activity;
SELECT * FROM pg_database;
SELECT * FROM pg_stat_database;
select * from pg_stat_database_conflicts
--
SELECT * FROM information_schema.schemata;
SELECT * FROM information_schema.triggers;
SELECT * FROM information_schema.sequences;
SELECT * FROM information_schema.columns;
SELECT * FROM information_schema.table_constraints; -- -- all PK's and FK's ++
SELECT * FROM information_schema.referential_constraints;  -- all PK's and FK's 
SELECT * FROM information_schema.key_column_usage; -- all indexes
SELECT * FROM information_schema.views;	-- all views
--
SELECT * FROM information_schema.role_table_grants; -- table grants ( Insert/Update/Delete)
SELECT * FROM information_schema.table_constraints;
SELECT * FROM information_schema.table_privileges;
SELECT * FROM information_schema.view_table_usage; -- all views ( by table )
SELECT * FROM information_schema.view_column_usage; -- all views ( by column )
--
SELECT * FROM information_schema.role_column_grants; -- Column grants 
SELECT * FROM information_schema.constraint_column_usage;
SELECT * FROM information_schema.constraint_table_usage;
SELECT * FROM information_schema.sql_features;
SELECT * FROM information_schema.column_privileges;
--
SELECT * FROM pg_constraint;
SELECT * FROM pg_indexes;
SELECT * FROM pg_stat_all_indexes;
SELECT * FROM pg_sequence;
SELECT * FROM pg_statio_all_sequences;
SELECT * FROM pg_trigger;
SELECT * FROM pg_depend;
SELECT * FROM pg_tablespace;
SELECT * FROM pg_namespace;
SELECT * FROM pg_views;
SELECT * FROM pg_matviews;
SELECT * FROM pg_locks; -- to view locks
--
SELECT * FROM pg_cursors;
SELECT * FROM pg_partitioned_table;
--
SELECT * FROM pg_roles;
SELECT * FROM pg_user;
SELECT * FROM pg_group;
SELECT * FROM pg_authid;
--
SELECT * FROM pg_class;
SELECT * FROM pg_attribute;
SELECT * FROM pg_type;
SELECT * FROM pg_operator;
--
SELECT * FROM pg_file_settings;
SELECT * FROM pg_settings;
SELECT * FROM pg_config;
SELECT * FROM pg_ts_template;
SELECT * FROM pg_ts_dict;
SELECT * FROM pg_ts_config;
--
select * from pg_stat_progress_basebackup  -- Check for basebackup progress
select * from pg_stat_user_tables -- To check for vacuum and autovacuum

=======================================================================================
-- Sequence Table
select * from sdedba.ref_sys_table_sequence

=============================================================================================
-- Current Date

SELECT DATE_TRUNC('day',current_date)
=============================================================================================
-- Search for Postgres configuration file

pg_config --sysconfdir
=============================================================================================
-- pg_stat_statements

SELECT DISTINCT ON (s.query, s.userid)
    r.rolname AS username,
    d.datname AS database_name,
    a.client_addr AS ip_address,
    s.calls,
    s.total_exec_time AS total_time,
    s.mean_exec_time AS mean_time,
    s.rows,
    s.shared_blks_hit,
    s.shared_blks_read,
    s.temp_blks_written,
    s.query
FROM
    pg_stat_statements s
JOIN
    pg_roles r ON s.userid = r.oid
JOIN
    pg_database d ON s.dbid = d.oid
LEFT JOIN
    pg_stat_activity a ON s.userid = a.usesysid
WHERE
	r.rolname IN ('pgdba','pguser')
AND 
	a.client_addr = '10.1.8.23'
ORDER BY
    s.query, s.userid, s.total_exec_time DESC;

----------------------------------

-- Reset statistics	
SELECT pg_stat_statements_reset();
	
=============================================================================================

-- Check for Databases Size

SELECT 
    datname AS database_name,
    pg_size_pretty(pg_database_size(datname)) AS size
FROM 
    pg_database;
	
=============================================================================================

-- ### Check Size of Tables in every Schema ### --

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

=============================================================================================

-- ### Check Size of all Tables ### --

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

=============================================================================================
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

=============================================================================================
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
WHERE
    c.relname = 'usm_role_definition';

=============================================================================================
-- To find queries that are blocked by other queries

SELECT
    blocked_locks.pid AS blocked_pid,
    blocked_activity.usename AS blocked_user,
    blocked_activity.query AS blocked_query,
    blocking_locks.pid AS blocking_pid,
    blocking_activity.usename AS blocking_user,
    blocking_activity.query AS blocking_query
FROM pg_locks blocked_locks
JOIN pg_stat_activity blocked_activity
    ON blocked_activity.pid = blocked_locks.pid
JOIN pg_locks blocking_locks
    ON blocking_locks.locktype = blocked_locks.locktype
    AND blocking_locks.DATABASE IS NOT DISTINCT FROM blocked_locks.DATABASE
    AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
    AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
    AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
    AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
    AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
    AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
    AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
    AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
    AND blocking_locks.pid != blocked_locks.pid
JOIN pg_stat_activity blocking_activity
    ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;
=============================================================================================
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
    pg_stat_activity.query AS query_snippet,
    age(now(), pg_stat_activity.query_start) AS age
FROM pg_stat_activity
JOIN pg_locks
    ON pg_locks.pid = pg_stat_activity.pid
LEFT OUTER JOIN pg_class
    ON pg_locks.relation = pg_class.oid
ORDER BY pg_stat_activity.query_start;

=============================================================================================
-- Get Procedures

SELECT routine_name 
	            FROM information_schema.routines,
		  			information_schema.schemata r
					WHERE routine_schema = r.schema_name 
                    AND routine_type = 'PROCEDURE'
=============================================================================================
-- Query to check for all connection on postgres ( Idle connections too )( Similar to above but better )

SELECT 
    pid, 
    usename, 
    datname, 
    client_addr, 
    state, 
    query, 
    backend_start, 
    query_start 
FROM 
    pg_stat_activity
WHERE 
    state = 'idle';
=============================================================================================
-- Long-running queries ( Performance )

SELECT
  pid,
  now() - pg_stat_activity.query_start AS duration,
  query,
  state
FROM
  pg_stat_activity
WHERE
 -- state != 'idle'
 -- AND
 now() - pg_stat_activity.query_start > interval '15 minutes'
ORDER BY
  duration DESC;
=============================================================================================
-- This query provides database-level statistics such as the number of transactions committed and rolled back (commits and rollbacks), as well as the number of blocks read from cache and disk (blocks_hit and blocks_read). These statistics can be useful for monitoring database activity and performance

SELECT 
  now() AS current_time,
  datname AS database_name,
  xact_commit AS commits,
  xact_rollback AS rollbacks,
  blks_hit AS blocks_hit,
  blks_read AS blocks_read
FROM 
  pg_stat_database;
=============================================================================================
-- Unused indexes

SELECT
  schemaname,
  relname AS table,
  indexrelname AS index,
  idx_scan AS index_scans
FROM
  pg_stat_user_indexes
WHERE
  idx_scan = 0
ORDER BY
  schemaname,
  relname;
=============================================================================================
-- Index Usage  

  SELECT 
  relname,
  indexrelname,
  idx_scan,
  idx_tup_read,
  idx_tup_fetch
FROM 
  pg_stat_user_indexes 
ORDER BY 
  idx_scan DESC;
=============================================================================================
-- Table and Index Size -- Top 10 largest tables

SELECT
  schemaname,
  relname AS table,
  pg_size_pretty(pg_total_relation_size(relid)) AS total_size
FROM
  pg_catalog.pg_statio_user_tables
ORDER BY
  pg_total_relation_size(relid) DESC
LIMIT 10;
=============================================================================================
-- Top 10 largest indexes

SELECT
  schemaname,
  relname AS table,
  indexrelname AS index,
  pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM
  pg_stat_user_indexes
ORDER BY
  pg_relation_size(indexrelid) DESC
LIMIT 10;
=============================================================================================
-- Tables requiring vacuum
 
 SELECT 
    relname,
    schemaname,
    last_vacuum,
    last_autovacuum,
    vacuum_count,
    autovacuum_count,
    n_dead_tup,
    n_live_tup
FROM 
    pg_stat_all_tables
WHERE 
    n_dead_tup > 1000
ORDER BY 
    n_dead_tup DESC;
---------------------------	
SELECT
  schemaname,
  relname,
  n_dead_tup AS dead_tuples
FROM
  pg_stat_user_tables
WHERE
  n_dead_tup > 1000
ORDER BY
  n_dead_tup DESC;
  
-- Last Vacuum

SELECT 
    relname AS table_name,
    schemaname AS schema_name,
    last_vacuum,
    last_autovacuum
FROM 
    pg_stat_all_tables
WHERE 
    relname = 'usm_user_multi_misc_info';

=============================================================================================
-- Tables requiring analyze

SELECT
  schemaname,
  relname,
  last_analyze
FROM
  pg_stat_user_tables
ORDER BY
  last_analyze ASC
LIMIT 10;
=============================================================================================
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
=============================================================================================
-- Current wait events

SELECT
  pid,
  client_addr,
  wait_event_type,
  wait_event,
  query
FROM
  pg_stat_activity
WHERE
  wait_event IS NOT NULL;
=============================================================================================
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
=============================================================================================
-- Cache hit ratio ( Higher hit ratio means more efficiency )

SELECT
  datname,
  blks_hit,
  blks_read,
  CASE 
    WHEN (blks_hit + blks_read) = 0 THEN 0
    ELSE ROUND((blks_hit::numeric / (blks_hit + blks_read)) * 100, 2)::numeric
  END AS hit_ratio
FROM
  pg_stat_database
WHERE
  (blks_hit + blks_read) > 0
ORDER BY
  hit_ratio DESC;
=============================================================================================
-- Check for long running transactions
 
SELECT 
  pid,
  datname,
  usename,
  now() - xact_start AS duration,
  query,
  state,
  backend_start,
  xact_start  
FROM 
  pg_stat_activity 
WHERE 
  state = 'active' 
  AND query NOT ILIKE '%idle%';
=============================================================================================
-- Check for Transactions per database

SELECT 
  datname,
  numbackends AS connections,
  xact_commit AS commits,
  xact_rollback AS rollbacks,
  blks_read AS disk_reads,
  blks_hit AS buffer_hits
FROM 
  pg_stat_database
ORDER BY 
  commits DESC;
=============================================================================================
-- WAL (Write-Ahead Logging) Statistics

SELECT 
  slot_name,
  database,
  active,
  restart_lsn,
  pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)) AS replication_lag
FROM 
  pg_replication_slots;
=============================================================================================
-- Checkpoint activity

SELECT 
  checkpoints_timed,
  checkpoint_write_time,
  checkpoint_sync_time,
  buffers_checkpoint
FROM 
  pg_stat_bgwriter
ORDER BY 
  checkpoints_timed DESC
LIMIT 10;
------------------------
select * from pg_stat_bgwriter;
=============================================================================================
-- List All Role Memberships

SELECT
  r1.rolname AS role,
  r2.rolname AS member,
  r3.rolname AS grantor,
  a.admin_option
FROM
  pg_auth_members a
JOIN
  pg_roles r1 ON r1.oid = a.roleid
JOIN
  pg_roles r2 ON r2.oid = a.member
JOIN
  pg_roles r3 ON r3.oid = a.grantor;
=============================================================================================
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
=============================================================================================
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
=============================================================================================
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

=============================================================================================
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

=============================================================================================

SELECT EXTRACT(SECOND FROM TIMESTAMP '2001-02-16 20:38:40') AS second_part;

SELECT EXTRACT(HOUR FROM CURRENT_TIMESTAMP) AS hour_part;

SELECT EXTRACT(DAY FROM TIMESTAMP '2001-02-16 20:38:40') AS day_part;

=============================================================================================

-- To read the logs from DBeaver
-- 1048576 Is to read the max of file 1 MB 
-- 0 to start from the beginning
SELECT pg_read_file('log/postgresql-Tue.log', 0, 1048576);

=============================================================================================
-- Dropping a database 

SELECT 
    pg_terminate_backend(pid)
FROM 
    pg_stat_activity
WHERE 
    datname = 'DUMP_VDPS'
    AND pid <> pg_backend_pid();  -- Exclude the current session
--	
SELECT * FROM pg_stat_activity WHERE datname = 'DUMP_VDPS';

=============================================================================================
-- One database Info
SELECT 
    checkpoints_timed, 
    checkpoints_req, 
    buffers_checkpoint, 
    buffers_clean, 
    maxwritten_clean, 
    buffers_backend, 
    buffers_alloc 
FROM 
    pg_stat_bgwriter;

=============================================================================================

SELECT *
FROM pg_stat_activity
Where now() - query_start > interval '15 minutes';

=============================================================================================

-- Detecting Deadlocks ( Locks held by tables )
WITH BLOCKED AS
	(SELECT BLOCKED_LOCKS.PID,
			BLOCKED_LOCKS.LOCKTYPE AS BLOCKED_LOCKTYPE,
			RELATION::REGCLASS AS LOCKED_TABLE,
			MODE AS BLOCKED_MODE
		FROM PG_LOCKS BLOCKED_LOCKS
		JOIN PG_STAT_ACTIVITY BLOCKED_ACTIVITY ON BLOCKED_LOCKS.PID = BLOCKED_ACTIVITY.PID
		WHERE NOT BLOCKED_LOCKS.GRANTED ),
	BLOCKING AS
	(SELECT BLOCKING_LOCKS.PID,
			BLOCKING_LOCKS.LOCKTYPE AS BLOCKING_LOCKTYPE,
			RELATION::REGCLASS AS LOCKED_TABLE,
			MODE AS BLOCKING_MODE
		FROM PG_LOCKS BLOCKING_LOCKS
		JOIN PG_STAT_ACTIVITY BLOCKING_ACTIVITY ON BLOCKING_LOCKS.PID = BLOCKING_ACTIVITY.PID
		WHERE BLOCKING_LOCKS.GRANTED )
SELECT BLOCKING.PID AS BLOCKING_PID,
	BLOCKED.PID AS BLOCKED_PID,
	BLOCKING.LOCKED_TABLE AS BLOCKING_TABLE,
	BLOCKED.LOCKED_TABLE AS BLOCKED_TABLE,
	BLOCKING.BLOCKING_MODE AS BLOCKING_MODE,
	BLOCKED.BLOCKED_MODE AS BLOCKED_MODE,
	PG_STAT_ACTIVITY.QUERY AS BLOCKED_QUERY
FROM BLOCKED
JOIN BLOCKING ON BLOCKED.LOCKED_TABLE = BLOCKING.LOCKED_TABLE
JOIN PG_STAT_ACTIVITY ON BLOCKED.PID = PG_STAT_ACTIVITY.PID
ORDER BY BLOCKED_QUERY;

=============================================================================================

-- Identifying Blocking Chains
WITH RECURSIVE lock_tree AS (
    SELECT
        blocked_locks.pid AS blocked_pid,
        blocked_activity.query AS blocked_query,
        blocked_activity.query_start AS blocked_query_start,
        blocked_activity.state AS blocked_state,
        blocking_locks.pid AS blocking_pid,
        blocking_activity.query AS blocking_query,
        blocking_activity.query_start AS blocking_query_start,
        blocking_activity.state AS blocking_state
    FROM pg_locks blocked_locks
    JOIN pg_stat_activity blocked_activity ON blocked_locks.pid = blocked_activity.pid
    JOIN pg_locks blocking_locks ON blocked_locks.locktype = blocking_locks.locktype
        AND blocked_locks.relation = blocking_locks.relation
        AND blocked_locks.database = blocking_locks.database
    JOIN pg_stat_activity blocking_activity ON blocking_locks.pid = blocking_activity.pid
    WHERE NOT blocked_locks.granted
        AND blocking_locks.granted
)
SELECT * FROM lock_tree
ORDER BY blocked_query_start DESC;

=============================================================================================

-- Analyze Waiting Events ( Check for AutoVacuum )
SELECT 
    pid, 
    usename, 
    datname, 
    state, 
    wait_event_type, 
    wait_event, 
    age(clock_timestamp(), query_start) AS runtime, 
    query
FROM 
    pg_stat_activity
WHERE 
    state <> 'idle'
AND wait_event IS NOT NULL
ORDER BY runtime DESC;

=============================================================================================

-- Cache hit ratio for queries
SELECT 
    calls,
    ROUND(total_exec_time::numeric / 60000, 2) AS total_exec_time_minutes, 
    ROUND(total_exec_time::numeric / calls / 1000, 2) AS avg_exec_time_per_call_ms,
    rows,
    shared_blks_read, 
    shared_blks_hit, 
    ROUND(100 * shared_blks_hit / NULLIF(shared_blks_hit + shared_blks_read, 0), 2) AS cache_hit_ratio,
    temp_blks_read,
    temp_blks_written,
    query
FROM 
    pg_stat_statements
ORDER BY 
    total_exec_time DESC
LIMIT 100;

=============================================================================================

-- Suppose you have a table called "users" with a column "username"
SELECT username
FROM users
WHERE username %% 'johnny';


SELECT * FROM my_table WHERE my_column %% 'hello';

=============================================================================================

-- List of Latest executed queries
SELECT
    state,
    application_name,
    client_addr AS ip_address,
    backend_start,
    now() - query_start AS execution_time,
	query
FROM
    pg_stat_activity
WHERE
	query != ''
AND
	query NOT LIKE 'SET application_name%'
AND 
	query NOT LIKE 'COMMIT'
ORDER BY
    query_start DESC
LIMIT 100;

=============================================================================================

-- pg_stat_io
SELECT *
FROM pg_stat_io
--
SELECT backend_type, 
       context, 
       reads, 
       writes, 
       hits, 
       evictions
FROM pg_stat_io
ORDER BY backend_type;

=============================================================================================

-- All functions

SELECT 
    n.nspname AS schema_name, 
    p.proname AS function_name, 
    pg_catalog.pg_get_function_result(p.oid) AS result_type, 
    pg_catalog.pg_get_function_arguments(p.oid) AS arguments 
FROM 
    pg_catalog.pg_proc p 
JOIN 
    pg_catalog.pg_namespace n ON n.oid = p.pronamespace 
WHERE 
    n.nspname NOT IN ('pg_catalog', 'information_schema')
-- AND p.proname LIKE 'run_python_cmd'
ORDER BY 
    schema_name, function_name;

=============================================================================================