
-- #########################             Debugging			################################## --

--**********************************      Server     *********************************************

-- SEARCH and FIND

-- Search ( Most Effecient )
find / -name "logfile" 2>/dev/null

To search for something:
- locate
- whereis
- find
- which

-- Logs

cd /var/log

sudo cat dmesg

sudo cat /var/log/kern.log
grep -i -E "error" /var/log/kern.log

sudo cat /var/log/syslog
grep -i -E "error" /var/log/syslog

--**********************************      Postgres     *********************************************

-- DEBUGGING 
SET client_min_messages = DEBUG1;  -- DEBUG5 ( more INFO ( from 1 to 5 ) )

-- RESET
RESET client_min_messages;

-- DEBUGGING via POWA
SET powa.debug = on;
SET powa.debug = off;

--*****************************************************************
-- LOGS

-- Postgres Logs
/u02/pgsql/17/data/pg_log/postgresql-2024-10-31_000000.log

grep -i -E "error" /u02/pgsql/17/data/pg_log/postgresql-2024-10-31_000000.log

grep -i -E "pg_cron|pg_stat_statements" /u02/pgsql/17/data/pg_log/postgresql-2024-10-31_000000.log

tail -f /u02/pgsql/17/data/pg_log/postgresql-2024-10-31_000000.log | grep -i -E "pg_cron|pg_stat_statements"

-- SELINUX log
tail -f /var/log/audit/audit.log

--
dmesg

sudo dmesg | tail -n 50

--*****************************************************************

-- List owner and permission of all sub directories and files
sudo find /var/lib/pgbackrest/backup/mydb -exec ls -ld {} \;

-- Check permission:
ls -ld /u01/pgsql/17/data/pg_amcheck

--*****************************************************************

-- Restart / Reload

sudo systemctl restart postgresql.service

sudo systemctl status postgresql.service

sudo systemctl reload postgresql.service

SELECT pg_reload_conf();

sudo systemctl daemon-reload

--*****************************************************************

-- list directory files from pgAdmin ( on server )
SELECT * FROM pg_ls_dir('/u01/pgsql/17/data');

-- Read a file from pgAdmin ( on server )
select pg_read_file('/u01/pgsql/17/data/postgresql.conf')

-- Check a file's stats from pgAdmin ( on server )
select pg_stat_file('/u01/pgsql/17/data/postgresql.conf')

-- Check settings
select * from pg_settings
where name = 'idle_in_transaction_session_timeout'


--*********************************     Cassandra 	*****************************************

-- Logs

-- on cassandra 110
/u01/cassandra/apache-cassandra-4.0.6/logs/system.log
grep "Starting listening for CQL clients" /u01/cassandra/apache-cassandra-4.0.6/logs/system.log | tail -1

-- on cassandra 93 / 94
/u01/cassandra/apache-cassandra-4.1.3/logs/system.log
grep "Starting listening for CQL clients" /u01/cassandra/apache-cassandra-4.1.3/logs/system.log | tail -1

-- on cassandra 116
/u01/cassandra/apache-cassandra-5.0.2/logs/system.log
grep "Starting listening for CQL clients" /u01/cassandra/apache-cassandra-5.0.2/logs/system.log | tail -1


--*********************************     Memory    	*****************************************

journalctl -k | grep -i "oom"
grep -i "oom" /var/log/syslog
grep -i "oom" /var/log/messages
dmesg | grep -i "memory"
dmesg | grep -i "oom"
last reboot