#!/usr/bin/env python3
import json
import os
import sys
import tarfile

WHITEOUT = '.wh.'
WHITEOUT_OPAQUE = '.wh..wh..opq'

def flatten(image, output):
    manifest = json.load(image.extractfile('manifest.json'))
    assert len(manifest) == 1
    manifest = manifest[0]

    entries = {}
    layers = [tarfile.open(fileobj=image.extractfile(layer)) for layer in manifest['Layers']]
    for layer in layers:
        real_members = []
        # process whiteout files
        for info in layer.getmembers():
            info.name = './' + info.name
            dirname, sep, basename = info.name.rpartition('/')

            if basename == WHITEOUT_OPAQUE:
                for key in entries.keys():
                    if key.startswith(dirname+sep):
                        del entries[key]
            elif basename.startswith(WHITEOUT):
                del entries[dirname+sep+basename[len(WHITEOUT):]]
            else:
                real_members.append(info)
                continue

        # real files
        for info in real_members:
            entries[info.name] = layer, info

    # need a root entry
    if './' not in entries:
        info = tarfile.TarInfo('./')
        info.type = tarfile.DIRTYPE
        info.mode = 0o755
        entries[info.name] = None, info

    for layer, info in entries.values():
        fileobj = layer.extractfile(info) if info.isfile() else None
        info.mtime = 0 # make reproducible
        output.addfile(info, fileobj)

    for layer in layers:
        layer.close()

with tarfile.open(sys.argv[1]) as image:
    with tarfile.open(fileobj=sys.stdout.buffer, mode='w|') as output:
        flatten(image, output)
