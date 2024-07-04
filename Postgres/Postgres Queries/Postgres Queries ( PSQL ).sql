-- ################################# Monitoring in Postgres #######################################--
======================================================================================================
------------------------------- ##### Postgres Important Tables ###### ------------------------------------------
--
SELECT * FROM pg_stats;
SELECT * FROM information_schema.tables;
SELECT * FROM pg_stat_all_tables;
SELECT * FROM pg_tables;
--
SELECT * FROM pg_stat_activity;
SELECT * FROM pg_database;
SELECT * FROM pg_stat_database;
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
SELECT * FROM pg_locks;
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
SELECT schema_name
FROM information_schema.schemata;
--
select * from pg_stat_user_tables -- To check for vacuum and autovacuum
=================================================================================================================
-- Current Date
SELECT DATE_TRUNC('day',current_date)
=================================================================================================================
-- Search for Postgres configuration file
pg_config --sysconfdir
=================================================================================================================
-- Check every user with every query and database logged into
SELECT
  pid,
  datname,
  client_addr,
  usename,
  state,
  application_name,
  query
  from
  pg_stat_activity
  ORDER BY client_addr DESC;
=================================================================================================================
-- Check how many sessions are openned by every user
SELECT
  count(*) AS connections,
  usename,
  client_addr
FROM
  pg_stat_activity
GROUP BY
  usename, client_addr
ORDER BY
  connections DESC;
=================================================================================================================
-- The pg_locks view provides information about the locks held by active processes in the database
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
    pg_stat_activity.pid,
    pg_stat_activity.query as query_snippet,
    age(now(), pg_stat_activity.query_start) as age
FROM pg_stat_activity, pg_locks
LEFT OUTER JOIN pg_class
ON (pg_locks.relation = pg_class.oid)
WHERE pg_locks.pid = pg_stat_activity.pid
ORDER BY pg_stat_activity.query_start;
=================================================================================================================
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
=================================================================================================================
-- Check Tablespaces size
SELECT 
  spcname,
  pg_size_pretty(pg_tablespace_size(spcname)) AS size
FROM 
  pg_tablespace
ORDER BY 
  pg_tablespace_size(spcname) DESC;
=================================================================================================================
-- Disk usage per database ( Database size )
SELECT
  datname,
  pg_size_pretty(pg_database_size(datname)) AS size
FROM
  pg_database
ORDER BY
  pg_database_size(datname) DESC;
=================================================================================================================
-- Check if the table exists
SELECT table_name
FROM information_schema.tables
WHERE table_name = 'ref_com_commission';
=================================================================================================================
-- Query to check for all connections with their IPs, Queries, Start Time, and End Time ( Idle connections too )
SELECT 
    pid AS ProcessID,
    usename AS Username,
    application_name AS Application,
    client_addr AS ClientAddress,
    state AS State,
    query AS Query,
    backend_start AS BackendStartTime,
    query_start AS QueryStartTime
FROM 
    pg_stat_activity
ORDER BY 
    state, backend_start;
=================================================================================================================
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
=================================================================================================================
-- Query to check for all # ACTIVE # connections
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
    state = 'active';
=================================================================================================================
-- Check for deadlocks	
SELECT 
  *
FROM 
  pg_locks 
WHERE 
  NOT mode = 'ExclusiveLock';
=================================================================================================================
-- Query to count the active and idle connections
SELECT 
    state, 
    count(*) 
FROM 
    pg_stat_activity 
GROUP BY 
    state;
=================================================================================================================
-- This query retrieves the process ID, username, database name, state, query start time, and the query itself, ordered by the query start time.	
SELECT
    pid,
    usename,
    datname,
    state,
    query_start,
    query
FROM
    pg_stat_activity
ORDER BY
    query_start DESC;
=================================================================================================================
-- Long-running queries ( Performance )
SELECT
  pid,
  now() - pg_stat_activity.query_start AS duration,
  query,
  state
FROM
  pg_stat_activity
WHERE
  state != 'idle'
  AND now() - pg_stat_activity.query_start > interval '5 minutes'
ORDER BY
  duration DESC;
=================================================================================================================
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
=================================================================================================================
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
=================================================================================================================
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
=================================================================================================================
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
=================================================================================================================
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
=================================================================================================================
-- Tables requiring vacuum
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
=================================================================================================================
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
=================================================================================================================
-- Longest transactions
SELECT
  pid,
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
=================================================================================================================
-- Current wait events
SELECT
  pid,
  wait_event_type,
  wait_event,
  query
FROM
  pg_stat_activity
WHERE
  wait_event IS NOT NULL;
=================================================================================================================
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
=================================================================================================================
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
=================================================================================================================
-- Check for long running transactions
SELECT 
  pid,
  datname,
  usename,
  query,
  state,
  backend_start,
  xact_start,
  now() - xact_start AS duration
FROM 
  pg_stat_activity 
WHERE 
  state = 'active' 
  AND query NOT ILIKE '%idle%';
=================================================================================================================
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
=================================================================================================================
-- WAL (Write-Ahead Logging) Statistics
SELECT 
  slot_name,
  database,
  active,
  restart_lsn,
  pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)) AS replication_lag
FROM 
  pg_replication_slots;
=================================================================================================================
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
=================================================================================================================
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
=================================================================================================================
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
WHERE
    c1.relname = 'your_table_name';
=================================================================================================================
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
=================================================================================================================
