FROM alpine
MAINTAINER jspc <james.condron@ft.com>

RUN apk update && \
    apk add mysql-client && \
    rm -rvf /tmp/* && \
    rm -rvf /var/cache/apk/*

COPY src/ db/
ENTRYPOINT ["/db/entrypoint.sh"]
