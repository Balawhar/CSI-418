
export ORACLE_SID=cdb19c       -- cdb19c  is the an ex of the name of the your container
-- cd /u01/Backup/
sqlplus / as sysdba

alter system set audit_trail=none scope=spfile;
alter system set db_files=3000 scope=spfile;
---------------------------------------------------------------- stopped here
shut immediate
startup upgrade
----------------------------------------------------------------
alter system set MAX_STRING_SIZE='EXTENDED' SCOPE=BOTH;
@?/rdbms/admin/utl32k.sql

shut immediate
startup
show parameter max_string

CREATE OR REPLACE DIRECTORY "DBPUMP" as '/u01/Backup';
GRANT read,write on DIRECTORY "DBPUMP" to public;

-- Create tbs...

-- refresh sys and system..

-- import
--EXCLUDE=SCHEMA:\"IN \(\'SSDX_TMP\'\)\" \

nohup impdp system/system19_DB_uhddev@uhddev \
directory=DBPUMP full=y table_exists_action=replace \
dumpfile=111_uhdtest_20240209_233001_%U \
logfile=imp_uhddev.log &

-- refresh users
spool uhddev_refresh_users.sql;
set pagesize 1000;
select 'alter user '||username||' identified by '||lower(username)||' account unlock;' 
from dba_users where username not in ('SYS','SYSTEM');
spool off;

-- grants
GRANT EXECUTE ON SYS.DBMS_LOCK TO PUBLIC;
GRANT EXECUTE ON SYS.DBMS_ALERT TO PUBLIC;

-- recompile invalid objects
@?/rdbms/admin/utlrp.sql

