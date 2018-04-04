#!/bin/bash
set -e

# psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL01
#   CREATE USER dvdrental;
#   CREATE ROLE dvdrental;
#   CREATE DATABASE dvdrental;
#   GRANT ALL PRIVILEGES ON DATABASE dvdrental TO dvdrental;
# EOSQL01

# Run these "manually" for now:

PROJECT=fasterthanflaskarticle_db_1
USER=dvdrental

## load the 'dvdrental' DB
docker exec -i ${PROJECT} pg_restore --verbose --username ${USER} --dbname ${USER} --no-password < "./docker-entrypoint-initdb.d/dvdrental.tar"

## create the extra-table in 'dvdrental' DB
docker exec -i ${PROJECT}   psql -v --username ${USER} --dbname ${USER} <<-EOSQL00
  CREATE TABLE review (
    film_id INTEGER REFERENCES film(film_id),
      rating INTEGER
  );
EOSQL00
