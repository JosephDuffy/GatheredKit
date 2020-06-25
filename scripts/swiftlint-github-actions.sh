#!/bin/bash

# convert swiftlint's output into GitHub Actions Logging commands
# https://help.github.com/en/github/automating-your-workflow-with-github-actions/development-tools-for-github-actions#logging-commands
# Modified from https://github.com/norio-nomura/action-swiftlint/blob/master/entrypoint.sh to run against all files

function stripPWD() {
    sed -E "s/$(pwd|sed 's/\//\\\//g')\///"
}

function convertToGitHubActionsLoggingCommands() {
    sed -E 's/^(.*):([0-9]+):([0-9]+): (warning|error|[^:]+): (.*)/::\4 file=\1,line=\2,col=\3::\5/'
}

function swiftlint() {
    swift run --skip-update --configuration release --package-path ./DevelopmentDependencies/ swiftlint
}

set -o pipefail && swiftlint "$@" | stripPWD | convertToGitHubActionsLoggingCommands