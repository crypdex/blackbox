#!/usr/bin/env bash

#!/bin/bash

sudo apt update;
sudo apt upgrade;
sudo apt install tmux curl;

v=v1.4.0;
a=amd64;
b=dcrinstall-linux-${a}-${v};
wget https://github.com/decred/decred-release/releases/download/${v}/${b};
chmod +x ${b};
./${b};
ip=$(curl icanhazip.com);
echo "
tmux new -d -s dcrd 'dcrd --externalip=${ip}';
tmux new -d -s dcrwallet 'dcrwallet --enablevoting --promptpass';
tmux attach -t dcrwallet" > ~/decred.sh;
chmod +x ~/decred.sh;
echo "PATH=~/decred:$PATH" >> ~/.profile;
source ~/.profile