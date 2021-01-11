fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Runs tests
### ios perform_pr_checks
```
fastlane ios perform_pr_checks
```
Performs checks that pull requests are required to pass
### ios install_dependencies
```
fastlane ios install_dependencies
```
Installs dependencies via carthage
### ios generate_documentation
```
fastlane ios generate_documentation
```
Generates documentation using jazzy

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).