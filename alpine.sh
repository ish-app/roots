script <<END
cat >/etc/motd <<MOTD
Welcome to Alpine!

You can install packages with: apk add <package>

You may change this message by editing /etc/motd.

MOTD
END
