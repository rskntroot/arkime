#!/bin/bash

# setup moloch
/opt/arkime/bin/config.sh

# connect viewer to moloch
cd $ARKIME_DIR/viewer && ../bin/node ./viewer.js -c ../etc/config.ini | tee -a /opt/arkime/logs/viewer.log 2>&1

#'lost'21jn
