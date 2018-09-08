FROM ubuntu

RUN apt-get update
RUN apt-get install -y postgresql-client-10

COPY worker-slave.sh .

CMD sleep 5 && ./worker-slave.sh