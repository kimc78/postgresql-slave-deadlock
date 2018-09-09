# How to run

`docker-compose up --force-recreate --abort-on-container-exit --build`

wait for all docker containers to build and launch

You will get about like this
```
postgres-master_1  | 2018-09-08 11:01:29.428 GMT [9] LOG:  listening on IPv4 address "0.0.0.0", port 5432
postgres-master_1  | 2018-09-08 11:01:29.428 GMT [9] LOG:  listening on IPv6 address "::", port 5432
postgres-master_1  | 2018-09-08 11:01:29.441 GMT [9] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
postgres-master_1  | 2018-09-08 11:01:29.465 GMT [9] LOG:  could not open usermap file "/var/lib/postgresql/10/main/pg_ident.conf": No such file or directory
postgres-master_1  | 2018-09-08 11:01:29.470 GMT [10] LOG:  database system was shut down at 2018-09-07 09:18:39 GMT
postgres-master_1  | 2018-09-08 11:01:29.478 GMT [9] LOG:  database system is ready to accept connections
worker-master_1    | Work starting on master
worker-master_1    | COMMIT
... snip ...
23508/23508 kB (100%), 1/1 tablespacekpoint
... snip ...
worker-master_1    | COMMIT
worker-master_1    | COMMIT
postgres-slave_1   | 2018-09-08 11:01:37.682 GMT [9] LOG:  listening on IPv4 address "0.0.0.0", port 5432
postgres-slave_1   | 2018-09-08 11:01:37.682 GMT [9] LOG:  listening on IPv6 address "::", port 5432
postgres-slave_1   | 2018-09-08 11:01:37.688 GMT [9] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
postgres-slave_1   | 2018-09-08 11:01:37.698 GMT [9] LOG:  could not open usermap file "/var/lib/postgresql/10/main/pg_ident.conf": No such file or directory
postgres-slave_1   | 2018-09-08 11:01:37.701 GMT [16] LOG:  database system was interrupted; last known up at 2018-09-08 11:01:34 GMT
postgres-slave_1   | 2018-09-08 11:01:37.800 GMT [16] LOG:  entering standby mode
postgres-slave_1   | 2018-09-08 11:01:37.807 GMT [16] LOG:  redo starts at 0/2000028
postgres-slave_1   | 2018-09-08 11:01:37.810 GMT [16] LOG:  consistent recovery state reached at 0/20000F8
postgres-slave_1   | 2018-09-08 11:01:37.810 GMT [9] LOG:  database system is ready to accept read only connections
postgres-slave_1   | 2018-09-08 11:01:37.817 GMT [20] LOG:  started streaming WAL from primary at 0/3000000 on timeline 1
worker-master_1    | COMMIT
worker-slave-4_1   | Work starting on slave
worker-master_1    | COMMIT
worker-slave-4_1   |  ?column? 
worker-slave-4_1   | ----------
worker-slave-4_1   |         1
worker-slave-4_1   | (1 row)
worker-slave-4_1   | 
worker-master_1    | COMMIT
worker-master_1    | COMMIT
worker-slave-4_1   |  ?column? 
worker-slave-4_1   | ----------
worker-slave-4_1   |         1
worker-slave-4_1   | (1 row)
worker-slave-4_1   | 
... snip ...
worker-master_1    | COMMIT
worker-master_1    | COMMIT
worker-master_1    | COMMIT
postgres-slave_1   | 2018-09-08 11:01:40.275 GMT [75] ERROR:  deadlock detected at character 48
postgres-slave_1   | 2018-09-08 11:01:40.275 GMT [75] DETAIL:  Process 75 waits for AccessShareLock on relation 16384 of database 13017; blocked by process 16.
postgres-slave_1   | 	Process 16 waits for AccessExclusiveLock on relation 16388 of database 13017; blocked by process 75.
worker-slave-2_1   | ERROR:  deadlock detected
postgres-slave_1   | 	Process 75: 
worker-slave-2_1   | LINE 3:        SELECT * FROM va;
postgres-slave_1   | 	       SELECT * FROM vb;
worker-slave-2_1   |                              ^
postgres-slave_1   | 	       SELECT * FROM va;
worker-slave-2_1   | DETAIL:  Process 75 waits for AccessShareLock on relation 16384 of database 13017; blocked by process 16.
postgres-slave_1   | 	    
postgres-slave_1   | 	Process 16: <backend information not available>
worker-slave-2_1   | Process 16 waits for AccessExclusiveLock on relation 16388 of database 13017; blocked by process 75.
postgres-slave_1   | 2018-09-08 11:01:40.275 GMT [75] HINT:  See server log for query details.
worker-slave-2_1   | HINT:  See server log for query details.
postgres-slave_1   | 2018-09-08 11:01:40.275 GMT [75] STATEMENT:  
postgres-slave_1   | 	       SELECT * FROM vb;
postgres-slave_1   | 	       SELECT * FROM va;
postgres-slave_1   | 	    
worker-master_1    | COMMIT
worker-master_1    | COMMIT
worker-master_1    | COMMIT
worker-master_1    | COMMIT
... previous message repeats forever ...
```

All queries to the slave will wait for recovery to finish and recovery is waiting for all queries to finish. This deadlock is not detected and will last forever.

```
krc@krc-desktop:~/work/postgresql-slave-deadlock$ psql -h localhost -p 5632 -U postgres 
psql (10.4 (Ubuntu 10.4-0ubuntu0.18.04), server 10.5 (Ubuntu 10.5-0ubuntu0.18.04))
Type "help" for help.

postgres=# select * from pg_stat_activity;
 datid | datname  | pid | usesysid | usename  | application_name | client_addr | client_hostname | client_port |         backend_start         |          xact_start           |          query_start          |         state_change          | wait_event_type |    wait_event    | state  | backend_xid | backend_xmin |              query              |   backend_type    
-------+----------+-----+----------+----------+------------------+-------------+-----------------+-------------+-------------------------------+-------------------------------+-------------------------------+-------------------------------+-----------------+------------------+--------+-------------+--------------+---------------------------------+-------------------
 13017 | postgres |  98 |       10 | postgres | psql             | 172.18.0.7  |                 |       42318 | 2018-09-09 07:22:31.082122+00 | 2018-09-09 07:22:31.083492+00 | 2018-09-09 07:22:31.083492+00 | 2018-09-09 07:22:31.083493+00 | Lock            | relation         | active |             |          668 |                                +| client backend
       |          |     |          |          |                  |             |                 |             |                               |                               |                               |                               |                 |                  |        |             |              |        SELECT * FROM vb;       +| 
       |          |     |          |          |                  |             |                 |             |                               |                               |                               |                               |                 |                  |        |             |              |        SELECT * FROM va;       +| 
       |          |     |          |          |                  |             |                 |             |                               |                               |                               |                               |                 |                  |        |             |              |                                 | 
 13017 | postgres |  94 |       10 | postgres | psql             | 172.18.0.9  |                 |       54204 | 2018-09-09 07:22:30.04687+00  | 2018-09-09 07:22:30.04822+00  | 2018-09-09 07:22:30.04822+00  | 2018-09-09 07:22:30.048221+00 | Lock            | relation         | active |             |          668 |                                +| client backend
       |          |     |          |          |                  |             |                 |             |                               |                               |                               |                               |                 |                  |        |             |              |        SELECT * FROM vb;       +| 
       |          |     |          |          |                  |             |                 |             |                               |                               |                               |                               |                 |                  |        |             |              |        SELECT * FROM va;       +| 
       |          |     |          |          |                  |             |                 |             |                               |                               |                               |                               |                 |                  |        |             |              |                                 | 
 13017 | postgres |  95 |       10 | postgres | psql             | 172.18.0.6  |                 |       48598 | 2018-09-09 07:22:30.059142+00 | 2018-09-09 07:22:30.060586+00 | 2018-09-09 07:22:30.060586+00 | 2018-09-09 07:22:30.060587+00 | Lock            | relation         | active |             |          668 |                                +| client backend
       |          |     |          |          |                  |             |                 |             |                               |                               |                               |                               |                 |                  |        |             |              |        SELECT * FROM vb;       +| 
       |          |     |          |          |                  |             |                 |             |                               |                               |                               |                               |                 |                  |        |             |              |        SELECT * FROM va;       +| 
       |          |     |          |          |                  |             |                 |             |                               |                               |                               |                               |                 |                  |        |             |              |                                 | 
 13017 | postgres |  96 |       10 | postgres | psql             | 172.18.0.8  |                 |       44222 | 2018-09-09 07:22:30.06381+00  | 2018-09-09 07:22:30.065274+00 | 2018-09-09 07:22:30.065274+00 | 2018-09-09 07:22:30.065276+00 | Lock            | relation         | active |             |          668 |                                +| client backend
       |          |     |          |          |                  |             |                 |             |                               |                               |                               |                               |                 |                  |        |             |              |        SELECT * FROM vb;       +| 
       |          |     |          |          |                  |             |                 |             |                               |                               |                               |                               |                 |                  |        |             |              |        SELECT * FROM va;       +| 
       |          |     |          |          |                  |             |                 |             |                               |                               |                               |                               |                 |                  |        |             |              |                                 | 
 13017 | postgres |  97 |       10 | postgres | psql             | 172.18.0.5  |                 |       47298 | 2018-09-09 07:22:30.065546+00 | 2018-09-09 07:22:30.066788+00 | 2018-09-09 07:22:30.066788+00 | 2018-09-09 07:22:30.066789+00 | Lock            | relation         | active |             |          668 |                                +| client backend
       |          |     |          |          |                  |             |                 |             |                               |                               |                               |                               |                 |                  |        |             |              |        SELECT * FROM vb;       +| 
       |          |     |          |          |                  |             |                 |             |                               |                               |                               |                               |                 |                  |        |             |              |        SELECT * FROM va;       +| 
       |          |     |          |          |                  |             |                 |             |                               |                               |                               |                               |                 |                  |        |             |              |                                 | 
 13017 | postgres |  99 |       10 | postgres | psql             | 172.18.0.1  |                 |       33490 | 2018-09-09 07:23:43.457438+00 | 2018-09-09 07:23:44.661756+00 | 2018-09-09 07:23:44.661756+00 | 2018-09-09 07:23:44.661759+00 |                 |                  | active |             |          668 | select * from pg_stat_activity; | client backend
       |          |  16 |          |          |                  |             |                 |             | 2018-09-09 07:22:29.153518+00 |                               |                               |                               |                 |                  |        |             |              |                                 | startup
       |          |  28 |          |          |                  |             |                 |             | 2018-09-09 07:22:29.272706+00 |                               |                               |                               | Activity        | BgWriterMain     |        |             |              |                                 | background writer
       |          |  27 |          |          |                  |             |                 |             | 2018-09-09 07:22:29.272649+00 |                               |                               |                               | Activity        | CheckpointerMain |        |             |              |                                 | checkpointer
       |          |  32 |          |          |                  |             |                 |             | 2018-09-09 07:22:29.28893+00  |                               |                               |                               | Activity        | WalReceiverMain  |        |             |              |                                 | walreceiver
```
