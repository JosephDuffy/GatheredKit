#!/bin/bash

swift run --package-path ./DevelopmentDependencies/ --skip-update swiftlint "$@"
