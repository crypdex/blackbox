#!/usr/bin/env bash


platform=$(uname -sm)
if [[ ${platform} == "Linux x86_64" ]]; then
  arch=x86_64
  archive_name=dashcore-${VERSION}-${arch}-linux-gnu.tar.gz
elif [[ ${platform} == "Linux aarch64" ]]; then
  arch=aarch64
  archive_name=dashcore-${VERSION}-${arch}-linux-gnu.tar.gz
elif [[ ${platform} == "Linux armv7l" ]]; then
  arch=arm
  archive_name=dashcore-${VERSION}-${arch}-linux-gnueabihf.tar.gz
#elif [[ ${platform} == "Darwin x86_64" ]]; then
#  archive_name=dashcore-${VERSION}-osx64.tar.gz
else
  echo "Sorry, ${platform} is not supported"
  exit 1
fi

archive=https://github.com/dashpay/dash/releases/download/v${VERSION}/${archive_name}
echo "Downloading ${archive}"

curl -SLO ${archive}
curl -SLO https://github.com/dashpay/dash/releases/download/v${VERSION}/SHA256SUMS.asc




