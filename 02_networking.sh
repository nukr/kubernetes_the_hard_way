#!/bin/bash

gcloud compute networks create kubernetes --mode custom

gcloud compute networks subnets create kubernetes \
  --network kubernetes \
  --range 10.240.0.0/24

gcloud compute firewall-rules create kubernetes-allow-icmp \
  --allow icmp \
  --network kubernetes \
  --source-ranges 0.0.0.0/0

gcloud compute firewall-rules create kubernetes-allow-internal \
  --allow tcp:0-65535,udp:0-65535,icmp \
  --network kubernetes \
  --source-ranges 10.240.0.0/24

gcloud compute firewall-rules create kubernetes-allow-rdp \
  --allow tcp:3389 \
  --network kubernetes \
  --source-ranges 0.0.0.0/0

gcloud compute firewall-rules create kubernetes-allow-ssh \
  --allow tcp:22 \
  --network kubernetes \
  --source-ranges 0.0.0.0/0

gcloud compute firewall-rules create kubernetes-allow-healthz \
  --allow tcp:8080 \
  --network kubernetes \
  --source-ranges 130.211.0.0/22

gcloud compute firewall-rules create kubernetes-allow-api-server \
  --allow tcp:6443 \
  --network kubernetes \
  --source-ranges 0.0.0.0/0

gcloud compute firewall-rules list --filter "network=kubernetes"

gcloud compute addresses create kubernetes --region=asia-east1

gcloud compute addresses list kubernetes
