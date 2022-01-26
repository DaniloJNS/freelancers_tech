#!/usr/bin/env bash

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER root;
    ALTER USER root WITH SUPERUSER;
    ALTER USER root WITH PASSWORD '$POSTGRES_PASSWORD'
EOSQL
