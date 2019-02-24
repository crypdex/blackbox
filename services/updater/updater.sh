#!/usr/bin/env bash

echo "checking for core updates"

# ----------------------------------------
# Update the core system (this repository)
# ----------------------------------------

CURRENT="$(git rev-parse HEAD)"

REMOTE="$(git ls-remote origin HEAD  | awk '{ print $1}')"


if [[ ${CURRENT} -ne ${REMOTE} ]]; then
  echo "core update available"

  git pull origin master

  systemctl restart blackbox.service
  # We exit here because the `make start` command does a docker pull.
  # .. also, lets not put too much stress on the restart process which can take 15 mins
  exit 0
fi

echo "no core updates available"

# ----------------------------------------
# Update containers
# ----------------------------------------

echo "checking for container updates"

# https://stackoverflow.com/questions/26423515/how-to-automatically-update-your-docker-containers-if-base-images-are-updated

set -e


for IMAGE in crypdex/pivx
do
  CID=$(docker ps | grep $IMAGE | awk '{print $1}')
  docker pull $IMAGE

  for im in $CID
  do
    LATEST=`docker inspect --format "{{.Id}}" $IMAGE`
    RUNNING=`docker inspect --format "{{.Image}}" $im`
    NAME=`docker inspect --format '{{.Name}}' $im | sed "s/\///g"`
    echo "Latest:" $LATEST
    echo "Running:" $RUNNING
    if [ "$RUNNING" != "$LATEST" ];then
      echo "upgrading $NAME"
      stop docker-$NAME
      docker rm -f $NAME
      start docker-$NAME
    else
      echo "$NAME up to date"
    fi
  done
done

