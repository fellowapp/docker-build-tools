#!/usr/bin/env bash
set -ex

docker push fellowapp/docker-build-tools:latest-base
docker push fellowapp/docker-build-tools:latest-deploy
docker push fellowapp/docker-build-tools:latest-warehouse
