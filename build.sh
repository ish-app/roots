#!/bin/bash -e
cd $(dirname "$0")

docker build .

roots=(appstore appstore-apk)
mkdir -p out
for root in "${roots[@]}"; do
    image=$(docker images --filter label=ish.export="$root.tar.gz" --quiet | head -n1)
    echo "exporting $root $image"
    docker save "$image" -o out/"$root.raw.tar"
    rm -f out/"$root.tar"
    ./flatten.py out/"$root.raw.tar" out/"$root.tar"
    gzip -f out/"$root.tar"
    rm out/"$root.raw.tar"
done
