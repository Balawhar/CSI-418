-- Non-Pluggable DB

export ORACLE_SID=blfdev

sqlplus / as sysdba
show parameter db_name  -- in sqlplus to show the DB im in

/*
ps -ef | grep pmon		-- to list DB's
cat /etc/oratab			-- to list the Databases
*/

--------------------------------------------------
-- For Pluggable DB

sqlplus / as sysdba
show pdbs								   
alter session set container = blfdev;
    
--------------------------------------------------

-- If restart is needed
shut IMMEDIATE
-- shut abort is used if DB is unresponsive for shut IMMEDIATE
-- then
startup
 