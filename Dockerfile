FROM circleci/python:3.6
WORKDIR /tools
RUN sudo chown circleci /tools

# Install awscli for access to Amazon Container Service (& Registry)
RUN sudo pip install awscli==1.14.38

# Install gcloud tools and kubectl
ENV CLOUD_SDK_VERSION 217.0.0
ENV PATH /tools/google-cloud-sdk/bin:$PATH

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud components install --quiet kubectl && \
    gcloud --version
