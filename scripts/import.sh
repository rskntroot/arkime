#!/bin/bash

err_msg () { printf '\033[0;31m[ ERROR ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }
warn_msg () { printf '\033[1;33m[ WARN ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }
info_msg () { printf '\033[0;36m[ INFO ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }

FLAG="/opt/arkime/flags"

info_msg "[ Arkime Import ] has been started."
info_msg "All .pcap files from %root%/arkime/import will be moved to the datastore then read into Arkime."

## WAIT FOR ELASTICSEARCH TO COME ONLINE ##
#
while [ "$(curl elasticsearch:9200/_cluster/health?pretty 2> /dev/null | grep status | awk -F '"' '{print $4}')" != "green" ]; do 
  warn_msg "Waiting for Elasticsearch to come online."; 
  sleep 5; 
done

## CONFIGURE ARKIME & CREATE USER ##
#
if [ -e "$FLAG/conf_import" ]; then

  /opt/arkime/bin/config.sh;

  ## WAIT FOR INIT-DB ##
  #
  while [ "$(curl viewer:8005 2> /dev/null)" != "Unauthorized" ]; do 
    warn_msg "Waiting for [ Arkime Viewer ] to come online.";
    sleep 5; 
  done;

  ## CREATE USER ## 
  #
  /opt/arkime/bin/add-user.sh;

  rm $FLAG/conf_import;
fi

## CREATE PCAP DATASTORE ##
#
if [ ! -e "/opt/arkime/data" ]; then 
  info_msg "Creating datastore at /opt/arkime/data."
  mkdir -p /opt/arkime/data; 
else
  info_msg "Datastore found at /opt/arkime/data."
  ls -lh /opt/arkime/data;
fi

## ENABLE PCAP DOWNLOAD FROM VIEWER ##
#
info_msg "Enabling access to imported .pcap files for [ Arkime Viewer ] over port 8005."
cd $ARKIME_DIR/viewer && ../bin/node ./viewer.js -c ../etc/config.ini | tee -a /opt/arkime/log/import.log 2>&1 &

## RUN IMPORT INDEFINITELY EVERY 60 SECONDS ##
#
while :; do

  ## CHECK FOR PCAP FILES ##
  #
  if [ -z $(ls /import/*.pcap 2> /dev/null) ]; then
    warn_msg "No .pcap files were found in the import directory."
  else
  
    ## LIST FILES IN IMPORT DIRECTORY ##
    #
    info_msg "The following files exist in the import directory:"
    ls -alh /import
  
    ## EAT PCAP FOR BREAKFAST
    #
    info_msg "Importing .pcap files..."
    for PCAP_FILE in $(ls /import | grep '\.pcap'); do
      
      info_msg "Moving "$PCAP_FILE" to datastore.";
      mv /import/$PCAP_FILE /opt/arkime/data/$PCAP_FILE;
  	
      info_msg "Importing: "$PCAP_FILE;
      $ARKIME_DIR/bin/moloch-capture -r /opt/arkime/data/$PCAP_FILE | tee -a /opt/arkime/log/import.log 2>&1;
  
    done;
    info_msg "Import complete."
  fi;

  sleep 60;

done

warn_msg "Powering down [ Arkime Import ]."

#'lost'21jn
