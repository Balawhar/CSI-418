-- Query to check size of tables and indexes in every schema in Postgres

SELECT 
    table_name,
    pg_size_pretty(pg_total_relation_size(table_name::regclass)) AS total_size,
    pg_size_pretty(pg_relation_size(table_name::regclass)) AS table_size,
    pg_size_pretty(pg_total_relation_size(table_name::regclass) - pg_relation_size(table_name::regclass)) AS index_size
FROM information_schema.tables
WHERE table_schema = 'my_schema'
ORDER BY pg_total_relation_size(table_name::regclass) DESC;

--------------------------------------------------------------

-- List all schemas

SELECT schema_name
FROM information_schema.schemata;

--------------------------------------------------------------
