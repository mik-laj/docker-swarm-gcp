#!/bin/bash

eval "$(docker-machine env swarm-manager-1)"
docker stack deploy --resolve-image=always --with-registry-auth -c docker-compose.yml sample-app
