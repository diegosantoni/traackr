#!/bin/bash

# Ask for a shor range of Local IPs

echo -e "Please enter a short range of your Local subnet (e.g: 192.168.0.30-192.168.0.40)"
read range

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

echo "Now excecute recreate2.sh"
su - $USER
