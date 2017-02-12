#!/bin/bash

for i in `seq 0 2`
do
  gcloud compute copy-files _remote_controller.sh controller${i}:~/
  gcloud compute ssh nukr@controller${i} --command ./_remote_controller.sh
done

gcloud compute http-health-checks create kube-apiserver-check \
  --description "Kubernetes API Server Health Check" \
  --port 8080 \
  --request-path /healthz

gcloud compute target-pools create kubernetes-pool \
  --http-health-check=kube-apiserver-check

gcloud compute target-pools add-instances kubernetes-pool \
  --instances controller0,controller1,controller2

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes \
  --format 'value(address)')

gcloud compute forwarding-rules create kubernetes-rule \
  --address ${KUBERNETES_PUBLIC_ADDRESS} \
  --ports 6443 \
  --target-pool kubernetes-pool
