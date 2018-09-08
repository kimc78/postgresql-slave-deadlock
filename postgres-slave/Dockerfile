FROM ubuntu
RUN apt-get update
RUN apt-get install -y postgresql-10

RUN rm -rf /var/lib/postgresql/10/main/*

RUN echo "host all all 0.0.0.0/0 trust"                        >> /tmp/pg_hba.conf
RUN echo "listen_addresses = '*'"                              >> /tmp/postgresql.conf
RUN echo "max_standby_streaming_delay=-1"                      >> /tmp/postgresql.conf

RUN echo "standby_mode = true"                                 >> /tmp/recovery.conf
RUN echo "primary_conninfo = 'host=postgres-master port=5432'" >> /tmp/recovery.conf

CMD su postgres -c " \
  sleep 3 && \
  pg_basebackup -h postgres-master -U postgres -D /var/lib/postgresql/10/main -P  && \
  cp /tmp/recovery.conf /var/lib/postgresql/10/main && \
  cp /tmp/pg_hba.conf /var/lib/postgresql/10/main && \
  cp /tmp/postgresql.conf /var/lib/postgresql/10/main && \
  /usr/lib/postgresql/10/bin/postgres -D /var/lib/postgresql/10/main \
  "

