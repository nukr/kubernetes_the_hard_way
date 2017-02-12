#!/bin/bash

for i in `seq 0 2`
do
  gcloud compute instances create controller$i \
   --boot-disk-size 200GB \
   --can-ip-forward \
   --image ubuntu-1604-xenial-v20170202 \
   --image-project ubuntu-os-cloud \
   --machine-type n1-standard-1 \
   --private-network-ip 10.240.0.1$i \
   --subnet kubernetes
done

for i in `seq 0 2`
do
  gcloud compute instances create worker$i \
   --boot-disk-size 200GB \
   --can-ip-forward \
   --image ubuntu-1604-xenial-v20170202 \
   --image-project ubuntu-os-cloud \
   --machine-type n1-standard-1 \
   --private-network-ip 10.240.0.2$i \
   --subnet kubernetes
done

for i in `seq 0 2`
do
  gcloud compute instances create etcd$i \
   --boot-disk-size 200GB \
   --can-ip-forward \
   --image ubuntu-1604-xenial-v20170202 \
   --image-project ubuntu-os-cloud \
   --machine-type n1-standard-1 \
   --private-network-ip 10.240.0.3$i \
   --subnet kubernetes
done
