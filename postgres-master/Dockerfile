FROM ubuntu
RUN apt-get update
RUN apt-get install -y postgresql-10

RUN echo "host replication all 0.0.0.0/0  trust" >> /var/lib/postgresql/10/main/pg_hba.conf
RUN echo "host all         all 0.0.0.0/0  trust" >> /var/lib/postgresql/10/main/pg_hba.conf

RUN echo "listen_addresses = '*'"                >> /var/lib/postgresql/10/main/postgresql.conf

CMD su postgres -c "/usr/lib/postgresql/10/bin/postgres -D /var/lib/postgresql/10/main"

