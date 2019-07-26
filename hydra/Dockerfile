FROM alpine:latest
LABEL maintainer 'Antoine POPINEAU <antoine.popineau@appscho.com>'

ARG HYDRA_DOWNLOAD_URL

RUN apk add -U ca-certificates curl
RUN curl -L $HYDRA_DOWNLOAD_URL > /tmp/hydra.tar.gz && \
    tar zxf /tmp/hydra.tar.gz -C /tmp && \
    ls -R /tmp

FROM scratch
LABEL maintainer 'Antoine POPINEAU <antoine.popineau@appscho.com>'

COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=0 /tmp/hydra /usr/bin/hydra

USER 1000

ENTRYPOINT ["hydra"]
CMD ["serve", "all"]