#!/bin/bash
if [ ! -e /import/ ]; then echo "No PCAP files were found in the directory: /import/";
else 

# eat pcap for breakfast
for $PCAP_FILE in $(ls /import/* | grep *.pcap); do
	$ARKIME_DIR/bin/moloch-capture -r $PCAP_FILE;
	rm -f $PCAP_FILE;
done;
fi
#'lost'21jn
