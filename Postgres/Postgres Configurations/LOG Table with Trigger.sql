
-- #####################	LOG TABLE with Trigger on DELETE, UPDATE, INSERT 	######################## --

CREATE TABLE operation_logs (
    log_time TIMESTAMPTZ DEFAULT now(),
    operation TEXT,
    id TEXT,
    username TEXT,
    client_ip TEXT,
	table_name TEXT
);


CREATE OR REPLACE FUNCTION log_to_table() RETURNS TRIGGER AS $$
DECLARE
    client_ip TEXT;
BEGIN
    -- Get the client IP address
    SELECT client_addr INTO client_ip FROM pg_stat_activity WHERE pid = pg_backend_pid();

    -- Log operation details to the operation_logs table
    INSERT INTO operation_logs (log_time, operation, id, username, client_ip, table_name)
    VALUES (
        now(),
        TG_OP, 
        COALESCE(NEW.id::text, OLD.id::text, 'UNKNOWN'), 
        session_user, 
        client_ip, 
        TG_TABLE_NAME  -- Log the table name
    );

    RETURN CASE 
        WHEN TG_OP = 'DELETE' THEN OLD 
        ELSE NEW 
    END; 
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER log_table_activity
AFTER INSERT OR UPDATE OR DELETE ON public.sh_test
FOR EACH ROW EXECUTE FUNCTION log_to_table();


SELECT * from public.operation_logs