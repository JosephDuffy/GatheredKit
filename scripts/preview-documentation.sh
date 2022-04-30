#!/bin/sh

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <target>" >&2
     exit 1
fi

swift package --disable-sandbox preview-documentation --target "$1"
