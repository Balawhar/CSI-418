

select * from v$session

select * from v$lock

select * from v$process

SELECT * FROM v$memory_dynamic_components;

----------------------------------------------------------------------------------------------------

ALTER SYSTEM KILL SESSION '1234,5678' IMMEDIATE;

--------------------------------------------------
SELECT 'ALTER SYSTEM KILL SESSION ''' || s.sid || ',' || s.serial# || ''' IMMEDIATE;' AS kill_command
FROM v$session s
WHERE s.username IS NOT NULL AND s.status = 'ACTIVE';

----------------------------------------------------------------------------------------------------
-- Locks - Blocks
SELECT 
    s1.sid AS blocking_sid,
    s1.serial# AS blocking_serial,
    s1.username AS blocking_username,
    s1.status AS blocking_status,
    s1.machine AS blocking_machine,
    s2.sid AS blocked_sid,
    s2.serial# AS blocked_serial,
    s2.username AS blocked_username,
    s2.status AS blocked_status,
    s2.machine AS blocked_machine
FROM 
    v$session s1
JOIN 
    v$lock l1 ON s1.sid = l1.sid
JOIN 
    v$lock l2 ON l1.id1 = l2.id1 AND l1.id2 = l2.id2
JOIN 
    v$session s2 ON l2.sid = s2.sid
WHERE 
    l1.block = 1;  -- This indicates that the session is blocking another session

--------------------------------------------------
SELECT 
    'ALTER SYSTEM KILL SESSION ''' || blocking_sid || ',' || blocking_serial || ''' IMMEDIATE;' AS kill_command
FROM (
    SELECT 
        s1.sid AS blocking_sid,
        s1.serial# AS blocking_serial
    FROM 
        v$session s1
    JOIN 
        v$lock l1 ON s1.sid = l1.sid
    JOIN 
        v$lock l2 ON l1.id1 = l2.id1 AND l1.id2 = l2.id2
    JOIN 
        v$session s2 ON l2.sid = s2.sid
    WHERE 
        l1.block = 1
);

----------------------------------------------------------------------------------------------------
-- Memory

SELECT 
    s.sid,
    s.serial#,
    SUM(CASE 
            WHEN sn.name = 'session pga memory' THEN ss.value 
            ELSE 0 
        END) AS pga_used_memory,
    SUM(CASE 
            WHEN sn.name = 'session logical reads' THEN ss.value 
            ELSE 0 
        END) AS logical_reads
FROM 
    v$session s
JOIN 
    v$sesstat ss ON s.sid = ss.sid
JOIN 
    v$statname sn ON ss.statistic# = sn.statistic#
GROUP BY 
    s.sid, s.serial#
ORDER BY 
    pga_used_memory DESC;

--------------------------------------------------
    SELECT 
    s.sid, 
    s.username, 
    ss.value AS pga_used_mem
FROM 
    v$session s
JOIN 
    v$sesstat ss ON s.sid = ss.sid
JOIN 
    v$statname sn ON ss.statistic# = sn.statistic#
WHERE 
    sn.name = 'session pga memory' 
ORDER BY 
    ss.value DESC;
	
--------------------------------------------------	
SELECT 
    sid, 
    status 
FROM 
    v$session 
WHERE 
    sid IN (3);
	