#!/bin/bash

err_msg () { printf '\033[0;31m[ ERROR ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }
warn_msg () { printf '\033[1;33m[ WARN ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }
info_msg () { printf '\033[0;36m[ INFO ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }

FLAG="/opt/arkime/flags"

## WAIT FOR ELASTICSEARCH TO COME ONLINE ##
#
while [ "$(curl elasticsearch:9200/_cluster/health?pretty 2> /dev/null | grep status | awk -F '"' '{print $4}')" != "green" ]; do 
  warn_msg "Waiting for Elasticsearch to come online."; 
  sleep 5; 
done

## SETUP ON FIRST RUN ##
#
if [ -e "$FLAG/first-run" ]; then
  # setup arkime
  info_msg "Running setup script...";
  /opt/arkime/bin/setup.sh;
  
  # remove switch
  rm $FLAG/first-run;
  info_msg "Setup script completed.";
fi

## START [ ARKIME VIEWER ] WITH LOGGING ##
#
info_msg "[ Arkime Viewer ] is starting."

cd $ARKIME_DIR/viewer && ../bin/node ./viewer.js -c ../etc/config.ini | tee -a /opt/arkime/log/viewer.log 2>&1

warn_msg "[ Arkime Viewer ] was stopped."
#'lost'21jn
