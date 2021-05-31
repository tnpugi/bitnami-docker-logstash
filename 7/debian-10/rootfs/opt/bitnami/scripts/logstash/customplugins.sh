#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/liblogstash.sh

# Load Logstash environment variables
eval "$(logstash_env)"

info "Temporarily setting up heap size to 512m ..."
LOGSTASH_HEAP_SIZE_ORIG=$LOGSTASH_HEAP_SIZE
LOGSTASH_HEAP_SIZE=512m
logstash_set_heap_size

info "> Installing additional logstash-output-newrelic plugin and deps..."
/opt/bitnami/logstash/bin/logstash-plugin install logstash-output-newrelic
info "< Installed logstash-output-newrelic plugin and deps..."

info "> Installing additional logstash-output-jdbc plugin and deps..."
LOGSTASH_OUTPUT_JDBC_DRIVERS="$LOGSTASH_HOME/vendor/jar/jdbc"
/opt/bitnami/logstash/bin/logstash-plugin install logstash-output-jdbc
ensure_dir_exists "$LOGSTASH_OUTPUT_JDBC_DRIVERS"
curl -o $LOGSTASH_OUTPUT_JDBC_DRIVERS/postgresql-42.2.20.jar https://jdbc.postgresql.org/download/postgresql-42.2.20.jar
chmod -R g+rwX "$LOGSTASH_OUTPUT_JDBC_DRIVERS"
info "< Installed logstash-output-jdbc plugin and deps..."


info "Setting LOGSTASH_HEAP_SIZE to configured default ..."
LOGSTASH_HEAP_SIZE=$LOGSTASH_HEAP_SIZE_ORIG

