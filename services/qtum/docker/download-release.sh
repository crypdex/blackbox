#!/usr/bin/env bash

#VERSION=

platform=$(uname -sm)
if [[ ${platform} == "Linux x86_64" ]]; then
  archive_name=qtum-${VERSION}-x86_64-linux-gnu.tar.gz
  arch=x86_64
elif [[ ${platform} == "Linux aarch64" ]]; then
  archive_name=qtum-${VERSION}-aarch64-linux-gnu.tar.gz
  arch=aarch64
elif [[ ${platform} == "Linux armv7l" ]]; then
  qtum-0.17.6-arm-linux-gnueabihf.tar.gz
  archive_name=qtum-${VERSION}-arm-linux-gnueabihf.tar.gz
  arch=arm
else
  echo "Sorry, ${platform} is not supported"
  exit 1
fi

archive=https://github.com/qtumproject/qtum/releases/download/mainnet-ignition-v${VERSION}/${archive_name}
echo "Downloading ${archive}"

curl -SLO ${archive}
#curl -SLO https://bitcoin.org/bin/bitcoin-core-${VERSION}/SHA256SUMS.asc

#echo "Verifying checksums"
#curl -SL https://bitcoin.org/laanwj-releases.asc | gpg --batch --import
#gpg --verify SHA256SUMS.asc
#grep " bitcoin-${VERSION}-${arch}-linux-gnu.tar.gz\$" SHA256SUMS.asc | sha256sum -c

tar --strip=2 -xzf *.tar.gz -C /usr/local/bin \
rm *.tar.gz


