#!/usr/bin/env bash

set -eou pipefail

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

# Check if hive metastore database schema exist, create one if not:

log "INFO" "Check for the version of Hive Metastore database schema"
check_result=0
${METASTORE_HOME}/bin/schematool -dbType postgres -info || check_result=$?

if [ $check_result -ne 0 ]; then
  log "INFO" "Hive Metastore database schema does not exist, initializing..."
  init_result=0
  ${METASTORE_HOME}/bin/schematool -dbType postgres -initSchema || init_result=$?
  if [ $init_result -ne 0 ]; then
    log "ERROR" "${init_result}"
    log "ERROR" "Error initializing Hive Metastore database, exit..."
    exit 1
  else
    log "INFO" "Hive Metastore schema successfully initialized, exit..."
    exit 0
  fi
else
  log "INFO" "Hive Metastore schema already present, continue..."
  exit 0
fi
