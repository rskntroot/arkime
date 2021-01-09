#!/bin/bash

# wait for elasticsearch to come online
while [ "$(curl elasticsearch:9200/_cluster/health?pretty 2> /dev/null | grep status | awk -F '"' '{print $4}')" != "green" ]; do 
  echo "INFO - Waiting for Elasticsearch to come online."; 
  sleep 5; 
done

# configure arkime
/opt/arkime/bin/config.sh

# if switch/init-db exists
if [ -e "/opt/arkime/switch/init-db" ]; then

  # initialize es database
  echo "DEBUG - /opt/arkime/log/first_run contains 1.";
  echo "INFO - The elasticsearch database will be initialized.";

  echo INIT | /data/moloch/db/db.pl http://elasticsearch:9200 init;

  # set default creds if none specified
  if [ -z $ARKIME_USER ]; then ARKIME_USER="root"; fi;
  if [ -z $ARKIME_PSWD ]; then ARKIME_PSWD="arkime-pswd"; fi;

  # create admin user
  echo "INFO - Arkime Admins user created: "$ARKIME_USER;
  echo "INFO - The admin password was set: "$ARKIME_PSWD;

  $ARKIME_DIR/bin/moloch_add_user.sh $ARKIME_USER "Arkime Admin" $ARKIME_PSWD --admin;

  # remove switch/init-db
  rm /opt/arkime/bin/switch/init-db;

else
  echo "INFO - The elasticsearch database will NOT be initialized.";
fi

#'lost'21jn
