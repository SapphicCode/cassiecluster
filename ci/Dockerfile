FROM docker.io/library/alpine:latest

# Install dependencies
RUN apk add --no-cache coreutils bash curl jq git ansible openssh-client make

ARG vault_version="1.8.1"
RUN curl --fail --silent https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_amd64.zip | \
    unzip -d /usr/local/bin - && \
    chmod +x /usr/local/bin/*

ARG sops_version="3.7.1"
RUN curl --fail --silent --location \
    https://github.com/mozilla/sops/releases/download/v${sops_version}/sops-v${sops_version}.linux \
    -o /usr/local/bin/sops && \
    chmod +x /usr/local/bin/sops

# # Create user
# ARG uid="1000"
# RUN adduser -D \
#     -u ${uid} \
#     -h /work \
#     automata
# USER ${uid}
# WORKDIR /work
# ENTRYPOINT /bin/bash
