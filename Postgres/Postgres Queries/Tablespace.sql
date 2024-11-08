
----------------------------------------- TABLESPACE -------------------------------------------

-- Change Tablespace

DO $$
DECLARE
    table_tablespace TEXT := 'vfds_data2';
    index_tablespace TEXT := 'vdfs_index2';
    rec RECORD;
BEGIN
    -- Change the tablespace of all tables
    FOR rec IN
        SELECT n.nspname AS schemaname, 
               c.relname AS tablename,
               t.spcname AS tablespace
        FROM pg_tables p
        JOIN pg_class c ON p.tablename = c.relname
        JOIN pg_namespace n ON c.relnamespace = n.oid
        LEFT JOIN pg_tablespace t ON c.reltablespace = t.oid
        WHERE n.nspname NOT IN ('pg_catalog', 'information_schema') -- Exclude system schemas
    LOOP
        BEGIN
            EXECUTE format('ALTER TABLE %I.%I SET TABLESPACE %I',
                            rec.schemaname, rec.tablename, table_tablespace);
        EXCEPTION
            WHEN deadlock_detected THEN
                RAISE NOTICE 'Skipping table % due to deadlock', rec.schemaname || '.' || rec.tablename;
            WHEN OTHERS THEN
                RAISE NOTICE 'Error altering table %: %', rec.schemaname || '.' || rec.tablename, SQLERRM;
        END;
    END LOOP;

    -- Change the tablespace of all indexes
    FOR rec IN
        SELECT i.schemaname,
               i.indexname,
               t.spcname AS tablespace
        FROM pg_indexes i
        JOIN pg_class c ON i.indexname = c.relname
        LEFT JOIN pg_tablespace t ON c.reltablespace = t.oid
        WHERE i.schemaname NOT IN ('pg_catalog', 'information_schema') -- Exclude system schemas
    LOOP
        BEGIN
            EXECUTE format('ALTER INDEX %I.%I SET TABLESPACE %I',
                            rec.schemaname, rec.indexname, index_tablespace);
        EXCEPTION
            WHEN deadlock_detected THEN
                RAISE NOTICE 'Skipping index % due to deadlock', rec.schemaname || '.' || rec.indexname;
            WHEN OTHERS THEN
                RAISE NOTICE 'Error altering index %: %', rec.schemaname || '.' || rec.indexname, SQLERRM;
        END;
    END LOOP;
END $$;

-------------------------------------------------------------------------------------------

-- Check tablespace data
SELECT n.nspname AS schemaname, 
			   c.relname AS tablename,
		       t.spcname AS tablespace
		FROM pg_tables p
		JOIN pg_class c ON p.tablename = c.relname
		JOIN pg_namespace n ON c.relnamespace = n.oid
		LEFT JOIN pg_tablespace t ON c.reltablespace = t.oid
		WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')


-- Check tablespace index
SELECT i.schemaname,
		   i.indexname,
		   t.spcname AS tablespace
	FROM pg_indexes i
	JOIN pg_class c ON i.indexname = c.relname
	LEFT JOIN pg_tablespace t ON c.reltablespace = t.oid
	WHERE i.schemaname NOT IN ('pg_catalog', 'information_schema')

-------------------------------------------------------------------------------------------

-- Default Tablespace
SELECT datname, pg_tablespace.spcname 
FROM pg_database 
JOIN pg_tablespace ON pg_database.dattablespace = pg_tablespace.oid
WHERE datname = 'mydatabase';

-- Alter
ALTER DATABASE mydatabase SET TABLESPACE mytablespace;
	  
--------------------------------------------------------------------------------------						  
						  
-- Check for TABLESPACE for every table with their DEFAULT
SELECT 
    n.nspname AS schemaname, 
    c.relname AS tablename,
    CASE 
        WHEN c.reltablespace = 0 THEN 'DEFAULT (' || d.spcname || ')'  -- Default tablespace
        ELSE t.spcname  -- Specific tablespace set for the table
    END AS tablespace
FROM pg_class c
JOIN pg_namespace n ON c.relnamespace = n.oid
LEFT JOIN pg_tablespace t ON c.reltablespace = t.oid
LEFT JOIN pg_tablespace d ON d.oid = (SELECT dattablespace FROM pg_database WHERE datname = current_database())
WHERE c.relkind = 'r'  -- Only tables
AND n.nspname NOT IN ('pg_catalog', 'information_schema')
ORDER BY schemaname, tablename;

--------------------------------------------------------------------------------------

SELECT 
    spcname AS tablespace_name,
    pg_size_pretty(pg_tablespace_size(oid)) AS size
FROM 
    pg_tablespace
ORDER BY 
    pg_tablespace_size(oid) DESC;
