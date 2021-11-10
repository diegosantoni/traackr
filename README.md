Steps for recreate the Challenge
--------------------------------

Requirements

* A fresh and updated Ubuntu 20.04 server whit internet access.
* A user with sudo privileges

You can download the "recreate.sh", "recreate2.sh" and "recreate3.sh" scripts in your HOME directory and run them in order to fully recreate the challenge, or follow the steps below:

0- Update Ubuntu

sudo apt update

sudo apt upgrade -y

1- Install Docker

sudo apt install docker.io -y
sudo usermod -aG docker $USER

2- Install Microk8s (K8s Cluster)

sudo snap install microk8s --classic

sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube

su - $USER

3- Enable Microk8s addons

microk8s.enable registry
microk8s.enable dns
microk8s.enable helm3
microk8s.enable metallb:192.168.100.30-192.168.100.40

# For metallb IP Range, choose a short range of your local network

4- Clone git repo and switch to master branch

git clone https://github.com/diegosantoni/traackr.git

git checkout master

5- Build docker image

cd traacker
docker build -t traackr .

6- Push de docker image to microk8s registry on localhost

docker tag traackr:latest localhost:32000/traackr:latest

docker push localhost:32000/traackr:latest

7- Install Traefik

Ref: https://pacroy.medium.com/single-node-kubernetes-on-home-lab-using-microk8s-metallb-and-traefik-7bb1ea38fcc2


microk8s helm3 repo add traefik https://helm.traefik.io/traefik
microk8s helm3 repo update
microk8s kubectl create namespace traefik
# In the next command you have to choose one IP from the range specified before.
microk8s helm3 install traefik traefik/traefik -n traefik --set service.spec.loadBalancerIP=192.168.100.30


8- Install server using HELM

microk8s helm3 install web-traackr ./helm/traackrweb

# This chart was previously created with the command:

microk8s helm3 create .helm/traackrweb

# After that we have to move all the ".yaml" files to the "templates" subfolder.


