---------- export tables from one db to another --------------------------------------------------

-- expdp --
nohup expdp system/system19_DB_mtbdev@mtbdev directory=DBPUMP \
table=sdedba.ref_customer_comment \
dumpfile=mtbdev.ref_customer_comment.dmp \
logfile=ref_customer_comment_export.log &

-- OR --
nohup expdp system/system19_DB_mtbdev@mtbdev directory=DBPUMP \
tables=TECHDBA.TECH_DYNAMIC_RULE_BUILDER \
dumpfile=TECH_DYNAMIC_RULE_BUILDER.dmp \
logfile=TECH_DYNAMIC_RULE_BUILDER.log &

-- Then --
nohup impdp system/system19_DB_mtbdev@mtbdev directory=DBPUMP \ 
full=y table_exists_action=replace \
dumpfile=mtb_export_5_3_2024.dmp \
logfile=imp_mtbdev.log &

-- OR --
nohup impdp system/system19_DB_mtbdev@mtbdev directory=DBPUMP full=y table_exists_action=replace dumpfile=mtb_export_5_3_2024.dmp logfile=imp_mtbdev.log &
