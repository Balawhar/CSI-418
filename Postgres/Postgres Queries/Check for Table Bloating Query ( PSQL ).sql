-- Table bloating in a database context refers to the inefficient use of disk space by database tables, where the actual disk space used is significantly larger than what is needed to store the data
--
-- This query measures table bloating in a PostgreSQL database. It does so by comparing the actual size of the tables with their estimated size based on the fill factor and other metrics
--
WITH bloat_data AS (
    SELECT 
        n.nspname AS schemaname, 
        c.relname AS tblname, 
        c.relpages AS tblpages, 
        COALESCE(NULLIF(current_setting('block_size')::numeric, 0), 8192) AS bs,
        COALESCE(NULLIF(current_setting('block_size')::numeric, 0), 8192) * c.relpages AS real_size,
        (c.relpages::numeric / COALESCE(NULLIF(s.relfactor, 0), 1)) AS est_tblpages,
        (c.relpages - (c.relpages::numeric / COALESCE(NULLIF(s.relfactor, 0), 1))) * COALESCE(NULLIF(current_setting('block_size')::numeric, 0), 8192) AS extra_size,
        CASE 
            WHEN c.relpages - (c.relpages::numeric / COALESCE(NULLIF(s.relfactor, 0), 1)) > 0 
            THEN 100 * (c.relpages - (c.relpages::numeric / COALESCE(NULLIF(s.relfactor, 0), 1))) / c.relpages 
            ELSE 0 
        END AS extra_ratio,
        COALESCE(s.relfactor, 1) AS fillfactor
    FROM 
        pg_class c
    JOIN 
        pg_namespace n ON c.relnamespace = n.oid
    LEFT JOIN 
        (SELECT relid, 1 AS relfactor 
         FROM pg_stat_user_tables) s ON c.oid = s.relid
    WHERE 
        c.relkind = 'r'
)
SELECT 
    schemaname, 
    tblname, 
    real_size, 
    extra_size, 
    extra_ratio, 
    fillfactor 
FROM 
    bloat_data
ORDER BY 
    extra_ratio DESC;
-----------------------------------------------------------------------------------------------------------------