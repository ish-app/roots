source lib.sh

root_import alpine-minirootfs-3.12.0-x86.tar.gz
script <<END
apk del apk-tools
rm -rf /usr/share/apk
END
root_export busybox.tar.gz
