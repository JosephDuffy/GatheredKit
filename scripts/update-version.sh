#!/bin/bash

if [ $# -ne 1 ]; then
    echo "A single argument specifying the version must be provided"
    exit 1
fi

VERSION=$1
NORMALISED_VERSION=${VERSION#"v"}

if [ "$NORMALISED_VERSION" = "$VERSION" ]; then
    echo "Version should start with a \"v\""
    exit 1
fi

echo "Setting version in Xcode project to $NORMALISED_VERSION"
sed -E -i "" "s/(VERSION_NUMBER[[:blank:]]*=[[:blank:]]*).*;/\1$NORMALISED_VERSION;/" ./Gathered.xcodeproj/project.pbxproj
echo "Setting version in Podspec to $NORMALISED_VERSION"
sed -E -i "" "s/(spec\\.version[[:blank:]]*=[[:blank:]]*)\".*\"/\1\"$NORMALISED_VERSION\"/" ./Gathered.podspec
