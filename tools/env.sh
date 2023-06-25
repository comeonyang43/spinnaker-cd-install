#!/bin/bash

VERSION="1.28.7"
#非80|443要加上端口，否则跨域
DECK_HOST="http://192.168.146.133"
#非80|443要加上端口，否则跨域
GATE_HOST="http://192.168.146.133"
MINIO_EP="http://minio.default.svc.cluster.local.:9000"
MINIO_ID="AnWFkXScTzQy3vwd"
MINIO_KEY="fsob5BYU9NGSkvJnDZXn5XeBR09I7sKa"
IMG_REGISTRY="registry.cn-hangzhou.aliyuncs.com"
IMG_NS="priv_sync"
IMG_REGISTRY_USER=""
IMG_REGISTRY_PASS=""

BOMS_DIR="/root/.hal/"
BOMS_FILR=".boms"
KUBE_DIR="/root/.kube/"
HALY_IMAGE="${IMG_REGISTRY}/${IMG_NS}/halyard:1.45.0"
