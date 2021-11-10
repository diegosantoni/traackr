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

echo "Ingress your password and excecute recreate2.sh"
su - $USER
