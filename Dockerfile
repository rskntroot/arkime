FROM ubuntu:20.04
LABEL version="1.0.3" maintainer="lost@rskdev.com"

ARG UBUNTU_VERS=20.04
ARG ARKIME_VERS=3.3.1-1_amd64

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y curl wget ethtool libwww-perl libjson-perl libyaml-dev libmagic1 && apt-get clean
RUN mkdir /data && cd /data && curl -C - "https://s3.amazonaws.com/files.molo.ch/builds/ubuntu-$UBUNTU_VERS/arkime_$ARKIME_VERS.deb" -o arkime.deb && dpkg -i arkime.deb && rm arkime.deb
RUN /opt/arkime/bin/arkime_update_geo.sh

RUN mkdir -p /opt/arkime/local/ && cd /opt/arkime/local && mkdir etc log
ADD /bin /opt/arkime/local/bin
RUN chmod 755 /opt/arkime/local/bin/*.sh 

ENV ARKIME_DIR "/opt/arkime"
ENV LOCAL_DIR "/opt/arkime/local"
EXPOSE 8005/tcp
