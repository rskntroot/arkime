#!/bin/bash

err_msg () { echo -e "$(printf '\033[0;31m[ ERROR ]\033[0m') $(date +"%Y-%m-%dT%H:%M:%S%z") $BASH_SOURCE $1"; }
warn_msg () { echo -e "$(printf '\033[1;33m[ WARN ]\033[0m') $(date +"%Y-%m-%dT%H:%M:%S%z") $BASH_SOURCE $1"; }
info_msg () { echo -e "$(printf '\033[0;36m[ INFO ]\033[0m') $(date +"%Y-%m-%dT%H:%M:%S%z") $BASH_SOURCE $1"; }

info_msg "An Arkime Admin is being created...";

# SET DEFAULT CREDS IF NONE PASSED ##
#
if [ -z $ARKIME_USER ]; then ARKIME_USER="root"; fi;
if [ -z $ARKIME_PSWD ]; then ARKIME_PSWD="arkime-pswd"; fi;

## CREATE ADMIN USER ##
#
$ARKIME_DIR/bin/arkime_add_user.sh $ARKIME_USER "Arkime Admin" $ARKIME_PSWD --admin | tee -a /opt/arkime/local/log/$(hostname).log > /dev/null;

info_msg "Admin User was created:\t"$ARKIME_USER;

#'lost'21jn
