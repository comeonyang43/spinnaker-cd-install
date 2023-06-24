#!/bin/bash

. ./env.sh


function Clean(){
    echo -e "\033[43;34m =====Clean===== \033[0m"
    rm  -r ${BOMS_DIR}/config ${BOMS_DIR}/default
}

## 安装
function Install(){
    echo -e "\033[43;34m =====Install===== \033[0m"
    [ -d ${BOMS_DIR} ] || mkdir ${BOMS_DIR}
    mv ${BOMS_FILR} ${BOMS_DIR}
    mkdir ${BOMS_DIR}/default/service-settings -p 
    cp redis.yml > ${BOMS_DIR}/default/service-settings/ 
    ls -a ${BOMS_DIR}
    chmod 777 -R ${BOMS_DIR}
    chmod 777 -R ${KUBE_DIR}
    sed -i "s#gcr.io/spinnaker-marketplace#${IMG_REGISTRY}/${IMG_NS}#" ${BOMS_DIR}/${BOMS_FILR}/bom/${VERSION}.yml

    docker run -d  \
    --name halyard   \
    --restart always \
    -v ${BOMS_DIR}:/home/spinnaker/.hal \
    -v ${KUBE_DIR}:/home/spinnaker/.kube \
    -it ${HALY_IMAGE}

    sleep 5
    docker cp halyard.yaml halyard:/opt/halyard/config/halyard.yml
    docker stop halyard  &&  docker start halyard
    sleep 3
    docker ps | grep halyard
    sleep 5
    chmod +x halyard.sh
    chmod +x env.sh
    docker cp halyard.sh halyard:/home/spinnaker/halyard.sh
    docker cp env.sh halyard:/home/spinnaker/env.sh
    docker exec  halyard  ./home/spinnaker/halyard.sh
    sleep 5
    kubectl get pod -n spinnaker
    sleep 5
    kubectl get pod -n spinnaker
}

## Ingress
function Ingress(){
    echo -e "\033[43;34m =====Ingress===== \033[0m"
    sed -i "s/deck_domain/${DECK_HOST}/g" ingress.yaml
    sed -i "s/gate_domain/${GATE_HOST}/g" ingress.yaml
    cat ingress.yaml
    sleep 5
    kubectl create -f  ingress.yaml -n spinnaker
}


case $1 in
  install)
    Install
    ;;
  ingress)
    Ingress
    ;;
  allinstall)
    Clean
    Install
    sleep 10
    Ingress
    ;;

  *)
    echo -e " [ install -> ingress = allinstall] "
    ;;
esac
