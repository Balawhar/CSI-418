grant execute on DBMS_DATAPUMP to SSDX_ENG ;

SELECT privilege, table_name FROM ALL_TAB_PRIVS WHERE grantee = 'SSDX_ENG';