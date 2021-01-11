#!/bin/bash

err_msg () { printf '\033[0;31m[ ERROR ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }
warn_msg () { printf '\033[1;33m[ WARN ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }
info_msg () { printf '\033[0;36m[ INFO ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }

## INITIALIZE DATABASE ##
#
info_msg "Initializing ElasticSearch database...";

echo INIT | /data/moloch/db/db.pl http://elasticsearch:9200 init | tee -a /arkime/log/$(hostname).log > /dev/null;

info_msg "ElasticSearch database was initialized."

#'lost'21jn
