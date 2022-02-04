#!/bin/bash

err_msg () { echo -e "$(printf '\033[0;31m[ ERROR ]\033[0m') $(date +"%Y-%m-%dT%H:%M:%S%z") $BASH_SOURCE $1"; }
warn_msg () { echo -e "$(printf '\033[1;33m[ WARN ]\033[0m') $(date +"%Y-%m-%dT%H:%M:%S%z") $BASH_SOURCE $1"; }
info_msg () { echo -e "$(printf '\033[0;36m[ INFO ]\033[0m') $(date +"%Y-%m-%dT%H:%M:%S%z") $BASH_SOURCE $1"; }

## SET DEFAULT VALUES ##
#
if [ -z "$CAP_INTERFACE" ]; then CAP_INTERFACE='eth1'; fi
if [ -z "$ARKIME_S2S" ]; then ARKIME_S2S=$(echo deeznuts | sha256sum | cut -d' ' -f1); fi

info_msg "Generating [ Arkime $(hostname) ] configuration file..."
sed -re "s,ARKIME_INSTALL_DIR,$ARKIME_DIR, ; s,ARKIME_PASSWORD,$ARKIME_S2S, ; s,ARKIME_INTERFACE,$CAP_INTERFACE, ; s,ARKIME_ELASTICSEARCH,http://$ES_HOST:9200," \
	< $ARKIME_DIR/etc/config.ini.sample > $LOCAL_DIR/etc/config.ini
ln -s $LOCAL_DIR/etc/config.ini $ARKIME_DIR/etc/config.ini
info_msg "Configuration file generated."

info_msg "Setting log rotation for 7 days."

## SETUP LOGROTATE ##
#
cat << EOF > /etc/logrotate.d/$(hostname)
$ARKIME_DIR/logs/$(hostname).log {
    daily
    rotate 7
    compressl
    notifempty
    copytruncate
}
EOF

## CREATE PCAP DATASTORE ##
#
info_msg "Creating datastore at /data/arkime/pcap."
mkdir -p /data/arkime/pcap
chmod 755 /data/arkime/pcap
ln -s /data/arkime/pcap $ARKIME_DIR/raw

## DEFINE INTERFACE CONFIG SCRIPT ##
#
#info_msg "Generating capture prerequesties for:\t"$CAP_INTERFACE
#cat << EOF > $ARKIME_DIR/bin/moloch_config_interfaces.sh
##!/bin/sh
#/sbin/ethtool -G \$CAP_INTERFACE rx 4096 tx 4096 || true
#for i in rx tx sg tso ufo gso gro lro; do
#    /sbin/ethtool -K \$CAP_INTERFACE \$i off || true
#done
#EOF

#chmod a+x $ARKIME_DIR/bin/moloch_config_interfaces.sh

## UNLOCK CORE AND MEMLOCK ##
#
info_msg "Removing core and memlock limits."
cat << EOF > /etc/security/limits.d/99-moloch.conf
nobody  -       core    unlimited
root    -       core    unlimited
nobody  -       memlock    unlimited
root    -       memlock    unlimited
EOF

info_msg "Configuration has completed."

#'lost'22fr
