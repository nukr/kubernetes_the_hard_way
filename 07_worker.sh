#!/bin/bash

for i in `seq 0 2`
do
  gcloud compute copy-files _remote_worker.sh worker${i}:~/
  gcloud compute ssh nukr@worker${i} --command ./_remote_worker.sh
done
