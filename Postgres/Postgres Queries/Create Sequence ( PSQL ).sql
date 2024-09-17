
-- Sequence Creation in PostgreSQL

CREATE SEQUENCE IF NOT EXISTS SDEDBA.S_customer_pic_id
    INCREMENT 1
    START 0
    MINVALUE 0
    MAXVALUE 9999999
    CACHE 20

	
insert into sdedba.ref_sys_table_sequence (owner, table_name, column_name, sequence_name, created_by, creation_date
	)
select 'SDEDBA',UPPER('REF_CUST_PARTY_IDENTIFICATION'),
	UPPER('CUSTOMER_PIC_ID'),UPPER('S_customer_pic_id'),
	-88,NOW()	
	

SELECT * FROM sdedba.ref_sys_table_sequence


SELECT * FROM information_schema.sequences
where sequence_schema = 'findba'
and upper(sequence_name) like '%asd%';


ALTER SEQUENCE sdedba.S_customer_pic_id
    OWNER TO pgdba;

GRANT ALL ON SEQUENCE sdedba.S_customer_pic_id TO pgdba;

GRANT ALL ON SEQUENCE sdedba.S_customer_pic_id TO pguser;


 
 
 
 
 
 

 
 
