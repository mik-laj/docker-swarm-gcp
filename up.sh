#!/bin/bash

GCP_IMAGE_URL=`gcloud compute images list --uri | grep ubuntu-1804`

docker-machine create \
    --driver google \
    --google-project ${GCP_PROJECT_ID} \
    --google-machine-type n1-standard-1 \
    --google-machine-image "${GCP_IMAGE_URL}" \
    --google-zone ${GCP_ZONE_ID} \
    --google-tags docker \
    swarm-manager-1

for m in swarm-worker-{1,2,3,4,5}; do
    docker-machine create \
        --driver google \
        --google-project ${GCP_PROJECT_ID} \
        --google-machine-type f1-micro \
        --google-machine-image "${GCP_IMAGE_URL}" \
        --google-zone ${GCP_ZONE_ID} \
        --google-tags docker \
        $m
done

MANAGER_IP=`gcloud compute instances describe \
    --project ${GCP_PROJECT_ID} \
    --zone ${GCP_ZONE_ID} \
    --format 'value(networkInterfaces[0].networkIP)' \
    swarm-manager-1`

echo "Manager IP is: ${MANAGER_IP}"

docker-machine ssh swarm-manager-1 \
    sudo docker swarm init --advertise-addr ${MANAGER_IP}

WORKER_TOKEN=`docker-machine ssh swarm-manager-1 \
    sudo docker swarm join-token worker | grep token | awk '{ print $5 }'`

for m in swarm-worker-{1,2,3,4,5}; do
    docker-machine ssh $m \
        sudo docker swarm join --token $WORKER_TOKEN ${MANAGER_IP}:2377
done

gcloud compute firewall-rules create docker-public-ports \
  --project=${GCP_PROJECT_ID} \
  --description="Allow Docker Stack Sample App Ports" \
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:80,tcp:8080,tcp:3000,tcp:8000 \
  --target-tags=docker
