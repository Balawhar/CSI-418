

#!/bin/bash

# Define file paths
CSV_FILE="/path/to/data.csv"
CLEAN_CSV_FILE="/path/to/clean_data.csv"

# Remove unwanted SQL*Plus lines
sed '/^SQL>/d' $CSV_FILE > $CLEAN_CSV_FILE

# Replace empty strings in numeric columns with NULL
sed -i 's/^\([0-9]*\) *$/\1/g' $CLEAN_CSV_FILE
sed -i 's/^ *$/NULL/g' $CLEAN_CSV_FILE

# Import cleaned CSV file into PostgreSQL
psql -U postgres_user -h postgres_hostname -d dbname -c "\copy your_table FROM '$CLEAN_CSV_FILE' DELIMITER ',' CSV HEADER;"


sed -i '/^SQL>/d' SDEDBA.REF_COM_SNCTION_LST_CUST_MTCH_13062024_2.csv



sed -i 's/^\([0-9]*\) *$/\1/g' SDEDBA.REF_COM_SNCTION_LST_CUST_MTCH_13062024_2.csv



sed -i 's/^ *$/NULL/g' SDEDBA.REF_COM_SNCTION_LST_CUST_MTCH_13062024_2.csv



sed -i 's/^[ \t]*//;s/[ \t]*$//' SDEDBA.REF_COM_SNCTION_LST_CUST_MTCH_13062024_2.csv


