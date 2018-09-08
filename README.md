# How to run

`docker-compose up --force-recreate --abort-on-container-exit --build`

wait for all docker containers to build and launch

You will get alot of about like this
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

The postgres_slave will now halt queries to wait for recovery and recovery will wait for the completion of query. This lock will never be released and you need to abort all queries on the slave to recover.
