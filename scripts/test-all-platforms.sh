#!/bin/bash

swift package generate-xcodeproj --enable-code-coverage --skip-extra-files
bundle exec fastlane scan --clean --destination "name=iPhone 8"
bundle exec fastlane scan --clean --destination "platform=macOS"
bundle exec fastlane scan --clean --destination "name=Apple TV"
