#!/bin/sh

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <directory> [base-path]" >&2
     exit 1
fi

if [ "$#" -eq 2 ]; then
    BASE_PATH="$2"
else
    BASE_PATH="/"
fi

# This _should_ generate a directory with the documentation for all targets, but
# the each target overrides the previous target.
# See: https://github.com/apple/swift/issues/58556
swift package \
    --allow-writing-to-directory "$1" \
    generate-documentation \
    --disable-indexing \
    --output-path "$1" \
    --transform-for-static-hosting \
    --hosting-base-path "$BASE_PATH"
