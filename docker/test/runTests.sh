#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -gt 0 ]
then
  SCRIPT_NAME=$(basename "$0")
  echo "Usage: $SCRIPT_NAME"
  exit 1
fi

# configure trap to always stop and remove postgres container at the end
trap 'echo "Stopping postgres container"; docker stop bonita_db' INT TERM EXIT

# start postgres container
POSTGRES_VERSION=12.6
POSTGRES_PASSWORD=s3crEt
docker run --rm --name bonita_db -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} -d postgres:${POSTGRES_VERSION}

# wait for postgres
until docker run --rm --link bonita_db postgres:${POSTGRES_VERSION} pg_isready -h bonita_db -p 5432; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done
>&2 echo "Postgres is up!"

# start bonita container tests
: ${BONITA_VERSION:=$(grep -oP "^ENV BONITA_VERSION \K.*" "../Dockerfile" | sed 's/.*:-\(.*\)}$/\1/' | tail -1)}

DGOSS_CMD="dgoss run --rm --name bonita_${BONITA_VERSION} --link bonita_db \
-e DB_VENDOR=postgres -e DB_HOST=bonita_db -e DB_PORT=5432 -e DB_ADMIN_PASS=${POSTGRES_PASSWORD} \
-e TENANT_LOGIN=tenant_admin -e TENANT_PASSWORD=tenant_pass \
-e PLATFORM_LOGIN=platform_admin -e PLATFORM_PASSWORD=platform_pass \
-v $(pwd)/custom-init.d:/opt/custom-init.d"

export GOSS_WAIT_OPTS="-r 60s -s 2s > /dev/null"

export GOSSFILE=goss_community.yaml
goss -g goss_main.yaml render > goss.yaml && ${DGOSS_CMD} \
bonitasoft/bonita:${BONITA_VERSION}
