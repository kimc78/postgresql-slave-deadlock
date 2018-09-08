#!/bin/bash

echo 'Work starting on master'

while true; do
    psql -h postgres-master -U postgres -c "
        BEGIN; 
          CREATE OR REPLACE VIEW va AS SELECT 1; 
          CREATE OR REPLACE VIEW vb as SELECT 2; 
        COMMIT; 
    "
done
