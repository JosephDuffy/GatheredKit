# CocoaPods is only used to pin the version of SwiftLint used; it does not
# provide any build- or run-time dependencies
#
# SwiftLint is pinned to avoid the different rules that each version can have
#
# `integrate_targets => false` is used to prevent CocoaPods modifying the project or
# creating a worspace

platform :ios, '9.0'

install! 'cocoapods', :integrate_targets => false

target 'GatheredKit' do
    pod 'SwiftLint'
end
