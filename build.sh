#!/bin/bash

docker build -t sample-app .
docker tag sample-app gcr.io/docker-experiments-2018-12/sample-tag:latest
docker push gcr.io/docker-experiments-2018-12/sample-tag:latest
