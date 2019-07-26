FROM arm32v7/ubuntu:18.04
LABEL maintainer 'Antoine POPINEAU <antoine.popineau@appscho.com>'

ARG PLEX_DOWNLOAD_URL
ARG S6_OVERLAY_VERSION=v1.17.2.0
ARG DEBIAN_FRONTEND="noninteractive"
ENV TERM="xterm" LANG="C.UTF-8" LC_ALL="C.UTF-8"

RUN apt-get update && \
		apt-get install -y tzdata curl xmlstarlet uuid-runtime unrar && \
    curl -J -L -o /tmp/s6-overlay-amd64.tar.gz https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
    useradd -U -d /config -s /bin/false plex && \
    usermod -G users plex && \
    mkdir -p /config /transcode /data && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

EXPOSE 32400/tcp 3005/tcp 8324/tcp 32469/tcp 1900/udp 32410/udp 32412/udp 32413/udp 32414/udp
VOLUME /config /transcode

ENV CHANGE_CONFIG_DIR_OWNERSHIP="true" \
    HOME="/config"

ARG TAG=public
ARG URL=$PLEX_DOWNLOAD_URL

COPY pms-docker/root/ /

RUN /installBinary.sh

HEALTHCHECK --interval=5s --timeout=2s --retries=20 CMD /healthcheck.sh || exit 1

ENV LD_LIBRARY_PATH=/usr/lib/plexmediaserver:/usr/lib/plexmediaserver/lib
CMD ["/usr/lib/plexmediaserver/Plex Media Server"]

