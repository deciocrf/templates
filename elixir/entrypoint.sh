#!/bin/bash
set -e

# Ensure the app's dependencies are installed
mix deps.get

# Wait until Postgres is ready
while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  createdb -E UTF8 $PGDATABASE -l en_US.UTF-8 -T template0
  
  # This creates the db, migrates the db, and then seeds the db 
  mix ecto.setup

  echo "Database $PGDATABASE created."
fi

mix phx.server
