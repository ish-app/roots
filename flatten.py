#!/usr/bin/env python3
import tarfile
import json
import sys
import os

WHITEOUT = '.wh.'

def flatten(image, output):
    manifest = json.load(image.extractfile('manifest.json'))
    assert len(manifest) == 1
    manifest = manifest[0]
    entries = {}
    layers = [tarfile.open(fileobj=image.extractfile(layer)) for layer in manifest['Layers']]
    for layer in layers:
        for info in layer.getmembers():
            info.name = './' + info.name
            dirname, sep, basename = info.name.rpartition('/')
            if basename.startswith(WHITEOUT):
                del entries[dirname+sep+basename[len(WHITEOUT):]]
            else:
                entries[info.name] = layer, info
    # need a root entry
    if './' not in entries:
        info = tarfile.TarInfo('./')
        info.type = tarfile.DIRTYPE
        info.mode = 0o755
        entries[info.name] = None, info
    for layer, info in entries.values():
        fileobj = layer.extractfile(info) if info.isfile() else None
        output.addfile(info, fileobj)
    for layer in layers:
        layer.close()

with tarfile.open(sys.argv[1]) as image:
    with tarfile.open(sys.argv[2], 'x') as output:
        flatten(image, output)
