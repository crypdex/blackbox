#!/usr/bin/env bash

for service in bitcoin # litecoin pivx zcoin
do
  # in a subshell
  (cd services/$service/docker && ./build.sh)
done


