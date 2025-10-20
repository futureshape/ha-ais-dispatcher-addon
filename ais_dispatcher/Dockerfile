ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG BUILD_ARCH
ENV LANG=C.UTF-8

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        wget \
        ca-certificates \
        bzip2 \
        tar \
        xz-utils; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    useradd --create-home --home /home/ais --shell /usr/sbin/nologin ais

RUN set -eux; \
    mkdir -p /usr/share/aisdispatcher; \
    mkdir -p /tmp/dispatcher; \
    cd /tmp/dispatcher; \
    wget -q https://www.aishub.net/downloads/dispatcher/packages/latest/full.tar.bz2; \
    wget -q https://www.aishub.net/downloads/dispatcher/packages/latest/full.tar.bz2.md5; \
    md5sum --check full.tar.bz2.md5; \
    tar xjf full.tar.bz2 -C /usr/share/aisdispatcher; \
    rm -rf /tmp/dispatcher

RUN set -eux; \
    /bin/bash /usr/share/aisdispatcher/bin/link_binary; \
    chown -R ais:ais /usr/share/aisdispatcher

COPY rootfs /

RUN set -eux; \
    chown -R ais:ais /usr/share/aisdispatcher
