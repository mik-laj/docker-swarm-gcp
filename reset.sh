#!/bin/bash


gcloud compute instances list --format="value(name)" | xargs gcloud compute instances reset --zone europe-west3-a

