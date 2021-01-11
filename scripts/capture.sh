#!/bin/bash

err_msg () { printf '\033[0;31m[ ERROR ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }
warn_msg () { printf '\033[1;33m[ WARN ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }
info_msg () { printf '\033[0;36m[ INFO ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }

FLAG="/arkime/flags"

info_msg "[ Arkime Capture ] has been started."
info_msg "TODO - Explain running on specified interface..."

## WAIT FOR ELASTICSEARCH TO COME ONLINE ##
#
while [ "$(curl elasticsearch:9200/_cluster/health?pretty 2> /dev/null | grep status | awk -F '"' '{print $4}')" != "green" ]; do 
  warn_msg "Waiting for ElasticSearch to come online."; 
  sleep 5; 
done

info_msg "ElasticSearch is online."

## CONFIGURE ARKIME & CREATE USER ##
#
if [ -e "$FLAG/conf_import" ]; then

  /arkime/bin/config.sh;

  ## WAIT FOR INIT-DB ##
  #
  while [ "$(curl viewer:8005 2> /dev/null)" != "Unauthorized" ]; do 
    warn_msg "Waiting for [ Arkime Viewer ] to come online.";
    sleep 5; 
  done;

  info_msg "[ Arkime Viewer ] is online!";

  ## CREATE USER ## 
  #
  /arkime/bin/add-user.sh;

  rm $FLAG/conf_import;
fi

## CREATE PCAP DATASTORE ##
#
if [ ! -e "/arkime/data" ]; then 
  info_msg "Creating datastore at /arkime/data."
  mkdir -p /arkime/data; 
else
  info_msg "Datastore found at /arkime/data."
  ls -lh /arkime/data;
fi

## ENABLE PCAP DOWNLOAD FROM VIEWER ##
#
info_msg "Enabling access to imported .pcap files for [ Arkime Viewer ] over port 8005."
cd $ARKIME_DIR/viewer && ../bin/node ./viewer.js -c ../etc/config.ini | tee -a /arkime/log/import.log 2>&1 &

## RUN ARKIME CAPTURE ##
#

err_msg "Powering down [ Arkime Capture ]..."

#'lost'21jn
