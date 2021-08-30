FROM ubuntu:20.04
LABEL version="1.0.3" maintainer="lost@rskdev.com"

ARG UBUNTU_VERS=20.04
ARG ARKIME_VERS=3.0.0-1_amd64

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y curl wget ethtool libwww-perl libjson-perl libyaml-dev libmagic1 && apt-get clean
RUN mkdir /data && cd /data && curl -C - "https://s3.amazonaws.com/files.molo.ch/builds/ubuntu-"$UBUNTU_VERS"/moloch_"$ARKIME_VERS".deb" -o arkime.deb && dpkg -i arkime.deb && rm arkime.deb
RUN /data/moloch/bin/moloch_update_geo.sh

RUN mkdir /arkime && cd /arkime && mkdir bin log
ADD /scripts /arkime/bin
RUN chmod 755 /arkime/bin/*.sh

ENV ARKIME_DIR "/data/moloch"
EXPOSE 8005/tcp
