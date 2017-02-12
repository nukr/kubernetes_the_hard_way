#!/bin/bash

echo '{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}' > ca-config.json

echo '{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Oregon"
    }
  ]
}' > ca-csr.json

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

openssl x509 -in ca.pem -text -noout

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes \
  --format 'value(address)')

cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "hosts": [
    "worker0",
    "worker1",
    "worker2",
    "ip-10-240-0-20",
    "ip-10-240-0-21",
    "ip-10-240-0-22",
    "10.32.0.1",
    "10.240.0.10",
    "10.240.0.11",
    "10.240.0.12",
    "10.240.0.20",
    "10.240.0.21",
    "10.240.0.22",
    "10.240.0.30",
    "10.240.0.31",
    "10.240.0.32",
    "${KUBERNETES_PUBLIC_ADDRESS}",
    "127.0.0.1"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Cluster",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes

KUBERNETES_HOSTS=(controller0 controller1 controller2 worker0 worker1 worker2 etcd0 etcd1 etcd2)

for host in ${KUBERNETES_HOSTS[*]}; do
  gcloud compute copy-files ca.pem kubernetes-key.pem kubernetes.pem ${host}:~/
done
