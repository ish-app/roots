#!/bin/bash -e
cd $(dirname "$0")

podman build --platform=linux/386 .

roots=(appstore-apk)
mkdir -p out
for root in "${roots[@]}"; do
    image=$(podman images --filter label=ish.export="$root.tar.gz" --quiet | head -n1)
    echo "exporting $root $image"
    podman save "$image" -o out/"$root.raw.tar"
    ./flatten.py out/"$root.raw.tar" | gzip -n > out/"$root.tar.gz"
    rm out/"$root.raw.tar"
done
