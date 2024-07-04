--###################################### Parallelism in Postgres ######################################--
--------------------------------------------
-- While both PostgreSQL max_parallel_workers_per_gather and Oracles parallel query execution aim to improve query performance by utilizing multiple CPU cores, Oracles implementation is more extensive and flexible, supporting a broader range of operations and providing finer control over parallel execution. PostgreSQLs parallel query execution is powerful for read-intensive operations and can significantly enhance performance for suitable workloads.
--------------------------------------------
-- Key Parameters for Parallel Query Execution in PostgreSQL
--------------------------------------------
-- "max_parallel_workers_per_gather"

-- Sets the maximum number of workers that can be started by a single Gather node

Default: 2

SET max_parallel_workers_per_gather = 4;

-- To check if it is working:

EXPLAIN ANALYZE
SELECT *
FROM <table>
WHERE <condition>;
--------------------------------------------
max_parallel_workers

-- Sets the maximum number of parallel worker processes that the system can support

Default: 8

SET max_parallel_workers = 8;
--------------------------------------------
max_parallel_maintenance_workers:

-- Sets the maximum number of parallel workers that can be started by a single maintenance operation (like CREATE INDEX)

Default: 2

SET max_parallel_maintenance_workers = 4;
--------------------------------------------
parallel_leader_participation:

-- Determines whether the leader process should also participate in parallel query execution

Default: on

SET parallel_leader_participation = on;
--------------------------------------------
-- Example Query Using Parallel Execution
-- Enable Parallel Query Execution:
-- Ensure your configuration allows for parallel execution by setting the parameters accordingly:


SET max_parallel_workers_per_gather = 4;
SET max_parallel_workers = 8;


-- Create a Sample Table:
CREATE TABLE <table> (
    id SERIAL PRIMARY KEY,
    data TEXT,
    value INT
);

-- Insert a large number of rows for testing
INSERT INTO <table> (data, value)
SELECT md5(random()::text), (random() * 100)::int
FROM generate_series(1, 1000000);


-- Use EXPLAIN ANALYZE to check the execution plan and see if parallel workers are used.
EXPLAIN ANALYZE
SELECT *
FROM <table>
WHERE value > 50;
