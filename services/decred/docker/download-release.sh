#!/usr/bin/env bash

#VERSION=

platform=$(uname -sm)
if [[ ${platform} == "Linux x86_64" ]]; then
  arch=amd64
elif [[ ${platform} == "Linux aarch64" ]]; then
  arch=arm64
elif [[ ${platform} == "Linux armv7l" ]]; then
  arch=arm
else
  echo "Sorry, ${platform} is not supported"
  exit 1
fi


archive="https://github.com/decred/decred-binaries/releases/download/v$VERSION/decred-linux-$arch-v$VERSION.tar.gz"
#manifest="https://github.com/decred/decred-binaries/releases/download/v$VERSION/manifest-v$VERSION.asc"

cd /tmp
curl -SLO ${archive}
tar --strip=1 -xzf *.tar.gz

mv ./dcrd /usr/local/bin
mv ./dcrwallet /usr/local/bin
mv ./dcrctl /usr/local/bin
mv ./promptsecret /usr/local/bin