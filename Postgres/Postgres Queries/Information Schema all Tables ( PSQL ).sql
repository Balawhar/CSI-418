-- ####################### System Catalog / Information Schema Tables ########################### --

-- ############################################################################################

SELECT * FROM pg_statistic	-- stats like distinct / null values

SELECT 
    c.relname AS table_name,
    a.attname AS column_name,
    s.stanullfrac AS null_fraction,
    s.stadistinct AS distinct_values,
    s.stakind1 AS stat_type,
    CASE 
        WHEN s.stakind1 = 1 THEN s.stavalues1  -- Most common values
        WHEN s.stakind1 = 2 THEN s.stavalues2  -- Histogram bounds
        ELSE NULL 
    END AS stat_values
FROM 
    pg_statistic s
JOIN 
    pg_attribute a ON a.attnum = s.staattnum AND a.attrelid = s.starelid
JOIN 
    pg_class c ON c.oid = s.starelid
WHERE 
    c.relname = 'fin_transaction';  -- Replace with your table name

--*******************************************************************

SELECT * FROM pg_depend/pg_shdepend		-- dependancies

SELECT 
    dependent_object.relname AS dependent_object_name,
    dependent_object.relkind AS dependent_object_type,
    referenced_object.relname AS referenced_object_name,
    referenced_object.relkind AS referenced_object_type,
    d.deptype AS dependency_type
FROM 
    pg_depend d
JOIN 
    pg_class dependent_object ON dependent_object.oid = d.objid
JOIN 
    pg_class referenced_object ON referenced_object.oid = d.refobjid
WHERE 
-- 	dependent_object.relname = 'cfg_object_def'
-- AND		
-- 	referenced_object.relname = 'cfg_object_def'
-- AND
    d.refobjid IS NOT NULL
ORDER BY 
    dependent_object_name;

--*******************************************************************

SELECT * FROM pg_class -- objects 

SELECT 
    c.oid AS object_id,
    c.relname AS object_name,
    c.relkind AS object_type,
    n.nspname AS schema_name,
    r.rolname AS owner_name,
    c.relpersistence AS persistence
FROM 
    pg_class c
JOIN 
    pg_namespace n ON n.oid = c.relnamespace
JOIN 
    pg_roles r ON r.oid = c.relowner
ORDER BY 
    c.relname;

--*******************************************************************

SELECT * FROM pg_attribute 	-- attribute of table/column

SELECT 
    a.attnum AS column_number,
    a.attname AS column_name,
    t.relname AS table_name,
    n.nspname AS schema_name,
    pg_catalog.format_type(a.atttypid, a.atttypmod) AS data_type,
    a.attnotnull AS is_not_null
FROM 
    pg_attribute a
JOIN 
    pg_class t ON t.oid = a.attrelid
JOIN 
    pg_namespace n ON n.oid = t.relnamespace
WHERE 
    a.attnum > 0 AND NOT a.attisdropped  -- Exclude dropped columns
ORDER BY 
    table_name, column_number;

--*******************************************************************

SELECT * FROM pg_index 	-- indexes

SELECT 
    i.indexrelid::regclass AS index_name,
    t.relname AS table_name,
    n.nspname AS schema_name,
    i.indisunique AS is_unique,
    i.indisprimary AS is_primary
FROM 
    pg_index i
JOIN 
    pg_class t ON t.oid = i.indrelid
JOIN 
    pg_namespace n ON n.oid = t.relnamespace
ORDER BY 
    index_name;

--*******************************************************************

SELECT * FROM pg_constraint 	-- constraints

SELECT 
    conname AS constraint_name,
    c.relname AS table_name,
    n.nspname AS schema_name,
    contype AS constraint_type
FROM 
    pg_constraint pc
JOIN 
    pg_class c ON c.oid = pc.conrelid
JOIN 
    pg_namespace n ON n.oid = c.relnamespace
-- WHERE
-- 	c.relname = 'cfg_object_def'
ORDER BY 
    constraint_name;

--*******************************************************************

SELECT * FROM pg_namespace    -- schemas

SELECT 
    nspname AS schema_name,
    n.oid AS schema_id
FROM 
    pg_namespace n
ORDER BY 
    schema_name;

--*******************************************************************

SELECT * FROM PG_VIEWS
SELECT * FROM PG_CONFIG
SELECT * FROM PG_SETTINGS
SELECT * FROM PG_FILE_SETTINGS
SELECT * FROM PG_HBA_FILE_RULES
SELECT * FROM PG_ROLES
SELECT * FROM PG_USER
SELECT * FROM PG_SHADOW
SELECT * FROM PG_TABLES
SELECT * FROM PG_INDEXES
SELECT * FROM PG_SEQUENCES
SELECT * FROM PG_STATS
SELECT * FROM PG_STAT_DATABASE_CONFLICTS

--*******************************************************************

SELECT * FROM information_schema.tables; -- all tables

SELECT * FROM information_schema.schemata; -- all schemas

SELECT * FROM information_schema.triggers; -- all triggers

SELECT * FROM information_schema.sequences; -- all sequences

SELECT * FROM information_schema.columns; -- all columns

SELECT * FROM information_schema.key_column_usage; -- all indexes

SELECT * FROM information_schema.views;	-- all views

--

SELECT * FROM information_schema.referential_constraints;  -- all PK's and FK's 

SELECT * FROM information_schema.role_table_grants; -- table grants ( Insert/Update/Delete)

SELECT * FROM information_schema.table_constraints; -- table constraints

SELECT * FROM information_schema.table_privileges; -- table privileges

SELECT * FROM information_schema.view_table_usage; -- all views ( by table )

SELECT * FROM information_schema.view_column_usage; -- all views ( by column )

SELECT * FROM information_schema.role_column_grants; -- Column grants 

--

SELECT * FROM information_schema.constraint_column_usage;

SELECT * FROM information_schema.constraint_table_usage;

SELECT * FROM information_schema.sql_features;

SELECT * FROM information_schema.column_privileges;

SELECT * FROM information_schema.sql_implementation_info;

SELECT * FROM information_schema.data_type_privileges;

SELECT * FROM information_schema.domain_constraints;

SELECT * FROM information_schema.role_routine_grants;

SELECT * FROM information_schema.column_udt_usage;

SELECT * FROM information_schema.column_options;

SELECT * FROM information_schema.column_domain_usage;

SELECT * FROM information_schema.foreign_servers;

SELECT * FROM information_schema.foreign_table_options;

SELECT * FROM information_schema.foreign_tables;

SELECT * FROM information_schema.information_schema_catalog_name;

SELECT * FROM information_schema.enabled_roles;

SELECT * FROM information_schema.foreign_data_wrapper_options;

SELECT * FROM information_schema.foreign_server_options;

SELECT * FROM information_schema.sql_sizing;

SELECT * FROM information_schema.check_constraints;

SELECT * FROM information_schema.character_sets;

SELECT * FROM information_schema.check_constraint_routine_usage;

SELECT * FROM information_schema.collation_character_set_applicability;

SELECT * FROM information_schema.collations;

SELECT * FROM information_schema.column_column_usage;

SELECT * FROM information_schema.domain_udt_usage;

SELECT * FROM information_schema.routine_privileges;

SELECT * FROM information_schema.routines;

SELECT * FROM information_schema.sql_parts;

SELECT * FROM information_schema.udt_privileges;

SELECT * FROM information_schema.user_defined_types;

SELECT * FROM information_schema.domains;

SELECT * FROM information_schema.element_types;

SELECT * FROM information_schema.parameters;

SELECT * FROM information_schema.usage_privileges;

--

