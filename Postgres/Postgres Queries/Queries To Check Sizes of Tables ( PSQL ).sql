-- ### Check Size of every Table in every Schema ### --

CREATE OR REPLACE FUNCTION analyze_disk_usage()
RETURNS TABLE(table_name TEXT, total_size BIGINT, table_size BIGINT, index_size BIGINT, toast_size BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT
        tablename::TEXT AS table_name,
        pg_total_relation_size('"' || schemaname || '"."' || tablename || '"') AS total_size,
        pg_relation_size('"' || schemaname || '"."' || tablename || '"') AS table_size,
        pg_indexes_size('"' || schemaname || '"."' || tablename || '"') AS index_size,
        pg_total_relation_size('"' || schemaname || '"."' || tablename || '"') 
        - pg_relation_size('"' || schemaname || '"."' || tablename || '"') 
        - pg_indexes_size('"' || schemaname || '"."' || tablename || '"') AS toast_size
    FROM pg_tables
    WHERE schemaname = 'sdedba';
END;
$$ LANGUAGE plpgsql;

-- Usage:
SELECT * FROM analyze_disk_usage();

=====================================================================================

-- ### Check Size of all Schemas ### --

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

======================================================================================