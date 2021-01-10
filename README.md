# Docker Arkime v2.7.1-1

Arkime on Docker with container role based on entrypoint script. 

> IN PROGRESS - Feel free to leave a comment and I'll try to "devops", but faster.

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
> Place .pcap files in ~/arkime/arkime/import

```sh
$ docker start arkime_import_1
```

> View logs
```sh
$ docker logs arkime_import_1 -f
```

## Default Login Credentials
| Username | Password | 
| ------ | ------ |
| root |  arkime-pswd |

## Future Additions
- Enabling [ Arkime Capture ]
- Finalizing config.sh 
- Swap Nginx with Traefik
- Enable manually configured TLS
- Enable autoTLS with letsEncrypt
- Define persistent storage for ElasticSearch
- Add redundant ElasticSearch nodes for tolerance
- Add a Kibana node
- ...
- Profit?
