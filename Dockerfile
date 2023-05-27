FROM bmoorman/ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive \
    MC_SERVER_PORT=19132/udp \
    TARGETOS \
    TARGETARCH

WORKDIR /opt/minecraft

RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
    jq \
    unzip \
    vim \
    wget \
 && target=${TARGETOS}_${TARGETARCH} \
 && fileUrl=$(curl --silent --location "https://api.github.com/repos/ericchiang/pup/releases/latest" | jq --arg target ${target} --raw-output '.assets[] | select(.name | endswith($target + ".zip")) | .browser_download_url') \
 && wget --quiet --directory-prefix /tmp "${fileUrl}" \
 && unzip -d /usr/local/bin /tmp/pup_*_${target}.zip \
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
