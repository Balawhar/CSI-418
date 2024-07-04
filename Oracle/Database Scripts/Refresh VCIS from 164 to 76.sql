=====================================================================================================
-- Refreshing database from dev to test ( from Non-Pluggable to Pluggable by deleting and recreating the pluggable database
=====================================================================================================
-- Remote 10.1.10.164
export ORACLE_SID=vdcdb
sqlplus / as sysdba

-- create user (if not exists)
CREATE USER clone_user IDENTIFIED BY clone_user; 
GRANT CREATE SESSION, CREATE PLUGGABLE DATABASE TO clone_user;

shutdown immediate;
startup mount;
alter database open read only;
exit;


-- Local 10.10.10.76
-- add (if not exists) to tnsnames.ora (use netmgr)

VDCDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = container19c)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = vdcdb)
    )
  )

--
SQL>
DROP DATABASE LINK clone_vdcdb ;
CREATE DATABASE LINK clone_vdcdb CONNECT TO clone_user IDENTIFIED BY clone_user USING 'VDCDB';

-- Test link.
DESC usm_menu@clone_vdcdb

--Remote Pluggable
ALTER PLUGGABLE DATABASE VDCDB CLOSE IMMEDIATE;
DROP PLUGGABLE DATABASE VDCDB INCLUDING DATAFILES;
CREATE PLUGGABLE DATABASE VDCDB FROM NON$CDB@clone_vdcdb FILE_NAME_CONVERT = ('/u01/app/oracle/oradata/vdcdb/', '/u01/app/oracle/oradata/CDB19C/VDCDB/');


ALTER SESSION SET CONTAINER=VDCDB;
@?/rdbms/admin/noncdb_to_pdb.sql


ALTER PLUGGABLE DATABASE VDCDB OPEN;

-- Finish -------------------------------------------------------
-- Remote 10.1.10.164
export ORACLE_SID=vdcdb
sqlplus / as sysdba

shutdown immediate;
startup 
exit;