-- Start --

export ORACLE_SID=mafdev6
cd /u01/Backup/
sqlplus / as sysdba

alter system set audit_trail=none scope=spfile;
alter system set db_files=2000 scope=spfile;
alter system set processes=1000 scope=spfile;
alter system set open_cursors=1000 scope=spfile;
alter system set pga_aggregate_target=1000M scope=spfile;
alter system set sga_target=1000M scope=spfile;

shut immediate
startup

CREATE OR REPLACE DIRECTORY "DBPUMP" as '/u01/Backup';
GRANT read,write on DIRECTORY "DBPUMP" to public;

-- Create tbs --
@tbs

-- refresh sys and system..
-- alter user sys identified by sys11_DB_mafdev6 account unlock;
-- alter user system identified by system11_DB_mafdev6 account unlock;
@refresh_sys

-- exit SQL --
exit

-- import ------------------------

nohup impdp system/system11_DB_mafdev6@mafdev6 \
directory=DBPUMP full=y table_exists_action=replace \
dumpfile=1068_mafdev6_020823_221522.dmp \
EXCLUDE=SCHEMA:\"IN \(\'SSDX_TMP\'\)\" \
logfile=imp_mafdev6.log &

-----------------------------------

-- make sure you are in u01/Backup/
cd /u01/Backup/
sqlplus / as sysdba

-- refresh users

spool mafdev6_refresh_users.sql;
set pagesize 1000;
select 'alter user '||username||' identified by '||lower(username)||' account unlock;'
from dba_users where username not in ('SYS','SYSTEM');
spool off;

exit
-- refresh file in WinSCP
sqlplus
@refresh_users

-- grants
GRANT EXECUTE ON SYS.DBMS_LOCK TO PUBLIC;
GRANT EXECUTE ON SYS.DBMS_ALERT TO PUBLIC;

-- recompile invalid objects
@?/rdbms/admin/utlrp.sql

-- Finish