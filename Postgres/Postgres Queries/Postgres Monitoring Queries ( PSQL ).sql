
--################################ Postgres Monitoring ####################################--

=======================================================================================
-- Server Side -- 

ps aux | grep postgres
-- Lists all PostgreSQL processes and their current states. You can see which queries are being executed, the resources each process is consuming, and their corresponding users

top -u postgres
-- Provides a real-time view of all PostgreSQL processes, showing CPU and memory usage, process states, and load averages

iostat -x 5  -- ( 5 secs )
-- Monitors disk I/O performance, which is critical for database operations. It shows the read/write speeds, CPU utilization, and I/O wait times

vmstat 5 -- ( 5 secs ) ( IMP )
-- Provides a snapshot of system performance, including CPU, memory, and I/O statistics

CPU Usage: sar -u 5 (every 5 seconds)
Memory Usage: sar -r 5
Disk I/O: sar -d 5
Network: sar -n DEV 5
--  A comprehensive system performance monitoring tool that collects and reports various system metrics, such as CPU, memory, I/O, and network usage.
=======================================================================================
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

=======================================================================================
-- View Query Statistics and Reset:

-- View statistics
SELECT * FROM pg_stat_statements;

-- Reset statistics
SELECT pg_stat_statements_reset();

=======================================================================================
-- pg_stat_statements

SELECT 
  r.rolname AS username,
  d.datname AS database_name,
  a.client_addr AS ip_address,
  s.calls,
  s.mean_exec_time / 1000 as mean_exec_time_secs, 
  s.calls, 
  s.rows,
  s.shared_blks_hit, 
  s.shared_blks_read, 
  s.shared_blks_hit /(s.shared_blks_hit + s.shared_blks_read):: NUMERIC * 100 as hit_ratio, 
  (s.blk_read_time + s.blk_write_time)/s.calls AS average_io_time_ms,
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
    shared_blks_hit > 0 
AND  
	r.rolname IN ('pgdba','pguser')
AND 
	a.client_addr NOT IN ('10.10.10.70')
AND 
	a.client_addr = '10.1.8.23'
ORDER BY
    s.query, s.userid, s.total_exec_time DESC
-- ORDER BY 
  --  (blk_read_time + blk_write_time)/calls ASC
LIMIT 1000;

=======================================================================================
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
-- AND 
	-- a.client_addr NOT IN ('10.10.10.70')
AND 
	a.client_addr = '10.1.8.23'
AND 
	d.datname = 'vcisdb'
AND 
	s.query ILIKE '%Delete from%' 
ORDER BY
    s.query, s.userid, s.total_exec_time DESC;

=============================================================================================
-- Display all user connections to the database with their ips and queries

SELECT
 *
FROM
 pg_stat_activity

=============================================================================================
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

=============================================================================================
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
  
=============================================================================================
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

=============================================================================================
-- Query to check for Specific connection

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
  -- where client_addr = '10.1.8.23';

=============================================================================================
-- Monitor Queries with Long running execution time and calls

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
ORDER BY 
    total_exec_time DESC
LIMIT 10;

=============================================================================================
-- Monitor Queries with Long running execution time and calls ( Similar to above )

SELECT 
    s.calls, 
    s.total_exec_time, 
    s.rows, 
    s.shared_blks_read, 
    s.shared_blks_hit,
    s.temp_blks_read,
    s.temp_blks_written,
    a.client_addr AS client_ip,
	s.query
FROM 
    pg_stat_statements s
JOIN 
    pg_stat_activity a 
ON 
    s.userid = a.usesysid AND s.dbid = a.datid AND s.query = a.query
ORDER BY 
    s.total_exec_time DESC
LIMIT 20;

=============================================================================================












