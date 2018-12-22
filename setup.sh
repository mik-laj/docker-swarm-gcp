#!/bin/bash

gcloud projects create "${GCP_PROJECT_ID}"
gcloud config set core/project "${GCP_PROJECT_ID}"
gcloud auth application-default login
gcloud services enable compute.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable compute.googleapis.com
GCP_BILLING_ACCOUNT=`gcloud alpha billing accounts list --format="value(name)" | head -1`
gcloud alpha billing projects link ${GCP_PROJECT_ID} --billing-account=${GCP_BILLING_ACCOUNT}

