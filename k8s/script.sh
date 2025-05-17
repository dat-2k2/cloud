#!/usr/bin/bash
function set_acc()
{
    yc iam key create --service-account-name $1 --output $1-key.json --folder-id $(yc config get folder-id)
    yc config set service-account-key $1-key.json
}
#account for IMAGE management
set_acc(k8s-node-group-gf8)
#account for RESOURCE management
set_acc(k8s-cluster-pd3)

RGSTR=$(yc container registry show --name=nguen-registry --jq=.id)
sudo docker tag iam:latest cr.yandex/$RGSTR/nguen-iam:latest
sudo docker push cr.yandex/$RGSTR/nguen-iam:latest  