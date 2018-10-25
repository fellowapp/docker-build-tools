FROM python:3.6-alpine as base

# Install basic dependencies we're going to expect to exist
# Install awscli for access to Amazon Container Service (& Registry)
RUN apk --no-cache add \
        curl \
        wget \
        py-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git \
    && pip install awscli==1.14.38 docker-compose

# Install docker
ENV DOCKER_CLIENT_VERSION "18.06.1-ce"
RUN curl -L -o /tmp/docker-$DOCKER_CLIENT_VERSION.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLIENT_VERSION.tgz \
    && tar -xz -C /tmp -f /tmp/docker-$DOCKER_CLIENT_VERSION.tgz \
    && mv /tmp/docker/docker /usr/bin \
    && rm -rf /tmp/docker-$DOCKER_CLIENT_VERSION /tmp/docker


FROM base as deploy

ENV CLOUD_SDK_VERSION=218.0.0
ENV PATH /google-cloud-sdk/bin:$PATH
RUN apk --no-cache add \
        python \
        py-crcmod \
        gnupg \
    && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64 && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud components install --quiet kubectl && \
    gcloud --version

# Install ruby & kubernetes-deploy
RUN apk --no-cache add \
      ruby \
      ruby-io-console \
      ruby-bigdecimal \
      ruby-json \
      libstdc++ \
      tzdata \
      ca-certificates \
    && echo 'gem: --no-document' > /etc/gemrc \
    && apk add --virtual build_deps \
        build-base \
        ruby-dev \
        libc-dev \
        linux-headers \
    && gem install bundler kubernetes-deploy \
    && apk del build_deps

COPY do-exclusively /usr/bin/do-exclusively