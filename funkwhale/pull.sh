#!/bin/sh

[ $# -ne 1 ] && exit 1

VERSION="$1"

cd docker-funkwhale

./scripts/download-artifact.sh src/ "$VERSION" build_front
./scripts/download-artifact.sh src/ "$VERSION" build_api
./scripts/download-nginx-template.sh src/ "$VERSION"

