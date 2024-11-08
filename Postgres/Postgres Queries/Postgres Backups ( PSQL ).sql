-- Pgdba@2024
-- export PGPASSWORD='Postgres@2024'
-- cat ../pg_dbs_backup.sh
-- psql (PostgreSQL) 17.0 (Ubuntu 17.0-1.pgdg24.04+1)
-- sudo apt install ( for installations )
-- SELECT pg_reload_conf();
-- which pg_config
-- /u01/pgsql/17/data
-- /u01/pgsql/17/data/postgresql.conf


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

--	Sessions on a Database

SELECT * FROM pg_stat_activity WHERE datname = 'VFDS_DEV';

-- Kill all Sessions

SELECT 
    pg_terminate_backend(pid)	  -- Terminate 1 PID
FROM 
    pg_stat_activity
WHERE 
    datname = 'vdpsdb'
    AND pid <> pg_backend_pid();  -- Exclude the current session

---------------------------------------------------------------------------------------------

-- Connect to PostgreSQL with postgres user ( plpgSQL ) --------------------------------

psql -U postgres -d testdb2  

=============================================================================================

-- BACKUP ------------------------------------------------------------------------------

-- Single Backup ( Dump )

-- Backup Compressed SQL format with (-F c)
pg_dump -U postgres -h 10.10.10.70 -d testdb2 -F c -b -v -f /u01/pgsql/test_backups/testdb2_29052024_bck.sql

=============================================================================================

-- VERIFY DUMP ------------------------------------------------------------------------------

-- Verify all
pg_restore -l /u01/pgsql/testbackups/bkp_vfds_dev_172.31.13.89_23102024_220001.dmp

-- Verify one table ( exists )
pg_restore -l /u01/pgsql/testbackups/bkp_vfds_dev_172.31.13.89_23102024_220001.dmp | grep "car_info"

=============================================================================================

-- RESTORE from DUMP ------------------------------------------------------------------------

-- Single Database Restore from a tar.gz backup ( after uncompressing ) ----------------
-- dont forget to export password first
pg_restore -U postgres -h 172.31.13.89 -d testdb -v bkp_V21_10.10.10.70_10072024_223001.dmp

-- Clean database - drop objects then create
PGPASSWORD="postgres" pg_restore --clean -U postgres -h 172.31.13.89 -d testdb -v /u01/pgsql/testbackups/bkp_vfds_dev_172.31.13.89_23102024_220001.dmp

-- Restore Table Full ( DDL and data )
PGPASSWORD="postgres" pg_restore -U postgres -h 172.31.13.89 -d testdb --table=car_info -v /u01/pgsql/testbackups/bkp_vfds_dev_172.31.13.89_23102024_220001.dmp

-- Restore Table ( Data-only ) ( Table should be created )
PGPASSWORD="postgres" pg_restore --data-only -U postgres -h 172.31.13.89 -d testdb --table=car_info /u01/pgsql/testbackups/bkp_vfds_dev_172.31.13.89_23102024_220001.dmp

=============================================================================================

-- EXTRACT Dump to SQL

-- Extract Table Full ( DDL + DML )
PGPASSWORD="postgres" pg_restore -U postgres -h 172.31.13.89 --schema="isodba" --table="iso_country" -f iso_country.sql /u01/pgsql/testbackups/bkp_vfds_dev_172.31.13.89_23102024_220001.dmp

-- Extract Table Schema only ( DDL ) - into SQL format
PGPASSWORD="postgres" pg_restore -U postgres -h 172.31.13.89 --schema="isodba" --table="iso_country" --schema-only -f iso_country_schema.sql /u01/pgsql/testbackups/bkp_vfds_dev_172.31.13.89_23102024_220001.dmp

-- Extract Whole Schema ( DDL / Schema only ) into SQL format
PGPASSWORD="postgres" pg_restore -U postgres -h 172.31.13.89 --schema=anldba --schema-only -f anldba_schema.sql /u01/pgsql/testbackups/bkp_vfds_dev_172.31.13.89_23102024_220001.dmp

-- Transform whole dump into SQL format
PGPASSWORD="postgres" pg_restore -U postgres -h 172.31.13.89 -f full_dump.sql /u01/pgsql/testbackups/bkp_vfds_dev_172.31.13.89_23102024_220001.dmp

-- Transform whole dump into SQL format ( data-only )
PGPASSWORD="postgres" pg_restore -U postgres -h 172.31.13.89 --data-only -f dump2.sql /u01/pgsql/testbackups/bkp_vfds_dev_172.31.13.89_23102024_220001.dmp

=============================================================================================

-- RESTORE from SQL format ------------------------------------------------------------------

-- Restore from SQL - TABLE or WHOLE - Without ON_ERROR
PGPASSWORD="postgres" psql -U postgres -h 172.31.13.89 -d testdb -f /u01/pgsql/testbackups/full_dump.sql -v

-- Restore from SQL - TABLE or WHOLE - With ON_ERROR
PGPASSWORD="postgres" psql -U postgres -h 172.31.13.89 -d testdb -f /u01/pgsql/testbackups/car_info.sql -v ON_ERROR_STOP=1

-- Extract Table or Function from SQL format
grep -A 10 "CREATE TABLE public.car_info" full_dump.sql > car_info.sql

-- Restore table data-only ( PSQL )
PGPASSWORD="postgres" psql -U postgres -h 172.31.13.89 -d testdb
\i /u01/pgsql/testbackups/car_info.sql

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
