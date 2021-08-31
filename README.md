# Docker Arkime v3.0.0-1

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
- elasticsearch:7.13.3
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

## HTTPS
> Add [ cert & key ] into ~/arkime/ssl and updated [ .conf file ] into ~/arkime/conf.d

```sh
$ echo '      - 443:443' >> ~/arkime/docker-compose.yml
$ docker-compose up -d
```

## Future Additions
- Enable [ Arkime Capture ]
- Swap Nginx with Traefik
- Enable peristent storage for ELASTICSEARCH (ES)
- Add tolerance with multi-node ES
- Tie in a Kibana node
- Push docker node stats into ElasticSearch
- Port project to Kubernetes
- Enable autoTLS with letsEncrypt
- ...
- Possibly messing with netsniff-ng or pcap++ to push pcap to any capture node from any host.
- Profit?
