#!/bin/bash

# required for moloch to work
if [ -z $ELASTIC_HOST ]; then
	
	# let the bois know
	echo "No database specified in ENV: ELASTIC_HOST";
else 

	# run the default setup script
	echo -e "\nno\n\nno\nno\nno" | $ARKIME_DIR/bin/Configure;

	# remove existing config.ini
	if [ -e $ARKIME_DIR/etc/config.ini ]; then rm -f $ARKIME_DIR/etc/config.ini; fi;
	
	# use default interface if none specified
	if [ -z $CAP_INTERFACE ]; then  CAP_INTERFACE=eth1; fi;
	
	cat <<EOF > $ARKIME_DIR/etc/config.ini
[default]
elasticsearch=http://$ELASTIC_HOST:9200
rotateIndex=daily
passwordSecret = no
httpRealm = Moloch
interface=$CAP_INTERFACE
pcapDir = /data/moloch/raw
maxFileSizeG = 12
tcpTimeout = 600
tcpSaveTimeout = 720
udpTimeout = 30
icmpTimeout = 10
maxStreams = 1000000
maxPackets = 10000
freeSpaceG = 5%
viewPort = 8005
geoLite2Country = /usr/share/GeoIP/GeoLite2-Country.mmdb;/data/moloch/etc/GeoLite2-Country.mmdb
geoLite2ASN = /usr/share/GeoIP/GeoLite2-ASN.mmdb;/data/moloch/etc/GeoLite2-ASN.mmdb
rirFile = /data/moloch/etc/ipv4-address-space.csv
ouiFile = /data/moloch/etc/oui.txt
dropUser=nobody
dropGroup=daemon
parseSMTP=true
parseSMB=true
parseQSValue=false
supportSha256=false
maxReqBody=64
config.reqBodyOnlyUtf8 = true
smtpIpHeaders=X-Originating-IP:;X-Barracuda-Apparent-Source-IP:
parsersDir=/data/moloch/parsers
pluginsDir=/data/moloch/plugins
spiDataMaxIndices=4
packetThreads=2
pcapWriteMethod=simple
pcapWriteSize = 262143
dbBulkSize = 300000
compressES = false
maxESConns = 30
maxESRequests = 500
packetsPerPoll = 50000
antiSynDrop = true
logEveryXPackets = 100000
logUnknownProtocols = false
logESRequests = true
logFileCreation = true
[class1]
freeSpaceG = 10%
[node1]
nodeClass = class1
elasticsearch=elasticsearchhost1
[node2]
nodeClass = class2
elasticsearch=elasticsearchhost2
interface = eth4
[headers-http-request]
referer=type:string;count:true;unique:true
authorization=type:string;count:true
content-type=type:string;count:true
origin=type:string
[headers-http-response]
location=type:string
server=type:string
content-type=type:string;count:true
[headers-email]
x-priority=type:integer
authorization=type:string
EOF

fi
#'lost'21jn
