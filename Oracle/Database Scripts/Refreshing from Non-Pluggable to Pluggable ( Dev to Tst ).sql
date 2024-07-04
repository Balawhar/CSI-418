=====================================================================================================
-- Refreshing database from dev to test ( from Non-Pluggable to Pluggable by deleting and recreating the pluggable database
=====================================================================================================
-- Remote 10.1.10.164
export ORACLE_SID=mtbdev
sqlplus / as sysdba

-- create user (if not exists)
CREATE USER clone_user IDENTIFIED BY clone_user; 
GRANT CREATE SESSION, CREATE PLUGGABLE DATABASE TO clone_user;

shutdown immediate;
startup mount;
alter database open read only;
exit;


-- Local 172.31.13.14
-- add (if not exists) to tnsnames.ora (use netmgr)
MTBDEV_10164 =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.1.10.164)(PORT = 1522))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = mtbdev)
    )
  )

--
SQL>
DROP DATABASE LINK clone_mtbdev ;
CREATE DATABASE LINK clone_mtbdev CONNECT TO clone_user IDENTIFIED BY clone_user USING 'MTBDEV_10164';

-- Test link.
DESC usm_menu@clone_mtbdev

--Remote NON-CDB
ALTER PLUGGABLE DATABASE MTBTST CLOSE IMMEDIATE;
DROP PLUGGABLE DATABASE MTBTST INCLUDING DATAFILES;
CREATE PLUGGABLE DATABASE MTBTST FROM NON$CDB@clone_mtbdev FILE_NAME_CONVERT = ('/u01/appse/oracle/oradata/MTBDEV/', '/u01/app/oracle/oradata/DBC19C/MTBTST/');


ALTER SESSION SET CONTAINER=MTBTST;
@?/rdbms/admin/noncdb_to_pdb.sql


ALTER PLUGGABLE DATABASE MTBTST OPEN;

-- Finish -------------------------------------------------------
-- Remote 10.1.10.164
export ORACLE_SID=mtbdev
sqlplus / as sysdba

shutdown immediate;
startup 
exit;