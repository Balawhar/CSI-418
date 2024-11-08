SELECT DISTINCT 'CREATE TABLE IF NOT EXISTS ' || OWNER || '.' || TABLE_NAME || ' (' ||
       LISTAGG(COLUMN_NAME || ' ' ||
               CASE
                   WHEN DATA_TYPE = 'NUMBER' THEN  
                   CASE WHEN DATA_PRECISION IS NOT NULL THEN
                        'NUMERIC(' || DATA_PRECISION || ',' || DATA_SCALE || ')'
                        ELSE 'NUMERIC'
                        END
                   WHEN DATA_TYPE = 'VARCHAR2' THEN 'VARCHAR(' || DATA_LENGTH || ')'
                   WHEN DATA_TYPE = 'BLOB' THEN 'BYTEA'
                   WHEN DATA_TYPE = 'CLOB' THEN 'VARCHAR(' || DATA_LENGTH || ')'
                   WHEN DATA_TYPE = 'SYS.XMLTYPE' OR DATA_TYPE = 'XMLTYPE'  THEN 'XML'
                   ELSE DATA_TYPE
--               END ||
--               CASE
--                   WHEN NULLABLE = 'N' THEN ' NOT NULL'
--                   ELSE ''
--                   END ||
--                CASE
--                    WHEN TO_CHAR(DATA_DEFAULT) IS NOT NULL THEN ' DEFAULT ' ||
--                         CASE
--                             WHEN TO_CHAR(UPPER(DATA_DEFAULT)) = 'SYSDATE' THEN 'CURRENT_DATE'
--                             ELSE TO_CHAR(DATA_DEFAULT)
--                         END
--                    ELSE ''
               END,
               ',') WITHIN GROUP (ORDER BY COLUMN_ID) OVER (PARTITION BY OWNER, TABLE_NAME)
       || ');' AS PG_TABLE_CREATION
FROM ALL_TAB_COLS
WHERE TABLE_NAME = UPPER('tech_cust_kyc_ref_corp_info')
AND OWNER = UPPER('TECHDBA');

--FK
 SELECT distinct a.owner||'.'||a.table_name AS TBL_NAME_ORG,
          a.r_owner||'.'||b.table_name AS CONS_TBL_NAME_SEC,
          a.constraint_name,
           'alter table '||a.owner||'.'||a.table_name||'
  add constraint '||a.CONSTRAINT_NAME||' foreign key ('||LISTAGG( a1.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY a1.POSITION)
         OVER (PARTITION BY a1.CONSTRAINT_NAME,a1.OWNER,a1.TABLE_NAME)||')
  references '||a.r_owner||'.'||b.table_name||' ('||LISTAGG( b1.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY b1.POSITION)
         OVER (PARTITION BY b1.CONSTRAINT_NAME,b1.OWNER,b1.TABLE_NAME)||');' AS QRY
   FROM ALL_CONSTRAINTS A,ALL_CONS_COLUMNS A1,
        ALL_CONSTRAINTS B,ALL_CONS_COLUMNS B1
   WHERE a1.table_name = a.table_name
   AND a1.constraint_name = a.constraint_name
   AND a1.owner = a.owner
   AND b.constraint_name = a.r_constraint_name
   AND b.owner = a.r_owner
   AND b.table_name = b1.table_name
   AND b.owner = b1.owner
   AND b1.position = a1.position
   AND b.constraint_name = b1.constraint_name
   AND A.TABLE_NAME = UPPER('tech_cust_kyc_ref_corp_info')
   AND A.constraint_type = 'R'
   AND b.constraint_type = 'P'
   AND A.OWNER = UPPER('TECHDBA');
   
   
  --PK
   SELECT distinct A.OWNER,A.TABLE_NAME,A.CONSTRAINT_NAME,
       'alter table '||A.OWNER||'.'||A.TABLE_NAME||' add constraint '||A.CONSTRAINT_NAME||'
        primary key ('||LISTAGG(t.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY t.POSITION)
         OVER (PARTITION BY t.CONSTRAINT_NAME,A.TABLE_NAME,A.OWNER)||');' AS QRY
  FROM ALL_CONSTRAINTS A,
       SYS.ALL_CONS_COLUMNS t
 WHERE T.OWNER = A.OWNER
   AND T.CONSTRAINT_NAME = A.CONSTRAINT_NAME
   AND T.TABLE_NAME = A.TABLE_NAME
   AND A.TABLE_NAME = UPPER('tech_cust_kyc_compliance_info')
   AND A.OWNER = UPPER('TECHDBA')
   AND A.CONSTRAINT_TYPE = 'P' ;
   
