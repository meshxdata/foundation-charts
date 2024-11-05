#!/usr/bin/env bash

set -euo pipefail

function log () {
    level=$1
    message=$2
    echo $(date  '+%Y-%m-%d %H:%M:%S') [${level}]  ${message}
}

test -v HIVE_METASTORE_DATABASE_URL
test -v HIVE_METASTORE_DATABASE_USERNAME
test -v HIVE_METASTORE_DATABASE_PASSWORD

# Check if custom config file exists and overwrite default in conf directory
if [ -f "${METASTORE_HOME}/metastore-site.xml" ]; then
  cp ${METASTORE_HOME}/metastore-site.xml ${METASTORE_HOME}/conf/metastore-site.xml
fi

sed -i \
  -e "s|%HIVE_METASTORE_DATABASE_URL%|${HIVE_METASTORE_DATABASE_URL}|g" \
  -e "s|%HIVE_METASTORE_DATABASE_USERNAME%|${HIVE_METASTORE_DATABASE_USERNAME}|g" \
  -e "s|%HIVE_METASTORE_DATABASE_PASSWORD%|${HIVE_METASTORE_DATABASE_PASSWORD}|g" \
  ${METASTORE_HOME}/conf/metastore-site.xml

# Upgrade hive metastore database schema:
log "INFO" "Running upgrade of Hive Metastore PostgreSQL schema"
${METASTORE_HOME}/bin/schematool -dbType postgres -upgradeSchema
