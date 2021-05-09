#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/logstash/bin/logstash-plugin install logstash-output-newrelic

# Load Logstash environment variables
eval "$(logstash_env)"