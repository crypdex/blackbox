#!/usr/bin/env bash

#VERSION=

platform=$(uname -sm)
if [[ ${platform} == "Linux x86_64" ]]; then
  arch=x86_64
elif [[ ${platform} == "Linux aarch64" ]]; then
  arch=aarch64
elif [[ ${platform} == "Linux armv7l" ]]; then
  arch=aarch64
else
  echo "Sorry, ${platform} is not supported"
  exit 1
fi

curl -SLO https://github.com/lightningnetwork/lnd/releases/download/v${VERSION}/lnd-linux-${arch}-v${VERSION}.tar.gz
tar --strip=1 -xzf *.tar.gz
mv lnd /usr/local/bin
mv lncli /usr/local/bin
rm *.tar.gz

