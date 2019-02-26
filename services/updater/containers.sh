#!/usr/bin/env bash

set -e

for IMAGE in crypdex/pivx
do
    CID=$(docker ps | grep ${IMAGE} | awk '{print $1}')
    docker pull $IMAGE
echo $CID
    for im in $CID
    do
        LATEST=`docker inspect --format "{{.Id}}" $IMAGE`
        RUNNING=`docker inspect --format "{{.Image}}" $im`
        NAME=`docker inspect --format '{{.Name}}' $im | sed "s/\///g"`
        echo "Latest:" $LATEST
        echo "Running:" $RUNNING
        if [ "$RUNNING" != "$LATEST" ];then
            echo "Upgrading $NAME"
#            docker-compose up -d -t 180 ${NAME} # 3 minute timeout
        else
            echo "$NAME up to date"
        fi
    done
done

