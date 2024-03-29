#
# Be sure to run `pod lib lint InteractivePush.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RTInteractivePush'
  s.version          = `git describe --abbrev=0`.strip
  s.module_name      = 'RTInteractivePush'
  s.summary          = 'UINavigationController interactive push support'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A easy to use interactive pushing support for UINavigationController, when
 Enabled users can push a new VC by swiping from right edge to left, just like
 pop current VC from left edge to right.
                       DESC

  s.homepage         = 'https://github.com/rickytan/RTInteractivePush'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ricky Tan' => 'ricky.tan.xin@gmail.com' }
  s.source           = { :git => 'https://github.com/rickytan/RTInteractivePush.git', :tag => s.version.to_s }
  s.social_media_url = 'https://github.com/rickytan'

  s.ios.deployment_target = '11.0'
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
end
