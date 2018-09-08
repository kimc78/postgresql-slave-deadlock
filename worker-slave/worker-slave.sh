#!/bin/bash

echo 'Work starting on slave'

while true; do
    psql -h postgres-slave -U postgres -c "
       SELECT * FROM vb;
       SELECT * FROM va;
    "
done
