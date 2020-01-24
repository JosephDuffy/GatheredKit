#!/bin/bash

cd DevelopmentDependencies
swift run --skip-update danger-swift local --danger-js-path $(yarn bin danger) --verbose
