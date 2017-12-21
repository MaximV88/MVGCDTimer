#
# Be sure to run `pod lib lint MVGCDTimer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'MVGCDTimer'
s.version          = '0.1.0'
s.summary          = 'A timer based on GCD. To be used on threads without runloop (GCD threads).'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
This timer abstracts interaction with dispatch commands into a simple timer interface that is similar to NSTimer, but with the added benefit of changing trigger block at any time and restart count.
DESC

s.homepage         = 'https://github.com/maximv88/MVGCDTimer'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'maximv88' => 'maximv88@gmail.com' }
s.source           = { :git => 'https://github.com/maximv88/MVGCDTimer.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = 'MVGCDTimer/Classes/**/*'

# s.resource_bundles = {
#   'MVGCDTimer' => ['MVGCDTimer/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end

