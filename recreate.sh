#!/bin/bash

# Update Ubuntu

sudo apt update
sudo apt upgrade

# Install Docker

sudo apt install docker.io -y
sudo usermod -aG docker $USER

# Install Microk8s (K8s Cluster)

sudo snap install microk8s --classic

sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube

su - $USER

# Enable Microk8s addons

microk8s.enable registry
microk8s.enable dns
microk8s.enable helm3
microk8s.enable metallb:192.168.100.30-192.168.100.40

# For metallb IP Range, choose a short range of your local network

# Clone git repo and switch to master branch

git clone https://github.com/diegosantoni/traackr.git

git checkout master

# Build docker image

docker build -t traackr .

# Push de docker image to microk8s registry on localhost

docker tag traackr:latest localhost:32000/traackr:latest
docker push localhost:32000/traackr:latest

# Install Traefik

microk8s helm3 repo add traefik https://helm.traefik.io/traefik
microk8s helm3 repo update
microk8s kubectl create namespace traefik
microk8s helm3 install traefik traefik/traefik -n traefik


# Install server using HELM

microk8s helm3 install web-traackr ./traackrweb

