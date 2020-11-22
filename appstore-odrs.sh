script <<END
cat >/etc/motd <<MOTD
Welcome to Alpine!

You can install packages with: apk add <package>

You may change this message by editing /etc/motd.

MOTD
echo http://localhost:42069/main > /etc/apk/repositories
END
