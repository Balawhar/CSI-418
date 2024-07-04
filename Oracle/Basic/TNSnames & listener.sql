-- Configuring the tnsnames.ora / listener.ora --
cd $ORACLE_HOME
cd network/admin/
ll  then vi tnsnames.ora to create the new tns by copying an existing one and changing names
-- or do cat tnsnames.ora to check for an existing Tns
-- then do 
lsnrctl reload
lsnrctl status
else configure it through
netca
netmgr