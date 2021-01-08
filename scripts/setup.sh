#!/bin/bash

# validate all fields are created
if [ -z $ELASTIC_HOST ]; then echo "No elasticsearch node was specified in ENV: ELASTIC_HOST";
else
        # initialize database
        echo INIT | $ARKIME_DIR/db/db.pl http://$ELASTIC_HOST:9200 init;
fi
#'lost'21jn
