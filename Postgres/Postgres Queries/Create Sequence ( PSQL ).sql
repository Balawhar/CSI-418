
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
	-1999,NOW()	
	
SELECT * FROM sdedba.ref_sys_table_sequence

SELECT * FROM information_schema.sequences
where sequence_schema = 'findba'
and upper(sequence_name) like '%asd%';

ALTER SEQUENCE sdedba.S_customer_pic_id
    OWNER TO pgdba;

alter table sdedba.REF_COM_SANCTN_LIST_STATE_HIS
alter column sanctn_list_state_his_id set default nextval('sdedba.s_sanctn_list_state_his_id')

GRANT ALL ON SEQUENCE sdedba.S_customer_pic_id TO pgdba;

GRANT ALL ON SEQUENCE sdedba.S_customer_pic_id TO pguser;


********************************************************************


setval('your_sequence_name', new_value, true) will set the next nextval to return the value you set.
setval('your_sequence_name', new_value, false) will set the next nextval to return the value after the one you set.


-- Set the current value to 100 and ensure the next value returned by nextval is 100
SELECT setval('my_sequence', 100, true);

-- Or, if you want the next value to be 101
SELECT setval('my_sequence', 100, false);
 

SELECT setval('my_sequence', 100);
 
 
********************************************************************

-- Create Trigger
 
CREATE OR REPLACE FUNCTION log_last_query()
RETURNS trigger AS $$
BEGIN
  INSERT INTO query_log (table_name, query, executed_at)
  VALUES (TG_TABLE_NAME, current_query(), now());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER track_queries
AFTER INSERT OR UPDATE OR DELETE ON your_table
FOR EACH ROW EXECUTE FUNCTION log_last_query();
