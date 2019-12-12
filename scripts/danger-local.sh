#!/bin/bash

cd DevelopmentDependencies
swift run --skip-update danger-swift ci --danger-js-path $(yarn bin danger) --verbose
