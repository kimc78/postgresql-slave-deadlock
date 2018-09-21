FROM ubuntu

RUN apt-get update
RUN apt-get install -y wget ca-certificates gnupg lsb-release software-properties-common
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN add-apt-repository "deb https://apt.postgresql.org/pub/repos/apt/ $(lsb_release -s -c)-pgdg-testing main 11"

RUN apt-get update
RUN apt-cache policy libpq5 
RUN apt-get install -y postgresql-11 postgresql-client-11 libpq5=11~beta4-1.pgdg18.04+1

RUN echo "host replication all 0.0.0.0/0  trust" >> /var/lib/postgresql/11/main/pg_hba.conf
RUN echo "host all         all 0.0.0.0/0  trust" >> /var/lib/postgresql/11/main/pg_hba.conf

RUN echo "listen_addresses = '*'"                >> /var/lib/postgresql/11/main/postgresql.conf

CMD su postgres -c "/usr/lib/postgresql/11/bin/postgres -D /var/lib/postgresql/11/main"

