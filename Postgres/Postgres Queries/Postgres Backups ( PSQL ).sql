-- Pgdba@2024
-- export PGPASSWORD='Postgres@2024'
-- cat ../pg_dbs_backup.sh
-- RedHat Linux 8.9
-- PostgreSQL 16.3							-- @pgdg16 ( Module )
-- sudo dnf install ( for installations )
-- SELECT pg_reload_conf();
-- which pg_config

-- ############################## Postgres Backups ############################### --

-- Create Database --------------------------------------------------------------------
CREATE DATABASE mtbdb
    WITH
    OWNER = pgdba
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = vcis_data
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- Terminate All Connections on a Database --------------------------------------------
SELECT
  pg_terminate_backend(pid)
FROM
  pg_stat_activity
WHERE
  datname = 'testdb'
  AND pid <> pg_backend_pid();

--	Sessions on a Database

SELECT * FROM pg_stat_activity WHERE datname = 'DUMP_VDPS';

-- Connect to PostgreSQL with postgres user ( plpgSQL ) --------------------------------

psql -U postgres -d testdb2  

=============================================================================================
-- BACKUP ------------------------------------------------------------------------------

-- Single Backup ( Dump )

-- Backup Compressed SQL format with (-F c)
pg_dump -U postgres -h 10.10.10.70 -d testdb2 -F c -b -v -f /u01/pgsql/test_backups/testdb2_29052024_bck.sql

=============================================================================================
-- RESTORE -----------------------------------------------------------------------------

-- Single Database Restore from a tar.gz backup ( after uncompressing ) ----------------
-- dont forget to export password first

pg_restore -U postgres -h 10.10.10.70 -d testdb -v bkp_V21_10.10.10.70_10072024_223001.dmp

----------------------------------------------------------------------------------------
-- Single Database Restore from a SQL backup
export PGUSER='postgres'
export PGPASSWORD='Postgres@2024'
export PGDATABASE='multimedia'
psql -f clean_multimedia_bck.sql

----------------------------------------------------------------------------------------

-- Restore Compressed Single Backup ----------------------------------------------------
pg_restore -U postgres -h 10.10.10.70 -d testdb -v /u01/pgsql/test_backups/backup_bck.sql

----------------------------------------------------------------------

-- Single table restore can be done by doing a : Delete ( Cascade ) to the table that you want to restore then doing a restore dump to the database :
pg_restore -U postgres -h 10.10.10.70 -d V21 -v bkp_V21_10.10.10.70_10072024_223001.dmp

=============================================================================================
-- OTHERS -----------------------------------------------------------------------------------

-- Query from outside pgsql ( formatted in organized way )

psql -U postgres -d V21 -c "SELECT * FROM sdedba.ref_com_country;" -t -A

----------------------------------------------------------------------
-- Query from outside pgsql ( formatted in more sophisticated and organized way ) 

psql -U postgres -d V21 -c "\x on" -c "SELECT * FROM sdedba.ref_com_country;"

=============================================================================================

-- Restart postgresql Service
sudo systemctl restart postgresql
-----------------------------------------------------------------------------------------
setfacl -m u:username:w /u01/pgsql/test_backups  
-- This setup ensures that the directory is accessible only to the owner and the specified user with write-only permission.

-----------------------------------------------------------------------------------------
-- Crontab
0 2 * * * /usr/bin/pg_dump -U postgres -h localhost -d mydatabase -F c -b -v -f /path/to/backup/mydatabase_$(date +\%Y\%m\%d).backup
=============================================================================================
-- Example: Resetting login attempts or other conditions (if implemented via custom mechanisms).
UPDATE pg_authid SET rolcanlogin = TRUE WHERE rolname = 'suitedba';
--------------------
-- To unlock the account, you can reset the password expiration.
ALTER ROLE suitedba VALID UNTIL 'infinity';
=============================================================================================

-- Check for TABLESPACE for every table that is null / not null
		  SELECT n.nspname AS schemaname, 
       c.relname AS tablename,
       COALESCE(t.spcname, (SELECT spcname 
                            FROM pg_tablespace 
                            WHERE oid = (SELECT dattablespace 
                                         FROM pg_database 
                                         WHERE datname = current_database())
                           )) AS tablespace
FROM pg_tables p
JOIN pg_class c ON p.tablename = c.relname
JOIN pg_namespace n ON c.relnamespace = n.oid
LEFT JOIN pg_tablespace t ON c.reltablespace = t.oid
-- WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
  AND COALESCE(t.spcname, (SELECT spcname 
                           FROM pg_tablespace 
                           WHERE oid = (SELECT dattablespace 
                                        FROM pg_database 
                                        WHERE datname = current_database())
                          )) IS NOT NULL;
						  
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

-- Alter TABLESPACE of TABLES and INDEXES
DO $$
DECLARE
    table_tablespace TEXT := 'vdfs_data';
    index_tablespace TEXT := 'vdfs_index';
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
		WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')-- Exclude system schemas
    LOOP
        EXECUTE format('ALTER TABLE %I.%I SET TABLESPACE %I',
                        rec.schemaname, rec.tablename, table_tablespace);
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
        EXECUTE format('ALTER INDEX %I.%I SET TABLESPACE %I',
                        rec.schemaname, rec.indexname, index_tablespace);
    END LOOP;
END $$;

=============================================================================================

