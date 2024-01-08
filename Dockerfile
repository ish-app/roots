FROM --platform=linux/386 docker.io/library/alpine:3.19.0 AS ish-alpine

FROM ish-alpine
LABEL ish.export=appstore-apk.tar.gz
RUN mkdir /ish && touch /ish/version
RUN echo 31900 > /ish/apk-version
COPY apk-motd /etc/motd
