#!/bin/bash

# Ask for a shor range of Local IPs

echo -e "Please enter a short range of your Local subnet (e.g: 192.168.0.30-192.168.0.40)"
read range



# Enable Microk8s addons

microk8s.enable registry
microk8s.enable dns
microk8s.enable helm3
microk8s.enable metallb:$range

# For metallb IP Range, choose a short range of your local network

# Clone git repo and switch to master branch

git clone https://github.com/diegosantoni/traackr.git

git checkout master

# Build docker image

docker build -t traackr ./traackr/

# Push de docker image to microk8s registry on localhost

docker tag traackr:latest localhost:32000/traackr:latest
docker push localhost:32000/traackr:latest

# Install Traefik

microk8s helm3 repo add traefik https://helm.traefik.io/traefik
microk8s helm3 repo update
microk8s kubectl create namespace traefik
microk8s helm3 install traefik traefik/traefik -n traefik


# Install server using HELM

microk8s helm3 install web-traackr ./traackr/helm/traackrweb
