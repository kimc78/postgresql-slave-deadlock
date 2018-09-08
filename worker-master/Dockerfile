FROM ubuntu

RUN apt-get update
RUN apt-get install -y postgresql-client-10

COPY worker-master.sh .

CMD sleep 5 && ./worker-master.sh