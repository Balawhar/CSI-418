
-- ###################### Postgres Tools & Extensions Installation ###################### --

To Install:

-- Pg-Pool II 			-- Managing Client Connections /  A middleware that provides connection pooling, load balancing, and failover management
-- Patroni 				-- Cluster Management / A high-availability solution for PostgreSQL based on etcd, Consul, or Zookeeper
-- index_advisor		 -- analyzes SQL queries that are executed in the database and provides recommendations for indexes that could improve performance
-- hypopg				 -- allows users to create hypothetical indexes, meaning you can simulate the presence of an index without actually creating it on disk
-- PgBouncer	1.16.1	 -- Set up Connection Pooling.
-- PostgREST	v10.1.1	 -- Instantly transform your database into an RESTful API.
-- WAL-G	    v2.0.1	 -- Tool for physical database backup and recovery.
-- repmgr 				 -- A tool for managing replication and failover
-- pg_auto_failover 	 --  An open-source tool for automatic failover and high availability.
-- pgModeler 			 -- A database modeler and design tool for PostgreSQL. It offers visual tools for creating ER diagrams and generating SQL scripts for database creation and modification
-- pgBackRest			 -- Backups and more .. 
-- Barman				 -- Backups
-- Nagios				 -- Monitoring +
-- Citus

**

-- ltree				 -- The ltree data type is used to represent hierarchical structure.
-- pgAudit	      1.7.0	 -- Generate highly compliant audit logs.
-- pgjwt	    commit	 -- Generate JSON Web Tokens (JWT) in Postgres.
-- gsql-http	  1.5.0	 -- HTTP client for Postgres. 
-- pg-safeupdate	1.4	 -- Protect your data from accidental updates or deletes.
-- wal2json	    commit	 -- JSON output plugin for logical replication decoding.
-- pg_stat_monitor 1.0.1 -- Query Performance Monitoring Tool for PostgreSQL
-- pg_partman
-- pg_repack
-- Sqitch
-- file_fdw
-- pgcrypto
-- pganalyze
-- pgAudit
-- PostgreSQL TDE
-- Talend
-- Pentaho
-- PgHero				 -- A performance dashboard for Postgres
-- pgRouting			 -- Similar to PostGIS ( Complementary )
-- Flyway   			 -- Used for Database and Schema Migrations 
-- SchemaSpy & and pgDoc -- Used for Doucmenting the meta-data of a database
-- lo					 -- Used for large object objects
-- bloom				 -- Used for indexing multiple columns

*********

Installed extensions:
pg_cron
PostGIS 
pg_stat_statements
postgres_fdw
fuzzystrmatch
citext
pg_trgm
dblink
tablefunc
pgBadger -- 79
system_stats -- 79
pgbench -- 79
amcheck -- 79

=======================================================================================

******* -- pg_cron  - Installed not configured 

-- pg_cron

-- Edit postgresql.conf to include:

cron.database_name = 'postgres'
shared_preload_libraries = 'pg_cron, pg_stat_statements'

sudo systemctl restart postgresql


******* 

******* 
-- Create it on database level 

CREATE EXTENSION pg_cron;

GRANT USAGE ON SCHEMA cron TO pgdba;

SELECT * FROM cron.job;

SELECT * FROM cron.job_run_details ORDER BY end_time DESC LIMIT 5;



CREATE USER pgcron WITH PASSWORD 'Pgcron@Valoores';



GRANT CONNECT ON DATABASE postgres TO pgcron;
-- Grant additional privileges as needed



# Allow local connections with password authentication
host    all             pgcron       127.0.0.1/32            md5


hostname:port:database:username:password


localhost:5432:postgres:pgcron:Pgcron@Valoores


chmod 600 /u01/pgsql/16/data/.pgpass


sudo systemctl restart postgresql-16


ls -ld /u01/pgsql/16/data/.pgpass



GRANT CONNECT ON DATABASE postgres TO pgcron;
GRANT USAGE ON SCHEMA public TO pgcron;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO pgcron;


GRANT USAGE ON SCHEMA cron TO pgcron;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA cron TO pgcron;



change location of :
ls -l ~/.pgpass




mv /u01/pgsql/16/data/.pgpass /u01/pgsql/.pgpass


ls -ld /u01/pgsql/.pgpass

chmod 600 /u01/pgsql/.pgpass


export PGPASSFILE=/u01/pgsql/.pgpass


sudo systemctl restart postgresql-16


psql -h localhost -U pgcron -d postgres


unset PGPASSFILE



******* 

*******
-- Second db
psql -U your_username -d db2
CREATE EXTENSION pg_cron;

-- Install dblink extension in vcisdb and db2 (if not already installed):
CREATE EXTENSION dblink;

SELECT dblink_connect('vcisdb_conn', 'host=mtbdb dbname=vcisdb user=pgdba password=Pgdba@2024');

CREATE OR REPLACE FUNCTION vcisdb_remote_job(sql_command text)
RETURNS void AS $$
BEGIN
    PERFORM dblink_exec('vcisdb_conn', sql_command);
END;
$$ LANGUAGE plpgsql;

SELECT cron.schedule(
    '*/5 * * * *',  -- Schedule (every 5 minutes in this example)
    $$SELECT run_job_on_second_db('INSERT INTO my_table VALUES (1, ''example'');')$$
);

SELECT dblink_disconnect('second_db_conn');
*******

=======================================================================================

******* -- postgres-fdw


select * from ssdx_eng.item_store_difusion_boh;


CREATE SERVER foreign_V21
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host '10.10.10.70', port '5432', dbname 'V21');

/*
CREATE USER MAPPING FOR pgdba
SERVER foreign_V21
OPTIONS (user 'pgdba', password 'Pgdba@2024');
*/
CREATE USER MAPPING FOR postgres
SERVER foreign_V21
OPTIONS (user 'pgdba', password 'Pgdba@2024');


IMPORT FOREIGN SCHEMA ssdx_eng
FROM SERVER foreign_V21
INTO ssdx_eng_f;


SELECT srvname
FROM pg_foreign_server;


SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'ssdx_eng_f';


GRANT USAGE ON FOREIGN SERVER foreign_v21 TO pgdba; -- on V21 server
GRANT USAGE ON FOREIGN SERVER foreign_testdb TO pgdba; -- on testdb server


***

-- Retrieve user mappings and details for the specified user
SELECT 
    pg_user_mapping.umuser AS "User ID",          -- ID of the local user
    pg_foreign_server.srvname AS "Foreign Server",-- Name of the foreign server
    pg_user_mapping.umoptions AS "Options"        -- Options used for user mapping
FROM 
    pg_user_mappings pg_user_mapping
JOIN 
    pg_foreign_server ON pg_user_mapping.srvid = pg_foreign_server.oid
WHERE 
    pg_user_mapping.umuser = (
        SELECT usesysid
        FROM pg_user
        WHERE usename = 'postgres'
    );

***

*******

=======================================================================================

******* -- fuzzystrmatch


CREATE SCHEMA custom_functions;


ALTER FUNCTION soundex(text) SET SCHEMA custom_functions;


CREATE EXTENSION fuzzystrmatch;


SELECT custom_functions.soundex('hello');



******* 

=======================================================================================

******* -- citext


CREATE EXTENSION citext;


CREATE TABLE sdedba.citext_test (
    id serial PRIMARY KEY,
    name citext
);


INSERT INTO example_table (name) VALUES
('Alice'),
('alice'),
('ALICE'),
('Bob');


SELECT * FROM example_table WHERE name = 'alice';


******* 

=======================================================================================

******* -- dblink


CREATE EXTENSION dblink;



SELECT dblink_connect('conn1', 'host=10.10.10.70 user=postgres password=Postgres@2024 dbname=V21');

SELECT * FROM dblink('conn1', 'SELECT city_id, city_name FROM sdedba.ref_com_city') AS t(city_id numeric, city_name char);

SELECT dblink_disconnect('conn1');



select * from sdedba.ref_com_city;

city_id
city_name



*******

=======================================================================================

******* -- tablefunc


CREATE EXTENSION tablefunc;


*******

=======================================================================================
PostGIS

CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology
 -- CREATE EXTENSION postgis_raster ( Not installed )

=======================================================================================

******* -- pg_agent  -- Not Installed

sudo dnf install -y pgagent_13

CREATE SCHEMA pgagent;
CREATE EXTENSION pgagent SCHEMA pgagent;

sudo vi /var/lib/pgsql/16/data/pg_hba.conf

host    all             all             127.0.0.1/32            md5
host    all             all             ::1/128                 md5

sudo systemctl restart postgresql-16

pgagent hostaddr=127.0.0.1 dbname=your_database user=your_username


*** -- Optional 
sudo vi /etc/systemd/system/pgagent.service


-- Add the following content to the service file:
[Unit]
Description=pgAgent Service
After=network.target

[Service]
Type=simple
User=postgres
ExecStart=/usr/bin/pgagent hostaddr=127.0.0.1 dbname=your_database user=your_username
Restart=always

[Install]
WantedBy=multi-user.target


sudo systemctl daemon-reload

*** -- Optional 


sudo systemctl enable pgagent
sudo systemctl start pgagent

=======================================================================================

******* -- pgBadger  on 79 still needs bash script automation

-- Installed here:
/usr/bin/pgbadger /usr/share/man/man1/pgbadger.1p.gz

-- Log Directory:
/u01/pgsql/16/data/log

-- Run it like this:
/usr/bin/pgbadger /u01/pgsql/16/data/log

-- Or
pgBadger /u01/pgsql/16/data/log

-- Direct it to a path
pgbadger /u01/pgsql/16/data/log -o /u01/pgsql/16/data/pgbadger_log

***
-- Make output directory 

sudo mkdir /u01/pgsql/16/data/pgbadger_log

sudo chown postgres:postgres /u01/pgsql/16/data/pgbadger_log

sudo chmod 700 /u01/pgsql/16/data/pgbadger_log

-- Check permission:
ls -ld /u01/pgsql/16/data/pgbadger_log


--
postgresql-Fri.log

-- Final Command
pgbadger --verbose /u01/pgsql/16/data/log/postgresql-Fri.log -o /u01/pgsql/16/data/pgbadger_log/pgbadger-Fri.html


pgbadger -- debug /u01/pgsql/16/data/log/postgresql-Fri.log -o /u01/pgsql/16/data/pgbadger_log/pgbadger-Fri.html

ls -lh /u01/pgsql/16/data/pgbadger_log/pgbadger-Fri.html


******

--rebuild

-f stderr

pgbadger --verbose /u01/pgsql/16/data/log/postgresql-Tue.log -o /u01/pgsql/16/data/pgbadger_log/pgbadger-Tue.html


pgbadger --verbose /u01/pgsql/16/data/log/postgresql-Tue.log -o /u01/pgsql/16/data/pgbadger_log/pgbadger-Tue.html


-- Bash Script

#!/bin/bash

# Configuration
LOG_DIR="/u01/pgsql/16/data/log"
REPORT_DIR="/path/to/reports"  # Replace with the path where you want to store reports
PGBADGER_PATH="/path/to/pgbadger"  # Replace with the path to your pgbadger executable

# Get the current day and calculate the previous day's date
DAY=$(date +%a)
YESTERDAY=$(date -d "yesterday" +%a)
REPORT_DATE=$(date -d "yesterday" +%Y-%m-%d)

# Check if today is Monday (to generate report for the last week)
if [[ "$DAY" == "Mon" ]]; then
    # Loop through the previous week (from Monday to Friday)
    for i in {1..5}; do
        DAY_NAME=$(date -d "$i days ago" +%a)
        LOG_FILE="${LOG_DIR}/postgresql-${DAY_NAME}.log"
        REPORT_FILE="${REPORT_DIR}/pgbadger-${REPORT_DATE}.html"

        # Generate the report
        if [[ -f "$LOG_FILE" ]]; then
            echo "Generating report for ${LOG_FILE}..."
            $PGBADGER_PATH -o "$REPORT_FILE" "$LOG_FILE"
        else
            echo "Log file ${LOG_FILE} does not exist."
        fi
    done
else
    # For other days, generate report only for the previous day
    LOG_FILE="${LOG_DIR}/postgresql-${YESTERDAY}.log"
    REPORT_FILE="${REPORT_DIR}/pgbadger-${REPORT_DATE}.html"

    # Generate the report
    if [[ -f "$LOG_FILE" ]]; then
        echo "Generating report for ${LOG_FILE}..."
        $PGBADGER_PATH -o "$REPORT_FILE" "$LOG_FILE"
    else
        echo "Log file ${LOG_FILE} does not exist."
    fi
fi


'**

chmod +x /path/to/pgbadger_daily.sh


0 1 * * 1-5 /path/to/pgbadger_daily.sh


=======================================================================================
******* -- system_stats on 79

module_pathname = '/u01/pgsql/system_stats-3.0/system_stats.so'

-- Apply it in here ( change module_pathname )
# system_stats.control
comment = 'System Stats extension'
default_version = '3.0'
module_pathname = module_pathname = '/u01/pgsql/system_stats-3.0/system_stats.so'

-- 3 files should be present in both directories of /u01 and /usr
/u01/pgsql/system_stats-3.0 :

system_stats.control
system_stats.so
system_stats--3.0.sql

*

/usr/pgsql-16 :

/usr/pgsql-16/share/extension/system_stats.control

/usr/pgsql-16/lib/system_stats.so

/usr/pgsql-16/share/extension/system_stats--3.0.sql

*
-- if needed copy them where not found
sudo cp /u01/pgsql/system_stats-3.0/system_stats.control /usr/pgsql-16/share/extension/

sudo cp /u01/pgsql/system_stats-3.0/system_stats.so /usr/pgsql-16/lib/
--
sudo cp /u01/pgsql/system_stats-3.0/system_stats--3.0.sql /usr/pgsql-16/share/extension/

*
-- then verify and reinstall:
cd /u01/pgsql/system_stats-3.0
make clean
make
sudo make install
*
sudo systemctl restart postgresql-16
*
CREATE EXTENSION system_stats;
*
=======================================================================================
******* amcheck -- on 79 -- Postgres

CREATE EXTENSION amcheck;

**
-- check for all functions of amcheck 
SELECT n.nspname AS "Schema",
       p.proname AS "Function"
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE p.proname LIKE '%bt_index_check%'
   OR p.proname LIKE '%verify_heapam%'
   OR p.proname LIKE '%bt_index_parent_check%';
   
**  

SELECT n.nspname AS "Schema",
       p.proname AS "Function"
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'amcheck';

**

SELECT amcheck.check_index('cron_test_pkey');

SELECT
    indexname AS index_name,
    tablename AS table_name,
    indexdef AS index_definition
FROM
    pg_indexes

**

SET client_min_messages = DEBUG5;

RESET client_min_messages;

**
-- To know what type the function takes
SELECT proname, proargtypes
FROM pg_proc
WHERE proname = 'bt_index_check';

*
-- To know the types of each function from above
SELECT oid, typname
FROM pg_type
WHERE oid IN (2205, 16);

**

SELECT bt_index_check(index_oid);

SELECT bt_index_check(index_oid);

bt_index_parent_check
verify_heapam

bt_index_parent_check



**

-- Checks all indexes at once 
SELECT bt_index_check(indexrelid)
FROM pg_index
JOIN pg_class ON pg_index.indexrelid = pg_class.oid
JOIN pg_am ON pg_class.relam = pg_am.oid
WHERE pg_am.amname = 'btree';

***

pg_amcheck --verbose mydatabase > amcheck_output.log 2>&1

pg_amcheck --index 12345 mydatabase > amcheck_output.log 2>&1

pg_amcheck --table mytable mydatabase > amcheck_output.log 2>&1


****

CREATE OR REPLACE FUNCTION get_btree_indexes()
RETURNS TABLE (
    index_oid oid,
    table_oid oid,
    index_name text,
    table_name text
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        i.oid AS index_oid,
        t.oid AS table_oid,
        i.relname AS index_name,
        t.relname AS table_name
    FROM 
        pg_class i
    JOIN 
        pg_index idx ON i.oid = idx.indexrelid
    JOIN 
        pg_class t ON idx.indrelid = t.oid
    JOIN 
        pg_am a ON i.relam = a.oid
    WHERE 
        a.amname = 'btree'
    ORDER BY 
        index_oid;
END;
$$ LANGUAGE plpgsql;

**

SELECT * FROM get_btree_indexes();

****

-- Check if it is a b-tree
SELECT 
    i.oid AS index_oid,
    i.relname AS index_name,
    a.amname AS index_type
FROM 
    pg_class i
JOIN 
    pg_index idx ON i.oid = idx.indexrelid
JOIN 
    pg_am a ON i.relam = a.oid
WHERE 
    i.oid = 37061;


=======================================================================================

** -- pgAgent


-- from source 


wget https://github.com/pgadmin-org/pgagent/archive/refs/tags/pgagent-4.2.2.tar.gz

-- /u01/pgsql/16/data/pgagent-4.2.2.tar.gz /u01/pgsql/16/data/pgagent/pgagent-4.2.2.tar.gz

sudo mv /u01/pgsql/16/data/pgagent-4.2.2.tar.gz /u01/pgsql/16/data/pgagent/pgagent-4.2.2.tar.gz


tar -xzf pgagent-4.2.2.tar.gz
cd pgagent-pgagent-4.2.2

./configure

./configure --with-pgconfig=/usr/pgsql-16/bin/pg_config

make

sudo make install


psql -U postgres -d your_database -f /path/to/pgagent/sql/pgagent-4.2.2/pgagent.sql


sudo mkdir -p /usr/local/pgagent


/usr/share/pgagent_16-4.2.2/pgagent.sql


sudo mv /path/to/pgagent.conf /usr/local/etc/pgagent.conf


-- /usr/pgsql-16/share/extension

-- /u01/pgsql/16/data/pgagent

-- /usr/local/bin/pgagent-pgagent-4.2.2

sudo cp -r /u01/pgsql/16/data/pgagent/pgagent-pgagent-4.2.2 /usr/local/bin/pgagent-pgagent-4.2.2


/usr/share/pgagent_16-4.2.2/

-- /usr/local/bin/pgagent-pgagent-4.2.2/build

# If there is a CMake configuration
sudo mkdir build
cd build
sudo dnf install cmake
cmake --version

cmake ..
make
sudo make install


sudo mv /u01/pgsql/16/data/pgagent-pgagent-4.2.2 /usr/local/bin/pgagent-pgagent-4.2.2

sudo find /usr/ -name "boost" -type d

ls /usr/include/boost
ls /usr/local/include/boost


sudo dnf list installed boost-devel

sudo dnf module list postgresql

sudo dnf module info postgresql

sudo dnf module list

sudo dnf install boost-devel -- done



-- /usr/local/bin/pgagent-pgagent-4.2.2/sql/pgagent.* 
-- /usr/local/bin/pgagent-pgagent-4.2.2/pgagent.control.in

sudo mv /usr/local/bin/pgagent-pgagent-4.2.2/pgagent.control.in /usr/pgsql-16/share/extension/
sudo mv /usr/local/bin/pgagent-pgagent-4.2.2/sql/pgagent-*  /usr/pgsql-16/share/extension/

sudo rm -r /usr/local/bin/pgagent-pgagent-4.2.2/sql


/usr/local/bin/

ls /usr/pgsql-16/bin/
ls /usr/local/bin/


pgagent.control 
pgagent.sql


******************** 

-- /etc/systemd/system

sudo touch /etc/systemd/system/pgagent.service

sudo vi /etc/systemd/system/pgagent.service

-- Put this:
[Unit]
Description=pgAgent - PostgreSQL Job Scheduler
After=network.target

[Service]
Type=simple
User=postgres
ExecStart=/usr/local/bin/pgagent -f -l 0 "host=localhost dbname=testdb79 user=postgres"
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target

--
**
/etc/systemd/system/pgagent.service
**

-- sudo systemctl daemon-reload

sudo systemctl enable pgagent

sudo systemctl start pgagent

sudo systemctl restart pgagent

sudo systemctl status pgagent


**** --  do this if needed --
sudo systemctl restart pgagent.service
sudo systemctl status pgagent.service
**** -- 


********************************* -- Testing pgagent -- *******

SELECT * FROM  pgagent.pga_job

SELECT * FROM pgagent.pga_jobclass

SELECT * FROM pgagent.pga_schedule


CREATE TABLE test_table (
    id SERIAL PRIMARY KEY,
    test_col VARCHAR(50)
);


SELECT * FROM  pgagent.pga_job

INSERT INTO pgagent.pga_job (jobjclid, jobname, jobdesc, jobenabled)
VALUES (
	6,
    'Test Job',
    'A simple job that inserts data into test_table',
    true
);


SELECT *
FROM pg_constraint 
WHERE conname = 'pga_jobstep_check';

select * from 
pgagent.pga_jobstep


INSERT INTO pgagent.pga_jobstep (
    jstjobid, 
    jstname, 
    jstdesc, 
    jstkind, 
    jstcode,
    jstdbname,    -- Ensure this is set correctly
    jstenabled
) VALUES (
    3, 			-- the jobid of your job currently running
    'Insert Step', 
    'Step to insert data into test_table',
    's',  
    'INSERT INTO test_table (test_col) VALUES (''Hello from pgAgent'');',
    'testdb79',  -- Replace with your actual database name
    true  -- Set to true to enable the step
);



**

CREATE TABLE pgagent.pga_schedule_job (
    sjsjobid INTEGER NOT NULL,
    sjsschid INTEGER NOT NULL
);

CREATE OR REPLACE FUNCTION pgagent.pga_run_job(jobid INT)
RETURNS VOID AS $$
BEGIN
    -- Call the internal pgAgent function to execute a job
    PERFORM pgagent.pga_run_job_internal(jobid);
END;
$$ LANGUAGE plpgsql


**

SELECT proname, proargtypes, prosrc
FROM pg_proc
WHERE proname = 'pga_run_job_internal';



CREATE OR REPLACE FUNCTION pgagent.pga_run_job_internal(jobid INT)
RETURNS VOID AS $$
BEGIN
    -- Placeholder for the actual job running logic
    RAISE NOTICE 'Running job with ID %', jobid;
END;
$$ LANGUAGE plpgsql;

**

SELECT pgagent.pga_run_job(3);





-- Step 3: Create the schedule for the job
INSERT INTO pgagent.pga_schedule (jscjobid, jscname, jscdesc)
VALUES (3, 'Every Minute', 'Run every minute');   
-- the jobid of your job currently running


-- Step 4: Attach the schedule to the job
INSERT INTO pgagent.pga_schedule_job (sjsjobid, sjsschid)
VALUES (1, 1);




SELECT tablename
FROM pg_tables
WHERE schemaname = 'pgagent';



-- INSERT INTO pgagent.pga_jobclass (jclname, jcldesc)
-- VALUES ('Default Class', 'A default job class');




SELECT * FROM test_table;



-- DELETE FROM pgagent.pga_job WHERE jobid = 2;



SELECT * FROM pgagent.pga_joblog WHERE jlgjobid = 1;


******************************************************************************************





sudo dnf install pgbackrest




[global]
repo1-path=/var/lib/pgbackrest
repo1-retention-full=2
log-level-console=info
log-level-file=info
log-path=/var/log/pgbackrest

[mydb]
pg1-path=/u01/pgsql/16/data



/etc/pgbackrest.conf


/u01/pgsql/16/data


sudo pgbackrest --stanza=mydb stanza-create

sudo pgbackrest --stanza=mydb --type=full backup


/u01/pgsql


[global]
repo1-path=/var/lib/pgbackrest
repo1-retention-full=2
log-level-console=info
log-level-file=info
log-path=/var/log/pgbackrest
pg1-path=/u01/pgsql
pg1-port=5432
pg1-user=postgres



export PGUSER=postgres
export PGPASSWORD='Postgres@2024'
export PGHOST=localhost
export PGPORT=5432


sudo pgbackrest info


sudo tail -n 50 /var/log/pgbackrest/mydb-stanza-create.log

mydb-backup.log
mydb-stanza-create.log
mydb-start.log

archive_mode = on

archive_command = 'pgbackrest --stanza=mydb archive-push %p'


sudo systemctl reload postgresql-16

sudo pgbackrest --stanza=mydb start


/u01/pgsql/16/data/pg_wal

-- /var/lib/pgsql/16/data/pg_wal

SHOW data_directory;

pgbackrest --stanza=mydb archive-push /u01/pgsql/16/data/pg_wal


ls -ld /tmp/pgbackrest/
ls -l /tmp/pgbackrest/mydb.stop


sudo chown postgres:postgres /tmp/pgbackrest/ -R
sudo chmod 700 /tmp/pgbackrest/


-- sudo rm -f /tmp/pgbackrest/mydb.stop


sudo -u postgres pgbackrest --stanza=mydb archive-push /u01/pgsql/16/data/pg_wal/0000000100000006000000A3


archive_timeout = 300s


sudo chown -R postgres:postgres /var/lib/pgbackrest
sudo chmod -R 700 /var/lib/pgbackrest


ls -ld /var/lib/pgbackrest
ls -l /tmp/pgbackrest/mydb.stop


-rw-r-----. 1 root root 372 Sep 13 13:52 /var/lib/pgbackrest/backup/mydb/backup.info
-rw-r-----. 1 root root 255 Sep 13 13:52 /var/lib/pgbackrest/archive/mydb/archive.info


sudo chown postgres:postgres /var/lib/pgbackrest/archive/mydb/archive.info
sudo chmod 600 /var/lib/pgbackrest/archive/mydb/archive.info


sudo chown postgres:postgres /var/lib/pgbackrest/archive/mydb/archive.info
sudo chmod 600 /var/lib/pgbackrest/archive/mydb/archive.info


/var/lib/pgbackrest/archive/mydb

sudo find /var/lib/pgbackrest -exec ls -ld {} \;


sudo chown postgres:postgres /var/lib/pgbackrest/archive/mydb


sudo chown postgres:postgres /var/lib/pgbackrest/archive


drwxr-x---. 3 root root 18 Sep 13 13:52 /var/lib/pgbackrest/backup
drwxr-x---. 2 root root 49 Sep 13 13:52 /var/lib/pgbackrest/backup/mydb
-rw-r-----. 1 root root 372 Sep 13 13:52 /var/lib/pgbackrest/backup/mydb/backup.info


sudo chown postgres:postgres /var/lib/pgbackrest/backup

sudo chown postgres:postgres /var/lib/pgbackrest/backup/mydb

sudo chown postgres:postgres /var/lib/pgbackrest/backup/mydb/backup.info

sudo chown postgres:postgres /var/lib/pgbackrest/backup/mydb/backup.info

sudo chown postgres:postgres /var/lib/pgbackrest/backup/mydb/backup.info.copy

sudo chown postgres:postgres /var/lib/pgbackrest/backup/mydb/20240913-170822F

sudo chown postgres:postgres /var/lib/pgbackrest/backup/mydb/backup.history


sudo -u postgres pgbackrest --stanza=mydb archive-push /u01/pgsql/16/data/pg_wal/0000000100000006000000A3


*******

-- Restore backup from pgbackrest

sudo systemctl stop postgresql-16


sudo rm -rf /u01/pgsql/16/data/

sudo -u postgres pgbackrest --stanza=mydb --log-level-console=info restore

pgbackrest --stanza=your_stanza_name restore

sudo systemctl start postgresql-16

sudo -u postgres psql -c "SELECT pg_is_in_recovery();"

-- List owner and permission of all sub directories and files
sudo find /var/lib/pgbackrest/backup/mydb -exec ls -ld {} \;

-- Change all sub directories and files owner
sudo chown -R postgres:postgres /var/lib/pgbackrest/backup/mydb



/var/lib/pgbackrest/backup/mydb


/var/lib/pgbackrest/backup/mydb/20240913-170822F


-- delta will only overwrite the changed data in the restore 
sudo -u postgres pgbackrest --stanza=mydb --log-level-console=info --delta restore

sudo -u postgres pgbackrest --stanza=mydb --log-level-console=info restore


sudo rm -rf /u01/pgsql/vcis_data/PG_16_202307071

sudo rm -rf /u01/pgsql/16/data/

sudo rm -rf /u01/pgsql/vcis_index/PG_16_202307071


ls /u01/pgsql/16/data/pg_hba.conf
ls /u01/pgsql/16/data/postgresql.conf
ls /u01/pgsql/16/data/PG_VERSION


tail -f postgresql-Mon.log


ls -l /u01/pgsql/16/data/backup_label

ls -l /u01/pgsql/16/data/recovery.signal




ls -l /var/lib/pgsql/16/data/global/pg_control


sudo chown postgres:postgres /var/lib/pgsql/16/data/global/pg_control
sudo chmod 0600 /var/lib/pgsql/16/data/global/pg_control



sudo systemctl reload postgresql-16


sudo journalctl -xe


sudo journalctl -u postgresql-16.service



sudo -u postgres /usr/pgsql-16/bin/initdb -D /u01/pgsql/16/data


/usr/pgsql-16/bin/pg_ctl -D /u01/pgsql/16/data -l logfile start


/usr/pgsql-16/bin/pg_ctl -D /u01/pgsql/16/data -l /path/to/logfile start


/u01/pgsql/16/data/pg_log

/var/lib/pgbackrest/backup/mydb/20240913-170822F/pg_data/pg_log


sudo systemctl status postgresql-16


/var/lib/pgbackrest/backup/mydb/20240913-170822F


/usr/pgsql-16/bin/pg_ctl -D /u01/pgsql/16/data -l /u01/pgsql/16/data/logfile start


sudo systemctl status postgresql-16.service



/usr/lib/systemd/system/postgresql-16.service

/etc/systemd/system/postgresql-16.service


/etc/systemd/system/multi-user.target.wants/postgresql-16.service

-- this is used
/usr/lib/systemd/system/postgresql-16.service


sudo systemctl daemon-reload
sudo systemctl restart postgresql-16.service


journalctl -u postgresql-16.service


sudo ls -ld /var/log/pgbackrest /u01/pgsql/16/data/log/postgresql


sudo -u postgres /usr/pgsql-16/bin/pg_ctl -D /u01/pgsql/16/data -l /u01/pgsql/16/data/log/postgresql.log start


sudo systemctl start postgresql-16




Sep 16 11:49:27 v21-2.localdomain systemd[1]: Failed to start PostgreSQL 16 database server.
Sep 16 13:26:34 v21-2.localdomain systemd[1]: Starting PostgreSQL 16 database server...
Sep 16 13:26:34 v21-2.localdomain postgres[1434604]: 2024-09-16 13:26:34.565 EEST [1434604] FATAL:  lock file "postmaster.pid" already exists



sudo systemctl restart postgresql-16.service


/usr/local/bin/pgagent


sudo kill 1441639

1441639



sudo -u postgres /usr/pgsql-16/bin/pg_ctl -D /u01/pgsql/16/data -l /u01/pgsql/16/data/log/postgresql.log start

postgresql.log

sudo rm /u01/pgsql/16/data/postmaster.pid



tail -n 100 /u01/pgsql/16/data/log/postgresql.log


postgresql.log


cat /u01/pgsql/16/data/postmaster.opts




-- Manual Start -- + where to start + where to log
sudo -u postgres /usr/pgsql-16/bin/pg_ctl -D /u01/pgsql/16/data -l /u01/pgsql/16/data/log/manual-start.log start


sudo systemctl status postgresql-16


sudo systemctl status postgresql-16.service


sudo journalctl -u postgresql-16.service


tail -f postgresql-Mon.log


ALTER USER postgres PASSWORD 'Postgres@2024';


sudo -u postgres pgbackrest --stanza=mydb --log-level-console=info restore

pgbackrest --stanza=your_stanza_name restore



pgbackrest --stanza=mydb info

sudo systemctl stop postgresql-16.service

sudo -u postgres pgbackrest --stanza=mydb --pg1-path=/u01/pgsql/16/data restore

sudo systemctl start postgresql-16.service


/var/lib/pgbackrest/archive/mydb/archive.info

/var/lib/pgbackrest/archive/mydb/archive.info.copy

sudo chown -R postgres:postgres /var/lib/pgbackrest/archive/mydb


sudo rm -rf /u01/pgsql/vcis_data/PG_16_202307071

sudo rm -rf /u01/pgsql/16/data/

sudo rm -rf /u01/pgsql/vcis_index/PG_16_202307071


sudo systemctl start postgresql-16.service



sudo -u postgres pgbackrest --stanza=mydb --pg1-path=/u01/pgsql/16/data restore


******************************************************************************************
 