#!/bin/bash

sudo apt update
sudo apt upgrade
sudo apt install docker.io -y
sudo usermod -aG docker $USER
sudo snap install microk8s --classic
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
su - $USER


microk8s.enable registry
microk8s.enable dns
microk8s.enable helm3
microk8s.enable metallb:192.168.100.30-192.168.100.40

git clone https://github.com/diegosantoni/traackr.git
git checkout master

docker build -t traackr .

docker tag traackr:latest localhost:32000/traackr:latest
docker push localhost:32000/traackr:latest

microk8s helm3 repo add traefik https://helm.traefik.io/traefik
microk8s helm3 repo update
microk8s kubectl create namespace traefik
microk8s helm3 install traefik traefik/traefik -n traefik

microk8s helm3 install web-traackr ./traackrweb



