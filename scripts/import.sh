#!/bin/bash

err_msg () { printf '\033[0;31m[ ERROR ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }
warn_msg () { printf '\033[1;33m[ WARN ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }
info_msg () { printf '\033[0;36m[ INFO ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }

FLAG="/opt/arkime/flags"

info_msg "[ Arkime Import ] has been started."
info_msg "All .pcap files in %root%/arkime/import will be imported then deleted."

## LIST FILES IN IMPORT DIRECTORY ##
#
info_msg "The following files exist in the import directory:"
ls -alh /import

## WAIT FOR ELASTICSEARCH TO COME ONLINE ##
#
while [ "$(curl elasticsearch:9200/_cluster/health?pretty 2> /dev/null | grep status | awk -F '"' '{print $4}')" != "green" ]; do 
  warn_msg "Waiting for Elasticsearch to come online."; 
  sleep 5; 
done

## WAIT FOR INIT DB ##
#
# TO DO

## CONFIGURE ARKIME - IF FLAG SET ##
#
if [ -e "$FLAG/conf_import" ]; then

  info_msg "Configuring [ Arkime Import ]...";
  /opt/arkime/bin/config.sh;
  
  info_msg "[ Arkime Import ] configured.";
  rm $FLAG/conf_import;

fi

## CHECK FOR PCAP FILES ##
#
if [ -z $(ls /import/*.pcap) ]; then
  warn_msg "No .pcap files were found."
else

  ## EAT PCAP FOR BREAKFAST
  #
  info_msg "Importing .pcap files..."
  for PCAP_FILE in $(ls /import/* | grep '\.pcap'); do
    
    info_msg "Importing: "$PCAP_FILE;
    $ARKIME_DIR/bin/moloch-capture -r $PCAP_FILE;

    info_msg "Deleting: "$PCAP_FILE;
    rm -f $PCAP_FILE;
  done;

  info_msg "Import complete."
fi
warn_msg "Powering down [ Arkime Import ]."
#'lost'21jn

# docker run -it --name import -v $(pwd)/arkime/import:/import rskntroot/arkime:2.7.1-1 /bin/bash 