#!/usr/bin/env bash

# Download the litecoin binary
VERSION=
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

archive=https://download.litecoin.org/litecoin-${VERSION}/linux/litecoin-${VERSION}-${arch}-linux-gnu.tar.gz
echo "Downloading ${archive}"

curl -SLO ${archive}
curl -SLO curl -SLO https://download.litecoin.org/litecoin-${VERSION}/linux/litecoin-${VERSION}-linux-signatures.asc

echo "Verifying checksums"
gpg --import litecoin.pgp.key && gpg --fingerprint FE3348877809386C
gpg --verify litecoin-${VERSION}-linux-signatures.asc
# we "strip" because the binaries are 2 dirs down
tar --strip=2 -xzf *.tar.gz -C /usr/local/bin
rm *.tar.gz


