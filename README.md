# Docker Arkime v2.7.1-1

Arkime on Docker with container role based on entrypoint script. 

> IN PROGRESS - Feel free to leave a comment and I'll try to "devops", but faster.

## Run the Project
> Change directory to the project folder: ~/arkime
```sh
$ docker-compose up -d
```
> Copy .pcap files into the directory ~/arkime/import, these files will be imported automatically

##### Prerequisites: 
- ubuntu:20.04
- elasticsearch:7.10.1
- nginx:mainline-alpine

## Access
> The application is available over http port 80 (default) through a webbrowser.

## Available roles

##### Viewer
| Type | Field | Value |
| ------ | ------ | ------ |
| ENV | ARKIME_USER | root | 
| ENV | ARKIME_PSWD | arkime-pswd |
| VOLUME | ~/arkime/log/ | /arkime/log/ |
| ENTRYPOINT | | /arkime/bin/viewer.sh |

##### Import
| Type | Field | Value |
| ------ | ------ | ------ |
| ENV | ARKIME_USER | root |
| ENV | ARKIME_PSWD | arkime-pswd |
| VOLUME | ~/arkime/log/ | /arkime/log/ |
| VOLUME | ~/arkime/import | /import |
| ENTRYPOINT | | /arkime/bin/import.sh |

## View logs
> After running docker-compose the ~/arkime/log directory will appear with component logs.
```sh
$ docker logs -f arkime_viewer_1
$ docker logs -f arkime_import_1
$ docker logs -f arkime_elasticsearch_1
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
