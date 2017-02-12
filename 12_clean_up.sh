#!/bin/bash

gcloud -q compute instances delete \
  controller0 controller1 controller2 \
  worker0 worker1 worker2 \
  etcd0 etcd1 etcd2

gcloud -q compute forwarding-rules delete kubernetes-rule
gcloud -q compute target-pools delete kubernetes-pool
gcloud -q compute http-health-checks delete kube-apiserver-check
gcloud -q compute addresses delete kubernetes
gcloud -q compute firewall-rules delete \
  kubernetes-allow-api-server \
  kubernetes-allow-healthz \
  kubernetes-allow-icmp \
  kubernetes-allow-internal \
  kubernetes-allow-rdp \
  kubernetes-nginx-service \
  kubernetes-allow-ssh

gcloud -q compute routes delete \
  kubernetes-route-10-200-0-0-24 \
  kubernetes-route-10-200-1-0-24 \
  kubernetes-route-10-200-2-0-24
gcloud -q compute networks subnets delete kubernetes
gcloud -q compute networks delete kubernetes

rm ca-config.json ca-csr.json ca-key.pem ca.csr ca.pem kubernetes-csr.json kubernetes-key.pem \
  kubernetes.csr kubernetes.pem
