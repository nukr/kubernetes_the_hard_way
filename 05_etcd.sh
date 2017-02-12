#!/bin/bash

for i in `seq 0 2`
do
  gcloud compute copy-files _remote_etcd.sh etcd${i}:~/
  gcloud compute ssh nukr@etcd${i} --command ./_remote_etcd.sh
done

for i in `seq 0 2`
do
  gcloud compute ssh nukr@etcd${i} --command "etcdctl --ca-file=/etc/etcd/ca.pem cluster-health"
done
