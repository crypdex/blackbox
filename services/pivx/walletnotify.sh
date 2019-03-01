#!/usr/bin/env bash

curl -X POST http://api/pivx/walletnotify/$1
# curl -X POST http://host.docker.internal:4000/pivx/walletnotify/$1
# curl -X POST http://localhost:4000/pivx/walletnotify/$1
