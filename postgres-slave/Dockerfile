FROM ubuntu
RUN apt-get update
RUN apt-get install -y wget ca-certificates gnupg lsb-release software-properties-common
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN add-apt-repository "deb https://apt.postgresql.org/pub/repos/apt/ $(lsb_release -s -c)-pgdg-testing main 11"

RUN apt-get update
RUN apt-cache policy libpq5 
RUN apt-get install -y postgresql-11 postgresql-client-11 libpq5=11~beta4-1.pgdg18.04+1

RUN rm -rf /var/lib/postgresql/11/main/*

RUN echo "host all all 0.0.0.0/0 trust"                        >> /tmp/pg_hba.conf
RUN echo "listen_addresses = '*'"                              >> /tmp/postgresql.conf
RUN echo "max_standby_streaming_delay=-1"                      >> /tmp/postgresql.conf

RUN echo "standby_mode = true"                                 >> /tmp/recovery.conf
RUN echo "primary_conninfo = 'host=postgres-master port=5432'" >> /tmp/recovery.conf

CMD su postgres -c " \
  sleep 3 && \
  pg_basebackup -h postgres-master -U postgres -D /var/lib/postgresql/11/main -P  && \
  cp /tmp/recovery.conf /var/lib/postgresql/11/main && \
  cp /tmp/pg_hba.conf /var/lib/postgresql/11/main && \
  cp /tmp/postgresql.conf /var/lib/postgresql/11/main && \
  /usr/lib/postgresql/11/bin/postgres -D /var/lib/postgresql/11/main \
  "

