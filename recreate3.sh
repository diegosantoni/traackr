#!/bin/bash

# Push image to microk8s local registry

for n in {1..3}; do
    docker push  localhost:32000/traackr:latest && break;
done

# Install server using HELM

sudo docker push localhost:32000/traackr:latest # Some times the first attemp fails, so re-try.
sleep 3
microk8s helm3 install web-traackr ./helm/traackrweb
