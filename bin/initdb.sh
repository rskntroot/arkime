#!/bin/bash

err_msg () { echo -e "$(printf '\033[0;31m[ ERROR ]\033[0m') $(date +"%Y-%m-%dT%H:%M:%S%z") $BASH_SOURCE $1"; }
warn_msg () { echo -e "$(printf '\033[1;33m[ WARN ]\033[0m') $(date +"%Y-%m-%dT%H:%M:%S%z") $BASH_SOURCE $1"; }
info_msg () { echo -e "$(printf '\033[0;36m[ INFO ]\033[0m') $(date +"%Y-%m-%dT%H:%M:%S%z") $BASH_SOURCE $1"; }

## INITIALIZE DATABASE ##
#
info_msg "Initializing ElasticSearch database...";

$ARKIME_DIR/db/db.pl http://$ES_HOST:9200 init | tee -a $LOCAL_DIR/log/$(hostname).log > /dev/null;

info_msg "ElasticSearch database was initialized."

#'lost'22fr
