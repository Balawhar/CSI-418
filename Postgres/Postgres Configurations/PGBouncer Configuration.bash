
-- ######################### PGBouncer Configuration ############################## --
#--------------------------------------------------------------------------------------

# /etc/pgbouncer/pgbouncer.ini

[databases]
# List of databases and how PgBouncer should connect to them

#vdpsdb
vdpsdb_pgb = host=localhost port=5432 dbname=vdpsdb user=pgbouncer password='SCRAM-SHA-256$4096:rlvr3bU2po57uDqONENE5g==$tK32yyI/9U4BGdsBrGW2PYBE8mTOS9xrNGSNUgIjWNY=:Q8kpOiTBhW3UoxaKJwoTRdc9a/Zcx9tcp+HA9ShwFmc='
vdpsdb_pgg = host=localhost port=5432 dbname=vdpsdb user=postgres password='SCRAM-SHA-256$4096:tK1iKkMr2Le9wy1EtsrtjQ==$FzEVTFgehxgGWX4h40CZbUKMK0YeFRk3BdN+ZwORK9Y=:qvFrln5fZqsyIKI3QWTO7wSBh9tUvzYK0X+Qmw5QRBQ='
vdpsdb_pgd = host=localhost port=5432 dbname=vdpsdb user=pgdba password='SCRAM-SHA-256$4096:LA/aR+nsjxsRuOjQAx65iw==$Aa8vPAPWb1NpOfDHTorG4e2VGF5z3PEp7F/uRznvBVA=:4gkkO8HcmH8QRygiksupBDGWINp3s0ZXwBj4+KxN5V4='
vdpsdb_pgu = host=localhost port=5432 dbname=vdpsdb user=pguser password='SCRAM-SHA-256$4096:ZGE9VChwiQwulyZREG+JJg==$7ZB+BbvYhTe8vCgAHDB6CYZMj1Tp/sNBcBB/RyfF0Nk=:aNILiI/1/E9Vb5PUQ2fowkxcVZleP6RWNhwwFDZdfzY='

#vcisdb
vcisdb_pgb = host=localhost port=5432 dbname=vcisdb user=pgbouncer password='SCRAM-SHA-256$4096:rlvr3bU2po57uDqONENE5g==$tK32yyI/9U4BGdsBrGW2PYBE8mTOS9xrNGSNUgIjWNY=:Q8kpOiTBhW3UoxaKJwoTRdc9a/Zcx9tcp+HA9ShwFmc='
vcisdb_pgg = host=localhost port=5432 dbname=vcisdb user=postgres password='SCRAM-SHA-256$4096:tK1iKkMr2Le9wy1EtsrtjQ==$FzEVTFgehxgGWX4h40CZbUKMK0YeFRk3BdN+ZwORK9Y=:qvFrln5fZqsyIKI3QWTO7wSBh9tUvzYK0X+Qmw5QRBQ='
vcisdb_pgd = host=localhost port=5432 dbname=vcisdb user=pgdba password='SCRAM-SHA-256$4096:LA/aR+nsjxsRuOjQAx65iw==$Aa8vPAPWb1NpOfDHTorG4e2VGF5z3PEp7F/uRznvBVA=:4gkkO8HcmH8QRygiksupBDGWINp3s0ZXwBj4+KxN5V4='
vcisdb_pgu = host=localhost port=5432 dbname=vcisdb user=pguser password='SCRAM-SHA-256$4096:ZGE9VChwiQwulyZREG+JJg==$7ZB+BbvYhTe8vCgAHDB6CYZMj1Tp/sNBcBB/RyfF0Nk=:aNILiI/1/E9Vb5PUQ2fowkxcVZleP6RWNhwwFDZdfzY='

#testdb
testdb_pgb = host=localhost port=5432 dbname=testdb user=pgbouncer password='SCRAM-SHA-256$4096:rlvr3bU2po57uDqONENE5g==$tK32yyI/9U4BGdsBrGW2PYBE8mTOS9xrNGSNUgIjWNY=:Q8kpOiTBhW3UoxaKJwoTRdc9a/Zcx9tcp+HA9ShwFmc='
testdb_pgg = host=localhost port=5432 dbname=testdb user=postgres password='SCRAM-SHA-256$4096:tK1iKkMr2Le9wy1EtsrtjQ==$FzEVTFgehxgGWX4h40CZbUKMK0YeFRk3BdN+ZwORK9Y=:qvFrln5fZqsyIKI3QWTO7wSBh9tUvzYK0X+Qmw5QRBQ='
testdb_pgd = host=localhost port=5432 dbname=testdb user=pgdba password='SCRAM-SHA-256$4096:LA/aR+nsjxsRuOjQAx65iw==$Aa8vPAPWb1NpOfDHTorG4e2VGF5z3PEp7F/uRznvBVA=:4gkkO8HcmH8QRygiksupBDGWINp3s0ZXwBj4+KxN5V4='
testdb_pgu = host=localhost port=5432 dbname=testdb user=pguser password='SCRAM-SHA-256$4096:ZGE9VChwiQwulyZREG+JJg==$7ZB+BbvYhTe8vCgAHDB6CYZMj1Tp/sNBcBB/RyfF0Nk=:aNILiI/1/E9Vb5PUQ2fowkxcVZleP6RWNhwwFDZdfzY='

#testdb2
testdb2_pgb = host=localhost port=5432 dbname=testdb2 user=pgbouncer password='SCRAM-SHA-256$4096:rlvr3bU2po57uDqONENE5g==$tK32yyI/9U4BGdsBrGW2PYBE8mTOS9xrNGSNUgIjWNY=:Q8kpOiTBhW3UoxaKJwoTRdc9a/Zcx9tcp+HA9ShwFmc='
testdb2_pgg = host=localhost port=5432 dbname=testdb2 user=postgres password='SCRAM-SHA-256$4096:tK1iKkMr2Le9wy1EtsrtjQ==$FzEVTFgehxgGWX4h40CZbUKMK0YeFRk3BdN+ZwORK9Y=:qvFrln5fZqsyIKI3QWTO7wSBh9tUvzYK0X+Qmw5QRBQ='
testdb2_pgd = host=localhost port=5432 dbname=testdb2 user=pgdba password='SCRAM-SHA-256$4096:LA/aR+nsjxsRuOjQAx65iw==$Aa8vPAPWb1NpOfDHTorG4e2VGF5z3PEp7F/uRznvBVA=:4gkkO8HcmH8QRygiksupBDGWINp3s0ZXwBj4+KxN5V4='
testdb2_pgu = host=localhost port=5432 dbname=testdb2 user=pguser password='SCRAM-SHA-256$4096:ZGE9VChwiQwulyZREG+JJg==$7ZB+BbvYhTe8vCgAHDB6CYZMj1Tp/sNBcBB/RyfF0Nk=:aNILiI/1/E9Vb5PUQ2fowkxcVZleP6RWNhwwFDZdfzY='

# PgBouncer database connection
pgbouncer_db = host=localhost port=5432 dbname=pgbouncer_database user=pgbouncer password='SCRAM-SHA-256$4096:rlvr3bU2po57uDqONENE5g==$tK32yyI/9U4BGdsBrGW2PYBE8mTOS9xrNGSNUgIjWNY=:Q8kpOiTBhW3UoxaKJwoTRdc9a/Zcx9tcp+HA9ShwFmc='

[pgbouncer]
# Where PgBouncer will listen for connections
# Change this to the server's IP if needed
listen_addr = 127.0.0.1

admin_users = pgbouncer
stats_users = pgbouncer

# The port PgBouncer will listen on
listen_port = 6432

unix_socket_dir = /var/run/pgbouncer

# Connection pool settings
# Choose between 'session', 'transaction', 'statement'
pool_mode = session

# Maximum number of client connections
max_client_conn = 200

# Maximum number of server connections
default_pool_size = 20

# Additional connections allowed in the pool when full
reserve_pool_size = 50

# Timeout before releasing the extra connections
reserve_pool_timeout = 5.0

# Authentication settings
auth_type = scram-sha-256

# HBA configuration file for PgBouncer
# hba_file = /etc/pgbouncer/pgbouncer_hba.conf

# PgBouncer user authentication file
auth_file = /etc/pgbouncer/userlist.txt

# Connection timeouts and limits
# Close server connections after idle time (in seconds)
server_idle_timeout = 600

# Log when clients connect
log_connections = 1

# Log when clients disconnect
log_disconnections = 1

# Log pooler errors
log_pooler_errors = 1

#log
logfile = /var/log/pgbouncer/pgbouncer.log
pidfile = /var/run/pgbouncer/pgbouncer.pid

--

sudo vi /etc/pgbouncer/pgbouncer_hba.conf
--

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     trust

# IPv4 local connections:
host    all             all             0.0.0.0/0               scram-sha-256

host    pgbouncer       pgbouncer       127.0.0.1/32            scram-sha-256

# IPv6 local connections:
host    all             all             ::1/128                 scram-sha-256


--

# Change pg_hba ( Postgres ) to  scram-sha-256

sudo chown pgbouncer:pgbouncer /etc/pgbouncer/pgbouncer_hba.conf

sudo chmod 644 /etc/pgbouncer/pgbouncer_hba.conf

--

auth_file = /etc/pgbouncer/userlist.txt

# /etc/pgbouncer/userlist.txt

"pgbouncer" "SCRAM-SHA-256$4096:rlvr3bU2po57uDqONENE5g==$tK32yyI/9U4BGdsBrGW2PYBE8mTOS9xrNGSNUgIjWNY=:Q8kpOiTBhW3UoxaKJwoTRdc9a/Zcx9tcp+HA9ShwFmc="
"postgres" "SCRAM-SHA-256$4096:tK1iKkMr2Le9wy1EtsrtjQ==$FzEVTFgehxgGWX4h40CZbUKMK0YeFRk3BdN+ZwORK9Y=:qvFrln5fZqsyIKI3QWTO7wSBh9tUvzYK0X+Qmw5QRBQ="
"pgdba" "SCRAM-SHA-256$4096:LA/aR+nsjxsRuOjQAx65iw==$Aa8vPAPWb1NpOfDHTorG4e2VGF5z3PEp7F/uRznvBVA=:4gkkO8HcmH8QRygiksupBDGWINp3s0ZXwBj4+KxN5V4="
"pguser" "SCRAM-SHA-256$4096:ZGE9VChwiQwulyZREG+JJg==$7ZB+BbvYhTe8vCgAHDB6CYZMj1Tp/sNBcBB/RyfF0Nk=:aNILiI/1/E9Vb5PUQ2fowkxcVZleP6RWNhwwFDZdfzY="

#
sudo chown pgbouncer:pgbouncer /etc/pgbouncer/userlist.txt

sudo chmod 640 /etc/pgbouncer/userlist.txt

--

sudo chown pgbouncer:pgbouncer /etc/pgbouncer/pgbouncer.ini

sudo chmod 640 /etc/pgbouncer/pgbouncer.ini

--

logfile = /var/log/pgbouncer/pgbouncer.log
pidfile = /var/run/pgbouncer/pgbouncer.pid


/var/log/pgbouncer/pgbouncer.log

sudo chown pgbouncer:pgbouncer /var/log/pgbouncer
sudo chmod 750 /var/log/pgbouncer

/var/run/pgbouncer

sudo chown pgbouncer:pgbouncer /etc/pgbouncer/mkauth.py
sudo chmod 750 /etc/pgbouncer/mkauth.py


ls -ld /etc/pgbouncer/mkauth.py
ls -ld /var/log/pgbouncer
ls -ld /var/run/pgbouncer

#Switches to the pgbouncer user and gives you a new shell with their environment.
sudo su - pgbouncer
#Runs a specified command as the pgbouncer user without switching your shell or environment.
sudo -u pgbouncer

sudo passwd pgbouncer

ls -Z /usr/bin/pgbouncer
ls -Z /etc/pgbouncer

#

/usr/lib/systemd/system/pgbouncer.service

sudo cp /usr/lib/systemd/system/pgbouncer.service /etc/systemd/system/

sudo cp /usr/lib/systemd/system/pgbouncer.service /etc/systemd/system/

sudo vi /etc/systemd/system/pgbouncer.service

# add to service
[Service]
LimitNOFILE=4096

sudo systemctl daemon-reload
sudo systemctl restart pgbouncer

#

sudo firewall-cmd --add-port=6432/tcp --permanent
sudo firewall-cmd --reload
sudo netstat -tuln | grep 6432
sudo firewall-cmd --list-all

#

CREATE ROLE pgbouncer LOGIN PASSWORD 'pgBouncer@2025';

ALTER USER pgbouncer WITH PASSWORD 'pgBouncer@2025';

GRANT pg_monitor TO pgbouncer;

SHOW password_encryption;
SHOW scram_iterations;

#

CREATE DATABASE pgbouncer;

GRANT ALL PRIVILEGES ON DATABASE pgbouncer TO pgbouncer;

sudo -u pgbouncer psql -h 127.0.0.1 -d pgbouncer

psql -h 127.0.0.1 -p 6432 -d pgbouncer -U pgbouncer

#

sudo systemctl start pgbouncer

sudo systemctl restart pgbouncer

sudo systemctl enable pgbouncer

sudo systemctl enable pgbouncer.service

#

# Testing / Logging / Debugging

# Validate Configuration
pgbouncer -q /etc/pgbouncer/pgbouncer.ini

sudo -u pgbouncer psql -h 127.0.0.1 -d pgbouncer

tail -f /var/log/pgbouncer/pgbouncer.log

cat /u01/pgsql/17/data/log/postgresql-Fri.log

psql -h 127.0.0.1 -p 6432 -d pgbouncer -U pgbouncer

psql -h 127.0.0.1 -p 6432 -U pgbouncer -d pgbouncer_pgb

sudo journalctl -u pgbouncer
 
sudo journalctl -xe 

#

#

SHOW POOLS;
SHOW CLIENTS;
SHOW SERVERS;
SHOW STATS;
SHOW USERS;

# Reload pgBouncer Configuration
RELOAD;

SHOW CONFIG;

# Pause Connections for a certain database
PAUSE dbname;
# Resume Connections
RESUME dbname;

# Kill idle connections
KILL dbname;

# Shutdown pgbouncer safely
SHUTDOWN;

#

# pg_hba ( postgres )

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     trust

# IPv4 local connections:
host    all             all             0.0.0.0/0               scram-sha-256

host    all             pgbouncer       127.0.0.1/32            scram-sha-256

# IPv6 local connections:
host    all             all             ::1/128                 scram-sha-256

host    all             pgbouncer       ::1/128                 scram-sha-256

# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     trust
host    replication     all             0.0.0.0/0               scram-sha-256
host    replication     all             ::1/128                 scram-sha-256

#

#

# /etc/systemd/system/pgbouncer.service

# It's not recommended to modify this file in-place, because it will be
# overwritten during package upgrades.  It is recommended to use systemd
# "dropin" feature;  i.e. create file with suffix .conf under
# /etc/systemd/system/pgbouncer.service.d directory overriding the
# unit's defaults. You can also use "systemctl edit pgbouncer"
# Look at systemd.unit(5) manual page for more info.

[Unit]
Description=A lightweight connection pooler for PostgreSQL
After=syslog.target
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
LimitNOFILE=4096

User=pgbouncer
Group=pgbouncer

# Path to the init file
Environment=BOUNCERCONF=/etc/pgbouncer/pgbouncer.ini

# Where to send early-startup messages from the server
# This is normally controlled by the global default set by systemd
# StandardOutput=syslog

ExecStart=/usr/bin/pgbouncer ${BOUNCERCONF}
ExecReload=/usr/bin/kill -HUP $MAINPID
KillSignal=SIGINT

# Give a reasonable amount of time for the server to start up/shut down
TimeoutSec=300

[Install]
WantedBy=multi-user.target

#




    SHOW HELP|CONFIG|DATABASES|POOLS|CLIENTS|SERVERS|USERS|VERSION
        SHOW PEERS|PEER_POOLS
        SHOW FDS|SOCKETS|ACTIVE_SOCKETS|LISTS|MEM|STATE
        SHOW DNS_HOSTS|DNS_ZONES
        SHOW STATS|STATS_TOTALS|STATS_AVERAGES|TOTALS
        SET key = arg
        RELOAD
        PAUSE [<db>]
        RESUME [<db>]
        DISABLE <db>
        ENABLE <db>
        RECONNECT [<db>]
        KILL <db>
        SUSPEND
        SHUTDOWN
        SHUTDOWN WAIT_FOR_SERVERS|WAIT_FOR_CLIENTS
        WAIT_CLOSE [<db>]













[databases]
# List of databases and how PgBouncer should connect to them

#vdpsdb
vdpsdb_pgb = host=10.10.10.79 port=5432 dbname=vdpsdb user=pgbouncer password='SCRAM-SHA-256$4096:rlvr3bU2po57uDqONENE5g==$tK32yyI/9U4BGdsBrGW2PYBE8mTOS9xrNGSNUgIjWNY=:Q8kpOiTBhW3UoxaKJwoTRdc9a/Zcx9tcp+HA9ShwFmc='
vdpsdb_pgg = host=10.10.10.79 port=5432 dbname=vdpsdb user=postgres password='SCRAM-SHA-256$4096:tK1iKkMr2Le9wy1EtsrtjQ==$FzEVTFgehxgGWX4h40CZbUKMK0YeFRk3BdN+ZwORK9Y=:qvFrln5fZqsyIKI3QWTO7wSBh9tUvzYK0X+Qmw5QRBQ='
vdpsdb_pgd = host=10.10.10.79 port=5432 dbname=vdpsdb user=pgdba password='SCRAM-SHA-256$4096:LA/aR+nsjxsRuOjQAx65iw==$Aa8vPAPWb1NpOfDHTorG4e2VGF5z3PEp7F/uRznvBVA=:4gkkO8HcmH8QRygiksupBDGWINp3s0ZXwBj4+KxN5V4='
vdpsdb_pgu = host=10.10.10.79 port=5432 dbname=vdpsdb user=pguser password='SCRAM-SHA-256$4096:ZGE9VChwiQwulyZREG+JJg==$7ZB+BbvYhTe8vCgAHDB6CYZMj1Tp/sNBcBB/RyfF0Nk=:aNILiI/1/E9Vb5PUQ2fowkxcVZleP6RWNhwwFDZdfzY='

#vcisdb
vcisdb_pgb = host=10.10.10.79 port=5432 dbname=vcisdb user=pgbouncer password='SCRAM-SHA-256$4096:rlvr3bU2po57uDqONENE5g==$tK32yyI/9U4BGdsBrGW2PYBE8mTOS9xrNGSNUgIjWNY=:Q8kpOiTBhW3UoxaKJwoTRdc9a/Zcx9tcp+HA9ShwFmc='
vcisdb_pgg = host=10.10.10.79 port=5432 dbname=vcisdb user=postgres password='SCRAM-SHA-256$4096:tK1iKkMr2Le9wy1EtsrtjQ==$FzEVTFgehxgGWX4h40CZbUKMK0YeFRk3BdN+ZwORK9Y=:qvFrln5fZqsyIKI3QWTO7wSBh9tUvzYK0X+Qmw5QRBQ='
vcisdb_pgd = host=10.10.10.79 port=5432 dbname=vcisdb user=pgdba password='SCRAM-SHA-256$4096:LA/aR+nsjxsRuOjQAx65iw==$Aa8vPAPWb1NpOfDHTorG4e2VGF5z3PEp7F/uRznvBVA=:4gkkO8HcmH8QRygiksupBDGWINp3s0ZXwBj4+KxN5V4='
vcisdb_pgu = host=10.10.10.79 port=5432 dbname=vcisdb user=pguser password='SCRAM-SHA-256$4096:ZGE9VChwiQwulyZREG+JJg==$7ZB+BbvYhTe8vCgAHDB6CYZMj1Tp/sNBcBB/RyfF0Nk=:aNILiI/1/E9Vb5PUQ2fowkxcVZleP6RWNhwwFDZdfzY='

#testdb
testdb_pgb = host=10.10.10.79 port=5432 dbname=testdb user=pgbouncer password='SCRAM-SHA-256$4096:rlvr3bU2po57uDqONENE5g==$tK32yyI/9U4BGdsBrGW2PYBE8mTOS9xrNGSNUgIjWNY=:Q8kpOiTBhW3UoxaKJwoTRdc9a/Zcx9tcp+HA9ShwFmc='
testdb_pgg = host=10.10.10.79 port=5432 dbname=testdb user=postgres password='SCRAM-SHA-256$4096:tK1iKkMr2Le9wy1EtsrtjQ==$FzEVTFgehxgGWX4h40CZbUKMK0YeFRk3BdN+ZwORK9Y=:qvFrln5fZqsyIKI3QWTO7wSBh9tUvzYK0X+Qmw5QRBQ='
testdb_pgd = host=10.10.10.79 port=5432 dbname=testdb user=pgdba password='SCRAM-SHA-256$4096:LA/aR+nsjxsRuOjQAx65iw==$Aa8vPAPWb1NpOfDHTorG4e2VGF5z3PEp7F/uRznvBVA=:4gkkO8HcmH8QRygiksupBDGWINp3s0ZXwBj4+KxN5V4='
testdb_pgu = host=10.10.10.79 port=5432 dbname=testdb user=pguser password='SCRAM-SHA-256$4096:ZGE9VChwiQwulyZREG+JJg==$7ZB+BbvYhTe8vCgAHDB6CYZMj1Tp/sNBcBB/RyfF0Nk=:aNILiI/1/E9Vb5PUQ2fowkxcVZleP6RWNhwwFDZdfzY='

#testdb2
testdb2_pgb = host=10.10.10.79 port=5432 dbname=testdb2 user=pgbouncer password='SCRAM-SHA-256$4096:rlvr3bU2po57uDqONENE5g==$tK32yyI/9U4BGdsBrGW2PYBE8mTOS9xrNGSNUgIjWNY=:Q8kpOiTBhW3UoxaKJwoTRdc9a/Zcx9tcp+HA9ShwFmc='
testdb2_pgg = host=10.10.10.79 port=5432 dbname=testdb2 user=postgres password='SCRAM-SHA-256$4096:tK1iKkMr2Le9wy1EtsrtjQ==$FzEVTFgehxgGWX4h40CZbUKMK0YeFRk3BdN+ZwORK9Y=:qvFrln5fZqsyIKI3QWTO7wSBh9tUvzYK0X+Qmw5QRBQ='
testdb2_pgd = host=10.10.10.79 port=5432 dbname=testdb2 user=pgdba password='SCRAM-SHA-256$4096:LA/aR+nsjxsRuOjQAx65iw==$Aa8vPAPWb1NpOfDHTorG4e2VGF5z3PEp7F/uRznvBVA=:4gkkO8HcmH8QRygiksupBDGWINp3s0ZXwBj4+KxN5V4='
testdb2_pgu = host=10.10.10.79 port=5432 dbname=testdb2 user=pguser password='SCRAM-SHA-256$4096:ZGE9VChwiQwulyZREG+JJg==$7ZB+BbvYhTe8vCgAHDB6CYZMj1Tp/sNBcBB/RyfF0Nk=:aNILiI/1/E9Vb5PUQ2fowkxcVZleP6RWNhwwFDZdfzY='

# PgBouncer database connection
pgbouncer_db = host=10.10.10.79 port=5432 dbname=pgbouncer_database user=pgbouncer password='SCRAM-SHA-256$4096:rlvr3bU2po57uDqONENE5g==$tK32yyI/9U4BGdsBrGW2PYBE8mTOS9xrNGSNUgIjWNY=:Q8kpOiTBhW3UoxaKJwoTRdc9a/Zcx9tcp+HA9ShwFmc='

[pgbouncer]
# Where PgBouncer will listen for connections
# Change this to the server's IP if needed
listen_addr = *

admin_users = pgbouncer
stats_users = pgbouncer

# The port PgBouncer will listen on
listen_port = 6432

unix_socket_dir = /var/run/pgbouncer

# Connection pool settings
# Choose between 'session', 'transaction', 'statement'
pool_mode = session

# Maximum number of client connections
max_client_conn = 200

# Maximum number of server connections
default_pool_size = 20

# Additional connections allowed in the pool when full
reserve_pool_size = 50

# Timeout before releasing the extra connections
reserve_pool_timeout = 5.0

# Authentication settings
auth_type = scram-sha-256

# HBA configuration file for PgBouncer
# hba_file = /etc/pgbouncer/pgbouncer_hba.conf

# PgBouncer user authentication file
auth_file = /etc/pgbouncer/userlist.txt

# Connection timeouts and limits
# Close server connections after idle time (in seconds)
server_idle_timeout = 600

# Log when clients connect
log_connections = 1

# Log when clients disconnect
log_disconnections = 1

# Log pooler errors
log_pooler_errors = 1

#log
logfile = /var/log/pgbouncer/pgbouncer.log
pidfile = /var/run/pgbouncer/pgbouncer.pid
