FROM --platform=linux/386 docker.io/library/alpine:3.14.3 AS ish-alpine

FROM ish-alpine
LABEL ish.export=appstore-apk.tar.gz
RUN mkdir /ish && touch /ish/version
RUN echo 296 > /ish/apk-version
COPY apk-motd /etc/motd
