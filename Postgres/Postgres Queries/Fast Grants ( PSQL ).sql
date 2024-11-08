DO
$$
DECLARE
    schema_record RECORD;
BEGIN
    -- Loop through all schemas owned by postgres
    FOR schema_record IN
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_owner = 'Postgres'
    LOOP
        -- Change the owner of each schema to pgdba
        EXECUTE format('ALTER SCHEMA %I OWNER TO pgdba;', schema_record.schema_name);
    END LOOP;
END
$$;

----------------------------------------------------------------------------------------
-- Changing OWNER of All Tables From Postgres To Pgdba on All Database ( Script ) ------

DO $$ 
DECLARE
    table_rec RECORD;
BEGIN
    -- Loop through all tables in all schemas owned by 'postgres'
    FOR table_rec IN
        SELECT schemaname, tablename
        FROM pg_tables
        WHERE schemaname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
          AND tableowner = 'postgres'
    LOOP
        -- Construct and execute the ALTER TABLE command
        BEGIN
            EXECUTE 'ALTER TABLE ' || quote_ident(table_rec.schemaname) || '.' || quote_ident(table_rec.tablename) || ' OWNER TO pgdba';
        EXCEPTION
            WHEN others THEN
                RAISE NOTICE 'Failed to change ownership of %.%: %', table_rec.schemaname, table_rec.tablename, SQLERRM;
        END;
    END LOOP;
END $$;

----------------------------------------------------------------------------------------
-- Change OWNER of PROCEDURES ( Script ) ----------------------------------------------- 

DO $$ 
DECLARE
    proc_rec RECORD;
BEGIN
    -- Loop through all procedures in all schemas owned by 'postgres'
    FOR proc_rec IN
        SELECT n.nspname AS schemaname, p.proname AS procname, pg_get_function_identity_arguments(p.oid) AS arguments
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        JOIN pg_authid a ON p.proowner = a.oid
        WHERE n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
          AND a.rolname = 'postgres'
          AND p.prokind = 'p'  -- Ensure we're selecting procedures
    LOOP
        -- Construct and execute the ALTER PROCEDURE command
        BEGIN
            EXECUTE 'ALTER PROCEDURE ' || quote_ident(proc_rec.schemaname) || '.' || quote_ident(proc_rec.procname) || '(' || proc_rec.arguments || ') OWNER TO pgdba';
        EXCEPTION
            WHEN others THEN
                RAISE NOTICE 'Failed to change ownership of %.%(%): %', proc_rec.schemaname, proc_rec.procname, proc_rec.arguments, SQLERRM;
        END;
    END LOOP;
END $$;

------------------------------------------------------------------------------------------
-- Change OWNER of FUNCTIONS ( Script ) -------------------------------------------------- 

DO $$ 
DECLARE
    proc_rec RECORD;
    arg_list TEXT;
BEGIN
    -- Loop through all procedures in all schemas owned by 'postgres'
    FOR proc_rec IN
        SELECT n.nspname AS schemaname, p.proname AS procname, oidvectortypes(p.proargtypes) AS arguments
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        JOIN pg_authid a ON p.proowner = a.oid
        WHERE n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
          AND a.rolname = 'postgres'
    LOOP
        -- Construct the argument list
        arg_list := proc_rec.arguments;
        -- Construct and execute the ALTER FUNCTION command
        BEGIN
            EXECUTE 'ALTER FUNCTION ' || quote_ident(proc_rec.schemaname) || '.' || quote_ident(proc_rec.procname) || '(' || arg_list || ') OWNER TO pgdba';
        EXCEPTION
            WHEN others THEN
                RAISE NOTICE 'Failed to change ownership of %.%(%): %', proc_rec.schemaname, proc_rec.procname, arg_list, SQLERRM;
        END;
    END LOOP;
END $$;

------------------------------------------------------------------------------------------
-- Change OWNER of SEQUENCES Owner ( Script ) --------------------------------------------

DO
$$
DECLARE
    schema_name TEXT;
    seq_record RECORD;
BEGIN
    -- List of schemas excluding system schemas
    FOR schema_name IN 
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    LOOP
        -- Iterate over all sequences in the current schema owned by postgres
        FOR seq_record IN 
            SELECT sequence_schema, sequence_name
            FROM information_schema.sequences
            WHERE sequence_schema = schema_name AND sequence_owner = 'postgres'
        LOOP
            -- Change the owner of each sequence
            EXECUTE format('ALTER SEQUENCE %I.%I OWNER TO pgdba;', seq_record.sequence_schema, seq_record.sequence_name);
        END LOOP;
    END LOOP;
END
$$;

------------------------------------------------------------------------------------------
-- Change OWNER of TRIGGERS ( Script ) ---------------------------------------------------

DO $$ 
DECLARE
    trigger_rec RECORD;
BEGIN
    -- Loop through all triggers in all schemas owned by 'postgres'
    FOR trigger_rec IN
        SELECT n.nspname AS schemaname, 
               t.tgname AS triggername, 
               pg_get_triggerdef(t.oid) AS triggerdef
        FROM pg_trigger t
        JOIN pg_class c ON t.tgrelid = c.oid
        JOIN pg_namespace n ON c.relnamespace = n.oid
        JOIN pg_authid a ON c.relowner = a.oid  -- Use relowner to check table owner
        WHERE n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
          AND a.rolname = 'postgres'
    LOOP
        -- Construct and execute the ALTER TRIGGER command
        BEGIN
            EXECUTE 'ALTER TRIGGER ' || quote_ident(trigger_rec.triggername) || ' ON ' || quote_ident(trigger_rec.schemaname) || '.' || quote_ident(trigger_rec.triggerdef) || ' OWNER TO pgdba';
        EXCEPTION
            WHEN others THEN
                RAISE NOTICE 'Failed to change ownership of %.%: %', trigger_rec.schemaname, trigger_rec.triggername, SQLERRM;
        END;
    END LOOP;
END $$;

------------------------------------------------------------------------------------------
-- Change OWNER of EXTENSIONS ( Script ) -------------------------------------------------

DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT extname AS extension_name
        FROM pg_catalog.pg_extension
        WHERE pg_catalog.pg_get_userbyid(extowner) = 'postgres'
    LOOP
        RAISE NOTICE 'Changing owner of extension % to pgdba', rec.extension_name;
        EXECUTE format('ALTER EXTENSION %I OWNER TO pgdba;', rec.extension_name);
    END LOOP;
END $$;

------------------------------------------------------------------------------------------
-- Change TABLESPACE of TABLES and INDEXES ( Script ) ------------------------------------

-- Define the target tablespaces

DO $$
DECLARE
    table_tablespace TEXT := 'vdfs_data';
    index_tablespace TEXT := 'vdfs_index';
    rec RECORD;
BEGIN
    -- Change the tablespace of all tables
    FOR rec IN
        SELECT n.nspname AS schemaname, 
			   c.relname AS tablename,
		       t.spcname AS tablespace
		FROM pg_tables p
		JOIN pg_class c ON p.tablename = c.relname
		JOIN pg_namespace n ON c.relnamespace = n.oid
		LEFT JOIN pg_tablespace t ON c.reltablespace = t.oid
		WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')-- Exclude system schemas
    LOOP
        EXECUTE format('ALTER TABLE %I.%I SET TABLESPACE %I',
                        rec.schemaname, rec.tablename, table_tablespace);
    END LOOP;
    
    -- Change the tablespace of all indexes
    FOR rec IN
	SELECT i.schemaname,
		   i.indexname,
		   t.spcname AS tablespace
	FROM pg_indexes i
	JOIN pg_class c ON i.indexname = c.relname
	LEFT JOIN pg_tablespace t ON c.reltablespace = t.oid
	WHERE i.schemaname NOT IN ('pg_catalog', 'information_schema') -- Exclude system schemas
    LOOP
        EXECUTE format('ALTER INDEX %I.%I SET TABLESPACE %I',
                        rec.schemaname, rec.indexname, index_tablespace);
    END LOOP;
END $$;

--=======================================================================================

-- SCRIPTS ----------------------------------------------------------------------------

--=======================================================================================
-- Grant USAGE Privileges on SCHEMAS --------------------------------------------------
 
DO
$$
DECLARE
    schema_record RECORD;
BEGIN
    -- Loop through all schemas
    FOR schema_record IN
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    LOOP
        -- Grant USAGE on each schema to pgdba
        EXECUTE format('GRANT USAGE ON SCHEMA %I TO pgdba;', schema_record.schema_name);
    END LOOP;
END
$$;

----------------------------------------------------------------------------------------
-- Grant All PRIVILEGES on Tables in Schema --------------------------------------------
-- SELECT / INSERT / UPDATE / DELETE / TRUNCATE / REFERENCES / TRIGGER
DO
$$
DECLARE
    schema_record RECORD;
    table_record RECORD;
BEGIN
    -- Loop through all schemas excluding system schemas
    FOR schema_record IN
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    LOOP
        -- Loop through all tables in the current schema
        FOR table_record IN
            SELECT table_name
            FROM information_schema.tables
            WHERE table_schema = schema_record.schema_name
        LOOP
            -- Grant ALL PRIVILEGES on each table to pgdba
            EXECUTE format('GRANT ALL PRIVILEGES ON TABLE %I.%I TO pgdba;', schema_record.schema_name, table_record.table_name);
        END LOOP;
    END LOOP;
END
$$;


--****************************************************************



DO
$$
DECLARE
    schema_record RECORD;
BEGIN
    -- Loop through all schemas
    FOR schema_record IN
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    LOOP
        -- Grant USAGE on each schema to pguser
        EXECUTE format('GRANT USAGE ON SCHEMA %I TO pguser;', schema_record.schema_name);
    END LOOP;
END
$$;

----------------------------------------------------------------------------------------
-- Grant All PRIVILEGES on Tables in Schema --------------------------------------------
-- SELECT / INSERT / UPDATE / DELETE / TRUNCATE / REFERENCES / TRIGGER
DO
$$
DECLARE
    schema_record RECORD;
    table_record RECORD;
BEGIN
    -- Loop through all schemas excluding system schemas
    FOR schema_record IN
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_name NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    LOOP
        -- Loop through all tables in the current schema
        FOR table_record IN
            SELECT table_name
            FROM information_schema.tables
            WHERE table_schema = schema_record.schema_name
        LOOP
            -- Grant ALL PRIVILEGES on each table to pguser
            EXECUTE format('GRANT ALL PRIVILEGES ON TABLE %I.%I TO pguser;', schema_record.schema_name, table_record.table_name);
        END LOOP;
    END LOOP;
END
$$;