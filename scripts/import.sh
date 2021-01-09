#!/bin/bash

err_msg () { printf '\033[0;31m[ ERROR ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }
warn_msg () { printf '\033[1;33m[ WARN ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }
info_msg () { printf '\033[0;36m[ INFO ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }

if [ ! -e /import/ ]; then 
  err_msg "No .pcap files were found in the import directory.";
else 

  warn_msg "Files are deleted after import.";

  # eat pcap for breakfast
  for $PCAP_FILE in $(ls /import/* | grep *.pcap); do

    info_msg "Importing: "$PCAP_FILE;
    $ARKIME_DIR/bin/moloch-capture -r $PCAP_FILE;
    rm -f $PCAP_FILE;
  done;
fi

info_msg "Import completed task, powering off container." 
#'lost'21jn
