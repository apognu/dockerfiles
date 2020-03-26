#!/bin/sh

set -e

if ! which jq > /dev/null; then
  echo 'ERROR: jq is needed to build Plex.' >&2
  exit 1
fi

git submodule update

SPEC=$(curl -s https://plex.tv/api/downloads/5.json)
VERSION=$(echo "$SPEC" | jq -r '.computer.Linux.version')
DOWNLOAD_URL=$(echo "$SPEC" | jq -r '.computer.Linux.releases[] | select(.build == "linux-aarch64").url')

docker build --build-arg PLEX_DOWNLOAD_URL=$DOWNLOAD_URL -t apognu/plex-arm:$VERSION .
docker push apognu/plex-arm:$VERSION
