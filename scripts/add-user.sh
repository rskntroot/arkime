#!/bin/bash

err_msg () { printf '\033[0;31m[ ERROR ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }
warn_msg () { printf '\033[1;33m[ WARN ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }
info_msg () { printf '\033[0;36m[ INFO ]\033[0m' && echo -e "\t"$(date)"\t"$BASH_SOURCE"\t"$1; }

## CREATE ADMIN USER ##
#

# set default creds if none specified
if [ -z $ARKIME_USER ]; then ARKIME_USER="root"; fi;
if [ -z $ARKIME_PSWD ]; then ARKIME_PSWD="arkime-pswd"; fi;

# create admin user
info_msg "Creating Arkime admin...";

$ARKIME_DIR/bin/moloch_add_user.sh $ARKIME_USER "Arkime Admin" $ARKIME_PSWD --admin;

info_msg "Admin User:\t"$ARKIME_USER"\twith password:\t"$ARKIME_PSWD"\t was created.";

#'lost'21jn
