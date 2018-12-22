#!/bin/bash

gcloud compute instances list --format="value(name)" | xargs -r gcloud compute instances delete --zone europe-west3-a
docker-machine rm $(docker-machine ls --format '{{.Name}}')

