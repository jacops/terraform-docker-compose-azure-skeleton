ARG TERRAFORM_IMAGE_NAME=hashicorp/terraform
ARG TERRAFORM_IMAGE_TAG=latest

FROM ${TERRAFORM_IMAGE_NAME}:${TERRAFORM_IMAGE_TAG}

ARG AZURE_CLI_VERSION=2.0.65

WORKDIR /workspace/manifests

RUN set -ex && \
    apk add python3 bash && \
    apk add --virtual=build gcc libffi-dev musl-dev openssl-dev make python3-dev linux-headers

RUN set -ex && \
    pip3 --no-cache-dir install azure-cli==${AZURE_CLI_VERSION} && \
    apk del --purge build && \
    ln -s /usr/bin/python3 /usr/bin/python
