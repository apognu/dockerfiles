#!/bin/sh

set -e

if ! which jq > /dev/null; then
  echo 'ERROR: jq is needed to build Plex.' >&2
  exit 1
fi

git submodule update

SPEC=$(curl -s https://api.github.com/repos/ory/oathkeeper/releases/latest)
VERSION=$(echo "$SPEC" | jq -r '.tag_name')
DOWNLOAD_URL=$(echo "$SPEC" | jq -r '.assets[].browser_download_url | select(. | contains("Linux_armv7"))')

docker build --build-arg OATHKEEPER_DOWNLOAD_URL=$DOWNLOAD_URL -t apognu/oathkeeper-arm:$VERSION .
docker push apognu/oathkeeper-arm:$VERSION