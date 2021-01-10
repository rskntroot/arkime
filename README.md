# Docker Arkime v2.7.1-1

Arkime on Docker with container role based on entrypoint script. 

> IN PROGRESS - feel free to leave a comment and ill try to hurry up.

### Run the Project
cd to the project folder then
```sh
$ docker-compose up -d
```
##### Offline Installation
Prerequisites: 
- ubuntu:20.04
- elasticsearch:7.10.1
- nginx:mainline-alpine

## Available roles

### - 1. Viewer

> ARKIME_USER

> ARKIME_PSWD

> VOLUME $LOG_DIR:/opt/arkime/log

> ENTRYPOINT /opt/arkime/bin/viewer.sh`

### - 2. Import

Place .pcap files in $IMPORT_DIR

`docker run -d --name arkime_import --network arkime_default -v $IMPORT_DIR:/import:rw rskntroot/arkime:2.7.1-1 /opt/arkime/bin/import.sh`

After first, importing can be done running this command:

`docker start arkime_import`

### Default Login Credentials

> root

> arkime-pswd

## FUTURE

> Finish Capture Role

> Enable TLS with nginx

> Swap to Traefik

> Define persistent store for ElasticSearch

> Add redundant ElasticSearch node for tolerance

> Add a Kibana node

> ...

> Profit?
