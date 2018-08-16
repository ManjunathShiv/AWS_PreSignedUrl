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
### ios ensure_xcode_version_for_release
```
fastlane ios ensure_xcode_version_for_release
```
This lane will run before execution of other lane.

This lane will ensure that current Xcode version is selected for AWS S3 project.
### ios tests
```
fastlane ios tests
```

### ios run_ui_test_cases
```
fastlane ios run_ui_test_cases
```
This lane will run UI test-cases of AWS S3 project.

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
