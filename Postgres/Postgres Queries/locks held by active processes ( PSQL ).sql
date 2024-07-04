-- The pg_locks view provides information about the locks held by active processes in the database.

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
-----------------------------------------------------------------------------------------------------