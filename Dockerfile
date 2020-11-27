FROM --platform=linux/386 alpine:3.12.0 AS ish-alpine

FROM ish-alpine
LABEL ish.export=appstore.tar.gz
RUN apk del apk-tools && rm -rf /usr/share/apk
RUN : > /etc/motd

FROM ish-alpine
LABEL ish.export=appstore-apk.tar.gz
COPY apk-motd /etc/motd
COPY odr-repositories /etc/apk/repositories
