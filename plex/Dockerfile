FROM arm64v8/ubuntu:19.10
LABEL maintainer 'Antoine POPINEAU <antoine.popineau@appscho.com>'

ARG PLEX_DOWNLOAD_URL
ARG S6_OVERLAY_VERSION=v1.17.2.0
ARG DEBIAN_FRONTEND="noninteractive"
ENV TERM="xterm" LANG="C.UTF-8" LC_ALL="C.UTF-8"

RUN apt-get update && \
    apt-get install -y tzdata curl xmlstarlet uuid-runtime unrar && \
    useradd -U -d /config -s /bin/false plex && \
    usermod -G users plex && \
    mkdir -p /config /transcode /data && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV CHANGE_CONFIG_DIR_OWNERSHIP="true" \
    HOME="/config"

ARG TAG=public
ARG URL=$PLEX_DOWNLOAD_URL

COPY pms-docker/root/ /

RUN /installBinary.sh

HEALTHCHECK --interval=5s --timeout=2s --retries=20 CMD /healthcheck.sh || exit 1

ENV LD_LIBRARY_PATH=/usr/lib/plexmediaserver:/usr/lib/plexmediaserver/lib
CMD ["/usr/lib/plexmediaserver/Plex Media Server"]
