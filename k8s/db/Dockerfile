FROM postgres:15

COPY create.sql /docker-entrypoint-initdb.d/
COPY init-db.sh /docker-entrypoint-initdb.d/

RUN chmod 755 /docker-entrypoint-initdb.d/init-db.sh

ENV POSTGRES_PASSWORD=424242
ENV POSTGRES_DB=currency_converter