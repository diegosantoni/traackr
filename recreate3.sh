#!/bin/bash

# Push image to microk8s local registry and install HELM chart

for n in {1..3}; do
    docker push  localhost:32000/traackr:latest && microk8s helm3 install web-traackr ./helm/traackrweb && break;
done
