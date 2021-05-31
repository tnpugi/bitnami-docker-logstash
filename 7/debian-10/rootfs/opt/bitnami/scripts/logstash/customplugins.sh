#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/liblogstash.sh

# Load Logstash environment variables
eval "$(logstash_env)"

info "Temporarily setting up heap size to 512m ..."
LOGSTASH_HEAP_SIZE_ORIG=$LOGSTASH_HEAP_SIZE
LOGSTASH_HEAP_SIZE=512m
logstash_set_heap_size

info "Installing additional logstash plugins..."
/opt/bitnami/logstash/bin/logstash-plugin install logstash-output-newrelic
/opt/bitnami/logstash/bin/logstash-plugin install logstash-output-jdbc


info "Setting LOGSTASH_HEAP_SIZE to configured default ..."
LOGSTASH_HEAP_SIZE=$LOGSTASH_HEAP_SIZE_ORIG
