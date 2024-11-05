#!/usr/bin/env bash

set -eou pipefail

function log () {
    level=$1
    message=$2
    echo $(date  '+%Y-%m-%d %H:%M:%S') [${level}] ${message}
}

# Check if all mandatory env variables are set
test -v HIVE_METASTORE_SERVICE_NAME
test -v HIVE_METASTORE_SERVICE_PORT

test -v HIVE_METASTORE_DATABASE_URL
test -v HIVE_METASTORE_DATABASE_USERNAME
test -v HIVE_METASTORE_DATABASE_PASSWORD

test -v S3_MINIO_ENDPOINT
test -v S3_MINIO_ACCESS_KEY
test -v S3_MINIO_SECRET_KEY

# Check if config template exists and overwrite default file in conf directory
if [ -f "${METASTORE_HOME}/metastore-site.xml" ]; then
  cp ${METASTORE_HOME}/metastore-site.xml ${METASTORE_HOME}/conf/metastore-site.xml
fi

# Patch default log4j2 config to log into stdout
sed -i 's|property.metastore.root.logger = DRFA|property.metastore.root.logger = console|' ${METASTORE_HOME}/conf/metastore-log4j2.properties

# Replace config file templated fields with actual env variable values
sed -i \
  -e "s|%HIVE_METASTORE_SERVICE_NAME%|${HIVE_METASTORE_SERVICE_NAME}|g" \
  -e "s|%HIVE_METASTORE_SERVICE_PORT%|${HIVE_METASTORE_SERVICE_PORT}|g" \
  -e "s|%HIVE_METASTORE_DATABASE_URL%|${HIVE_METASTORE_DATABASE_URL}|g" \
  -e "s|%HIVE_METASTORE_DATABASE_USERNAME%|${HIVE_METASTORE_DATABASE_USERNAME}|g" \
  -e "s|%HIVE_METASTORE_DATABASE_PASSWORD%|${HIVE_METASTORE_DATABASE_PASSWORD}|g" \
  -e "s|%S3_MINIO_ENDPOINT%|${S3_MINIO_ENDPOINT:-}|g" \
  -e "s|%S3_MINIO_ACCESS_KEY%|${S3_MINIO_ACCESS_KEY:-}|g" \
  -e "s|%S3_MINIO_SECRET_KEY%|${S3_MINIO_SECRET_KEY:-}|g" \
  ${METASTORE_HOME}/conf/metastore-site.xml

# Start Hive Metastore server
log "INFO" "Starting Hive Metastore service"
exec "${METASTORE_HOME}/bin/start-metastore"
