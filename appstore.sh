script <<END
apk del apk-tools
rm -rf /usr/share/apk
: >/etc/motd
END
