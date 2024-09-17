-- ######################### Information Schema Tables ########################### --

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

