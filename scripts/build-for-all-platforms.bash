#!/bin/bash

set -euo pipefail

xcodebuild build -scheme "GatheredKit-Package" -destination "platform=macOS"
xcodebuild build -scheme "GatheredKit-Package" -destination "platform=macOS,variant=Mac Catalyst"
xcodebuild build -scheme "GatheredKit-Package" -destination "generic/platform=iOS"
xcodebuild build -scheme "GatheredKit-Package" -destination "generic/platform=watchOS"
xcodebuild build -scheme "GatheredKit-Package" -destination "generic/platform=tvOS"
