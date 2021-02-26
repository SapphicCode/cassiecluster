FROM docker.io/library/alpine:latest

# Install dependencies
RUN apk add --no-cache bash curl jq git ansible openssh-client
ARG vault_version="1.6.3"
RUN curl --fail --silent https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_amd64.zip | \
    unzip -d /usr/local/bin - && \
    chmod +x /usr/local/bin/*

# Create user
ARG uid="1000"
RUN adduser -D \
    -u ${uid} \
    -h /work \
    automata
USER ${uid}
WORKDIR /work
ENTRYPOINT /bin/bash
