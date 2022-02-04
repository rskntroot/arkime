# Docker Arkime v3.3.1-1

Arkime on Docker with container role based on entrypoint scripts 

## Run the Project

> Project requires directories in /opt/docker
````
mkdir -p /opt/docker
cd /opt/docker
git init
git clone https://github.com/rskntroot/arkime
cd /opt/docker/arkime
docker build . -t arkime:3.3.1-1
docker-compose up -d
````
> Copy .pcap files into the directory /opt/docker/arkime/import/., these files will be imported automatically

##### Prerequisites: 
- ubuntu:20.04
- elasticsearch:7.17.0
- traefik:v2.6.0 (in progress)

## Access
> Arkime is available over http port 80 (default) through a webbrowser.
> Arkime's authentication is turned off by default.

## Available roles

##### Viewer
| Type | Field | Value | optional |
| ------ | ------ | ------ |------|
| ENV | OFFLOAD_AUTH | false | true |
| ENV | ARKIME_USER | root | true |
| ENV | ARKIME_PSWD | arkime-pswd | true |
| ENV | ES_HOST | elasticsearch | false | 
| VOLUME | /opt/docker/arkime/log/ | /opt/arkime/local/log/ | false |
| ENTRYPOINT | | /opt/arkime/local/bin/viewer.sh | false |

##### Import
| Type | Field | Value | optional |
| ------ | ------ | ------ |------|
| ENV | OFFLOAD_AUTH | false | true |
| ENV | ARKIME_USER | root | true |
| ENV | ARKIME_PSWD | arkime-pswd | true |
| ENV | ES_HOST | elasticsearch | false |
| ENV | ARKIME_VIEWER | viewer | false |
| VOLUME | /opt/docker/arkime/log/ | /opt/arkime/local/log/ | false |
| VOLUME | /opt/docker/arkime/import | /import | false |
| ENTRYPOINT | | /opt/arkime/local/bin/import.sh | false | 

## View logs
> After running docker-compose the /opt/arkime/local/log/ directory will appear with component logs.
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
- Enable [ Arkime Capture ]
- Enable peristent storage for ELASTICSEARCH (ES)
- Add tolerance with multi-node ES
- Tie in a Kibana node
- Push docker node stats into ElasticSearch
- Port project to Kubernetes
- Enable autoTLS with letsEncrypt
- ...
- Possibly messing with netsniff-ng or pcap++ to push pcap to any capture node from any host.
- Profit?
