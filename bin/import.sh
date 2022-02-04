#!/bin/bash

err_msg () { echo -e "$(printf '\033[0;31m[ ERROR ]\033[0m') $(date +"%Y-%m-%dT%H:%M:%S%z") $BASH_SOURCE $1"; }
warn_msg () { echo -e "$(printf '\033[1;33m[ WARN ]\033[0m') $(date +"%Y-%m-%dT%H:%M:%S%z") $BASH_SOURCE $1"; }
info_msg () { echo -e "$(printf '\033[0;36m[ INFO ]\033[0m') $(date +"%Y-%m-%dT%H:%M:%S%z") $BASH_SOURCE $1"; }

FLAG="$LOCAL_DIR/bin/flags"

info_msg "[ Arkime Import ] has been started."

## WAIT FOR ELASTICSEARCH TO COME ONLINE ##
#
while [ "$(curl http://$ES_HOST:9200/_cluster/health?pretty 2> /dev/null | grep status | awk -F '"' '{print $4}')" != "green" ]; do 
  warn_msg "Waiting for ElasticSearch to come online..."; 
  sleep 5; 
done

info_msg "ElasticSearch is online."

## CONFIGURE ARKIME & CREATE USER ##
#
if [ -e "$FLAG/conf_arkime" ]; then

  $LOCAL_DIR/bin/config.sh;

  ## WAIT FOR INIT-DB ##
  #
  while [ "$(curl http://$ARKIME_VIEWER:8005 2> /dev/null)" != "Unauthorized" ]; do 
    warn_msg "Waiting for [ Arkime Viewer ] to come online...";
    sleep 5; 
  done;

  info_msg "[ Arkime Viewer ] is online.";

  ## CREATE USER ## 
  #
  $LOCAL_DIR/bin/addusr.sh;

  rm $FLAG/conf_arkime;
fi

## ENABLE PCAP DOWNLOAD THROUGH NODES VIEWER ##
#
info_msg "Enabling access to imported .pcap files for [ Arkime Viewer ] over port 8005."
$ARKIME_DIR/bin/node $ARKIME_DIR/viewer/viewer.js -c ../etc/config.ini | tee -a $LOCAL_DIR/log/$(hostname).log > /dev/null &

info_msg "[ Arkime Import ] will now watch for %root%/import/ for .pcap files."

## RUN IMPORT CHECK EVERY 60 SECONDS ##
#
while :; do

  ## CHECK FOR PCAP FILES ##
  #
  IMPORT_FILES=$(ls /import/ | grep -e '\.pcap$');
  for PCAP in $IMPORT_FILES; do
    if [ -n $PCAP ]; then

      ## EAT PCAP FOR BREAKFAST ##
      #
      info_msg "Importing: "$PCAP;
      chmod 644 /import/$PCAP > /dev/null;
      mv /import/$PCAP /data/arkime/pcap/$PCAP;
      $ARKIME_DIR/bin/capture -r $ARKIME_DIR/raw/$PCAP | tee -a $LOCAL_DIR/log/$(hostname).log > /dev/null;
      info_msg "Import complete. Now waiting for more .pcap files...";

    fi;
  done;

  sleep 60;
done

err_msg "Powering down [ Arkime Import ]..."

#'lost'21jn
