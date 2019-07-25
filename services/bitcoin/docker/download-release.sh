#!/usr/bin/env bash


platform=$(uname -sm)
if [[ ${platform} == "Linux x86_64" ]]; then
  arch=x86_64
  archive_name=bitcoin-${VERSION}-${arch}-linux-gnu.tar.gz
elif [[ ${platform} == "Linux aarch64" ]]; then
  arch=aarch64
  archive_name=bitcoin-${VERSION}-${arch}-linux-gnu.tar.gz
elif [[ ${platform} == "Linux armv7l" ]]; then
  arch=arm
  archive_name=bitcoin-${VERSION}-${arch}-linux-gnueabihf.tar.gz
else
  echo "Sorry, ${platform} is not supported"
  exit 1
fi

archive=https://bitcoin.org/bin/bitcoin-core-${VERSION}/${archive_name}
echo "Downloading ${archive}"

curl -SLO ${archive}
curl -SLO https://bitcoin.org/bin/bitcoin-core-${VERSION}/SHA256SUMS.asc

echo "Verifying checksums"
curl -SL https://bitcoin.org/laanwj-releases.asc | gpg --batch --import
gpg --verify SHA256SUMS.asc
grep " ${archive_name}\$" SHA256SUMS.asc | sha256sum -c

tar -xzf *.tar.gz -C /opt
rm *.tar.gz *.asc


