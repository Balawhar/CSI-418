
-- ######################## Postgres DB Health Function ######################## --

-- Define the monitoring function
CREATE OR REPLACE FUNCTION DB_Health()
RETURNS TABLE (
    db_name TEXT,
    total_size TEXT,
    long_running_queries INT,
    connections INT,
    hit_ratio NUMERIC,
    commit_count BIGINT,
    rollback_count BIGINT,
    deadlock_count BIGINT,
    blocked_queries_count BIGINT,
    max_connections INT
) AS $$
BEGIN
    RETURN QUERY
    WITH db_size AS (
        SELECT
            pg_database.datname AS db_name,
            pg_size_pretty(pg_database_size(pg_database.datname)) AS total_size
        FROM 
            pg_database
    ),
    long_queries AS (
        SELECT
            count(*) AS long_running_queries
        FROM 
            pg_stat_activity
        WHERE 
            state != 'idle'
            AND now() - pg_stat_activity.query_start > interval '5 minutes'
    ),
    conn_info AS (
        SELECT 
            datname,
            count(*) FILTER (WHERE state != 'active') AS connections
        FROM 
            pg_stat_activity
        GROUP BY 
            datname
    ),
    hit_ratio_info AS (
        SELECT
            datname,
            CASE 
                WHEN (blks_hit + blks_read) = 0 THEN 0
                ELSE ROUND((blks_hit::numeric / (blks_hit + blks_read)) * 100, 2)::numeric
            END AS hit_ratio
        FROM 
            pg_stat_database
        WHERE
            (blks_hit + blks_read) > 0
    ),
    commit_rollback_info AS (
        SELECT
            datname,
            sum(xact_commit) AS commit_count,
            sum(xact_rollback) AS rollback_count
        FROM
            pg_stat_database
        GROUP BY
            datname
    ),
    deadlocks AS (
        SELECT
            count(*) AS deadlock_count
        FROM 
            pg_stat_activity
        WHERE 
            state = 'idle in transaction (aborted)'
    ),
    blocked_queries AS (
        SELECT
            count(*) AS blocked_queries_count
        FROM 
            pg_locks
        WHERE 
            granted = false
            AND mode = 'ExclusiveLock'
    ),
    max_conn AS (
        SELECT setting::int AS max_connections
        FROM pg_settings
        WHERE name = 'max_connections'
    )
    SELECT 
        ds.db_name::TEXT,
        ds.total_size::TEXT,
        lq.long_running_queries::INT,
        ci.connections::INT,
        hri.hit_ratio::NUMERIC,
        cbi.commit_count::BIGINT,
        cbi.rollback_count::BIGINT,
        dl.deadlock_count::BIGINT,
        bq.blocked_queries_count::BIGINT,
        mc.max_connections::INT
    FROM 
        db_size ds
        CROSS JOIN long_queries lq
        JOIN conn_info ci ON ds.db_name = ci.datname
        JOIN hit_ratio_info hri ON ds.db_name = hri.datname
        JOIN commit_rollback_info cbi ON ds.db_name = cbi.datname
        CROSS JOIN deadlocks dl
        CROSS JOIN blocked_queries bq
        CROSS JOIN max_conn mc;
END;
$$ LANGUAGE plpgsql;

-- Execute the custom monitoring function
SELECT * FROM DB_Health();
