--################################ Postgres Monitoring ####################################--

-- Display count of sessions openned by every user

SELECT
  count(*) AS connections,
  usename,
  client_addr
FROM
  pg_stat_activity
GROUP BY
  usename, client_addr
ORDER BY
  connections DESC;
  
------------------------------------------------------------------------

-- Display all user connections to the database with their ips and queries

SELECT
 *
FROM
 pg_stat_activity
 
------------------------------------------------------------------------

-- Display all user connections to the database with their ips and queries ( Extended )

SELECT
  pid,
  datname,
  client_addr,
  usename,
  state,
  application_name,
  query
  from
  pg_stat_activity
  -- where client_addr = '10.1.8.23';