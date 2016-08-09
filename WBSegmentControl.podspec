#
# Be sure to run `pod lib lint WBSegmentControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "WBSegmentControl"
  s.version          = "0.1.9"
  s.summary          = "An easy to use, customizable segment control."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
WBSegmentedControl is an easy to use, customizable segment control, has several effects, can be used to show labels or tabs.
                       DESC

  s.homepage         = "https://github.com/xiongxiong/WBSegmentControl"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "xiongxiong" => "ximengwuheng@163.com" }
  s.source           = { :git => "https://github.com/xiongxiong/WBSegmentControl.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WBSegmentControl/Classes/**/*'
  # s.resource_bundles = {
  # 'WBSegmentControl' => ['WBSegmentControl/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
