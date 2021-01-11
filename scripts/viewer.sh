#!/bin/bash

err_msg () { printf '\033[0;31m[ ERROR ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }
warn_msg () { printf '\033[1;33m[ WARN ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }
info_msg () { printf '\033[0;36m[ INFO ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }

FLAG="/opt/arkime/flags"

info_msg "[ Arkime Viewer ] has been started."

## WAIT FOR ELASTICSEARCH TO COME ONLINE ##
#
while [ "$(curl elasticsearch:9200/_cluster/health?pretty 2> /dev/null | grep status | awk -F '"' '{print $4}')" != "green" ]; do 
  warn_msg "Waiting for Elasticsearch to come online."; 
  sleep 5; 
done

## CONFIGURE ARKIME ##
#
if [ -e "$FLAG/conf_viewer" ]; then
  /opt/arkime/bin/config.sh;
fi

## INITIALIZE DATABASE AND CREATE ADMIN USER ##
#
if [ -e "$FLAG/init_db" ]; then
  /opt/arkime/bin/init-db.sh;
  rm $FLAG/init_db;
fi

## CREATE USER ##
#
if [ -e "$FLAG/conf_viewer" ]; then
  /opt/arkime/bin/add-user.sh;
  rm $FLAG/conf_viewer;
fi

## START [ ARKIME VIEWER ] WITH LOGGING ##
#
info_msg "[ Arkime Viewer ] is starting..."

cd $ARKIME_DIR/viewer && ../bin/node ./viewer.js -c ../etc/config.ini | tee -a /opt/arkime/log/viewer.log 2>&1

warn_msg "[ Arkime Viewer ] was stopped."
#'lost'21jn
