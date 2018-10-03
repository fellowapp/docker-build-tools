#!/usr/bin/env bash
set -ex

docker build --tag fellowapp/docker-build-tools:latest-base --target base .
docker build --tag fellowapp/docker-build-tools:latest-deploy --target deploy .
