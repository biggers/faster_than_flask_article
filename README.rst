Faster than Flask
=================

This is the code to accompany an `article
<https://medium.com/@pgjones/6x-faster-than-flask-8e89bfbe8e4f>`_.


Running
-------

Assuming you have at least Python 3.6, firstly to setup:

.. code-block::

  python -m venv venv
  source venv/bin/activate

  # "install" PostgreSQL, as below, then do:

  pip install -r app/requirements.txt
  cd app && gunicorn --config gunicorn.py 'run:create_app()'

Using ``Docker`` and ``docker-compose``, to get a ``postgresql`` service:

.. code-block::

  alias dc=docker-compose

  dc up -d  # bring up PostgreSQL container, specified in 'docker-compose.yml'
  dc logs   # verify something is running
  nc -v localhost 5432  # make sure we have a connection to PgSQL service

Run these ``dvdrental`` database set-up(s) "manually", for now.

First, download and unzip the ``dvdrental`` database, from
http://www.postgresqltutorial.com/postgresql-sample-database/.

.. code-block::

  unzip -x docker-entrypoint-initdb.d/dvdrental.zip
  mv dvdrental.tar  ./docker-entrypoint-initdb.d

  ## Load the 'dvdrental' DB

  PROJECT=fasterthanflaskarticle_db_1
  USER=dvdrental

  docker exec -i ${PROJECT} pg_restore --verbose --username ${USER} --dbname ${USER} --no-password < "./docker-entrypoint-initdb.d/dvdrental.tar"

  ## Create the extra Table 'review', in the 'dvdrental' DB

  docker exec -i ${PROJECT}   psql -v --username ${USER} --dbname ${USER} <<-EOSQL00
    CREATE TABLE review (
      film_id INTEGER REFERENCES film(film_id),
	rating INTEGER
    );
  EOSQL00


Performance measurement
-----------------------

The commands used to measure the performance of the apps are,

.. code-block::

   $ wrk --connections 20 --duration 5m http://localhost:5000/films/
   $ wrk --connections 20 --duration 5m http://localhost:5000/films/995/
   $ wrk --connections 20 --duration 5m --script post.lua http://localhost:5000/reviews/

Database
--------

All of the above assumes you have the `Postgres sample database
<http://www.postgresqltutorial.com/postgresql-sample-database/>`_
running locally with the following addition made,

.. code-block:: sql

   CREATE TABLE review (
       film_id INTEGER REFERENCES film(film_id),
        rating INTEGER
   );

and a dvdrental user/role to access the database.
