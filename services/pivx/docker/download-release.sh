#!/usr/bin/env bash

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

# download source
wget -O pivx-"${VERSION}".tar.gz "https://github.com/PIVX-Project/PIVX/releases/download/v"${VERSION}"/pivx-"${VERSION}"-${arch}-linux-gnu.tar.gz"

#wget -O /tmp/SHA256SUMS.asc "https://github.com/PIVX-Project/PIVX/releases/download/v"${VERSION}"/SHA256SUMS.asc"
# verify gpg signature
# RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 3BDCDA2D87A881D9
# RUN gpg --keyserver-options auto-key-retrieve --verify SHA256SUMS.asc
