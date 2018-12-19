#
# Be sure to run `pod lib lint OrderPlaceSdk.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OrderPlaceSdk'
  s.version          = '0.2.7'
  s.summary          = 'OrderPlaceSdk Alpha.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
OrderPlaceSdk for embed Mobile Ordering into your apps.
                       DESC

  s.homepage         = 'https://github.com/aigens/order-place-sdk-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Peter Liu' => 'peter.liu@aigens.com' }
  s.source           = { :git => 'https://github.com/aigens/order-place-sdk-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'OrderPlaceSdk/Classes/**/*'
  
  s.resource_bundles = {
      'OrderPlaceSdk' => ['OrderPlaceSdk/Assets/**/*.{storyboard,xib}']
  }

  s.swift_version = '3.3'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
