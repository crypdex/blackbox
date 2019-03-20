#!/usr/bin/env bash

if [[ -f ./restart ]]; then
    echo "restart file found!"
    echo "Refreshing containers"
    rm ./restart
    make update
fi

# ----------------------------------------
# Update the core system (this repository)
# ----------------------------------------

#CURRENT="$(git rev-parse HEAD)"
#
#REMOTE="$(git ls-remote origin HEAD  | awk '{ print $1}')"
#
#
#if [[ "$CURRENT" != "$REMOTE" ]]; then
#  echo "Core update available"
#
#  git pull origin master
#
#  echo "Restarting the blackbox.service"
#  systemctl restart blackbox.service
#  # We exit here because the `make start` command does a docker pull.
#  # .. also, lets not put too much stress on the restart process which can take 15 mins
#  exit 0
#fi
#
#echo "No core updates available"




exit 0
