FROM golang:latest AS builder

RUN go install github.com/ericchiang/pup@latest

FROM bmoorman/ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive \
    MC_SERVER_PORT=19132/udp

WORKDIR /opt/minecraft

COPY --from=builder /go/bin/pup /usr/local/bin

RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
    jq \
    unzip \
    vim \
    wget \
 && fileUrl=$(curl --silent --location --user-agent bmoorman/minecraft-bedrock "https://www.minecraft.net/en-us/download/server/bedrock" | pup 'a[data-platform="serverBedrockLinux"] attr{href}') \
 && wget --quiet --directory-prefix /tmp "${fileUrl}" \
 && unzip /tmp/bedrock-server-*.zip \
 && apt-get autoremove --yes --purge \
 && apt-get clean \
 && rm --recursive --force /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY minecraft/ /etc/minecraft/

VOLUME /config /data

EXPOSE ${MC_SERVER_PORT}

ENV LD_LIBRARY_PATH=.

CMD ["/etc/minecraft/start.sh"]
