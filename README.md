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

##### Viewer
- ARKIME_USER
- ARKIME_PSWD
- VOLUME $LOG_DIR:/opt/arkime/log
- ENTRYPOINT /opt/arkime/bin/viewer.sh`

##### Import
> Place .pcap files in $IMPORT_DIR

```sh
$ docker run -d --name arkime_import \
    -v $IMPORT_DIR:/import:rw \
    --network arkime_default \
    rskntroot/arkime:2.7.1-1 /opt/arkime/bin/import.sh
```

> View logs
```sh
$ docker logs arkime_import -f
```
> Future Imports (after first run)
```sh
$ docker start arkime_import
```

## Default Login Credentials
| Username | Password | 
| ------ | ------ |
| root |  arkime-pswd |

## Future Additions
- Finish Capture Role
- Enable TLS with nginx
- Swap to Traefik
- Define persistent store for ElasticSearch
- Add redundant ElasticSearch node for tolerance
- Add a Kibana node
- ...
- Profit?
