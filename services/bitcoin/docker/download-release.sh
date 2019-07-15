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

archive=https://bitcoin.org/bin/bitcoin-core-${VERSION}/bitcoin-${VERSION}-${arch}-linux-gnu.tar.gz
echo "Downloading ${archive}"

curl -SLO ${archive}
curl -SLO https://bitcoin.org/bin/bitcoin-core-${VERSION}/SHA256SUMS.asc

echo "Verifying checksums"
curl -SL https://bitcoin.org/laanwj-releases.asc | gpg --batch --import
gpg --verify SHA256SUMS.asc
grep " bitcoin-${VERSION}-${arch}-linux-gnu.tar.gz\$" SHA256SUMS.asc | sha256sum -c

tar -xzf *.tar.gz -C /opt
rm *.tar.gz *.asc


