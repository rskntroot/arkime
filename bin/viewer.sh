#!/bin/bash

err_msg () { echo -e "$(printf '\033[0;31m[ ERROR ]\033[0m') $(date +"%Y-%m-%dT%H:%M:%S%z") $BASH_SOURCE $1"; }
warn_msg () { echo -e "$(printf '\033[1;33m[ WARN ]\033[0m') $(date +"%Y-%m-%dT%H:%M:%S%z") $BASH_SOURCE $1"; }
info_msg () { echo -e "$(printf '\033[0;36m[ INFO ]\033[0m') $(date +"%Y-%m-%dT%H:%M:%S%z") $BASH_SOURCE $1"; }

FLAG="$LOCAL_DIR/bin/flags"

info_msg "[ Arkime Viewer ] has been started."

## WAIT FOR ELASTICSEARCH TO COME ONLINE ##
#
while [ "$(curl http://$ES_HOST:9200/_cluster/health?pretty 2> /dev/null | grep status | awk -F '"' '{print $4}')" != "green" ]; do 
  warn_msg "Waiting for Elasticsearch to come online."; 
  sleep 5; 
done

info_msg "ElasticSearch is online.";

## CONFIGURE ARKIME ##
#
if [ -e "$FLAG/conf_arkime" ]; then
  $LOCAL_DIR/bin/config.sh;
fi

## INITIALIZE DATABASE ##
#
if [ -e "$FLAG/init_db" ]; then
  $LOCAL_DIR/bin/initdb.sh;
  rm $FLAG/init_db;
fi

## CREATE USER ##
#
if [ -e "$FLAG/conf_arkime" ]; then
  ## OFFLOAD AUTH IF NECESSARY ##
  #
  if [ -z $OFFLOAD_AUTH ]; then
    sed -i 's/passwordSecret/#passwordSecret/' $LOCAL_DIR/etc/config.ini;
  else
    $LOCAL_DIR/bin/addusr.sh;
  fi

  rm $FLAG/conf_arkime;
fi

## START [ ARKIME VIEWER ] WITH LOGGING ##
#
info_msg "Starting [ Arkime Viewer ] webserver on port 8005..."

$ARKIME_DIR/bin/node $ARKIME_DIR/viewer/viewer.js -c $ARKIME_DIR/etc/config.ini | tee -a $LOCAL_DIR/log/$(hostname).log 2>&1

err_msg "Powering down [ Arkime Viewer ]..."
#'lost'22fr
