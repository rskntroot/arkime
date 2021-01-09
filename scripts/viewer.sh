#!/bin/bash

# if switch/first-run exists
if [ -e "/opt/arkime/switch/first-run" ]; then
  # setup arkime
  /opt/arkime/bin/setup.sh;
  
  # remove switch
  rm /opt/arkime/switch/first-run;
fi

# start arkime viewer and logging
echo "INFO - [ Arkime Viewer ] is starting."

cd $ARKIME_DIR/viewer && ../bin/node ./viewer.js -c ../etc/config.ini | tee -a /opt/arkime/log/viewer.log 2>&1

#'lost'21jn
