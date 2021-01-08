# Arkime v2.7.1 in Docker (Ubuntu 20.04)

IN PROGRESS - feel free to leave a comment and ill try to hurry up.

Arkime on Docker with role based on entrypoint script. (Roles: Viewer, Capture, Import)

# Prerequisites
### ElasticSearch Backend:
docker run -d --name elasticsearch -e "discovery.type=single-node" elasticsearch:7.10.1

# Build Image
cd ~/arkime
docker build -t rskntroot/arkime:2.7.1 .

# available roles
### Viewer:
docker run -d --name arkime-viewer -e ELASTIC_HOST="%HOSTNAME%" -p 80:8005 rskntroot/arkime:2.7.1 /opt/arkime/bin/viewer.sh
