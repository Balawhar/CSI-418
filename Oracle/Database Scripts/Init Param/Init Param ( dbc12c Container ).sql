------------ This is done after DBCA to create a database ( Containe / Pluggable / PDBS ) ------------------------------------------------------

------------ done once no need to do it again.....

export ORACLE_SID=dbc12c       -- dbc12c  is the an ex of the name of the your container
cd /u01/Backup/
sqlplus / as sysdba

alter system set audit_trail=none scope=spfile;
alter system set db_files=5000 scope=spfile;

refresh sys/system (by Container)

-- should be like this in file:
-- alter user sys identified by sys11_DB_cvstrdts account unlock;
-- alter user system identified by system11_DB_cvstrdts account unlock;
-- then run this
@dbc12c_refresh_sys.sql

---------------------------------------------

-- start from here for next db...

--- before import ---

show pdbs
alter session set container = cvstrdts;      -- cvstrdts is an ex of dbname your working on

shut immediate
startup upgrade

alter system set MAX_STRING_SIZE='EXTENDED' SCOPE=BOTH;
@?/rdbms/admin/utl32k.sql

shut immediate
startup
show parameter max_string

alter session set container = cvstrdts;      	-- to make sure you are in the PDB cvstrdts ( the DB you want )
@cvstrdts_create_tbs.sql              			-- where you have already change the internals of that file to cvstrdts already or your dbname

alter user sys identified by sys11_DB_cvstrdts account unlock;
alter user system identified by system11_DB_cvstrdts account unlock;



CREATE OR REPLACE DIRECTORY "DBPUMP" as '/u01/Backup';
GRANT read,write on DIRECTORY "DBPUMP" to public;

-- exit SQL --
exit

------------------------------------------------------"

-- Import from OS
nohup impdp system/system11_DB_cvstrmts@cvstrmts \
directory=DBPUMP full=y table_exists_action=replace \
dumpfile=91_cvstrmts_16022024_212001.dmp \
EXCLUDE=SCHEMA:\"IN \(\'SSDX_TMP\'\)\" \
logfile=imp_cvstrmts.log &

------------------------------------------------------"
--- after import ---

sqlplus / as sysdba

-- refresh users
spool cvstrdts_refresh_users.sql;
select 'alter user '||username||' identified by '||lower(username)||' account unlock;' from dba_users
where username not in ('SYS','SYSTEM','XS$NULL');
spool off;

-- then clean the output file in winscp and keep the alters an save it in winscp then run it in moba:
alter session set container = cvstrdts; 
show pdbs;	-- make sure your are in the pluggable DB
@cvstrdts_refresh_users.sql

-- grants
GRANT EXECUTE ON SYS.DBMS_LOCK TO PUBLIC;
GRANT EXECUTE ON SYS.DBMS_ALERT TO PUBLIC;

-- recompile invalid objects
@?/rdbms/admin/utlrp.sql

-- Finish
