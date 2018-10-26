# Fellow docker-build-tools

Builds a docker container suitable for building other docker containers on CircleCI. https://hub.docker.com/r/fellowapp/docker-build-tools/

# Building

 - Run `build.sh` to build
 - Run `push.sh` to push

# Structure

#### Base

There are two containers for maximum efficiency: a base container with:

  - Python 3.6.6
  - git
  - curl
  - docker
  - docker-compose
  - dockerize
  - awscli python package

Use the `latest-base` tag to use this image

#### Deploy

The second container contains all the stuff to actually deploy a built image:

  - python 2 (for gcloud)
  - gcloud
  - kubectl
  - do-exclusively from https://github.com/bellkev/circle-lock-test
  - create-github-deploy from this repo which creates a Deployment in the Github API
