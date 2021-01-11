# Docker Arkime v2.7.1-1

Arkime on Docker with container role based on entrypoint script. 

> IN PROGRESS - Feel free to leave a comment and I'll try to "devops", but faster.

## Run the Project
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
| Type | Field | Value |
| ------ | ------ | ------ |
| ENV | ARKIME_USER | root | 
| ENV | ARKIME_PSWD | arkime-pswd |
| VOLUME | ~/arkime/log/ | /opt/arkime/log/ |
| ENTRYPOINT | | /opt/arkime/bin/viewer.sh |

##### Import
| Type | Field | Value |
| ------ | ------ | ------ |
| ENV | ARKIME_USER | root |
| ENV | ARKIME_PSWD | arkime-pswd |
| VOLUME | ~/arkime/log/ | /opt/arkime/log/ |
| VOLUME | ~/arkime/import | /import |
| ENTRYPOINT | | /opt/arkime/bin/import.sh |

> View logs
```sh
$ docker logs arkime_import_1 -f
```

> Usage: place .pcap files in ~/arkime/import - they are read in automatically.

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
