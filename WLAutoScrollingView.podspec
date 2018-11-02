#
# Be sure to run `pod lib lint WLAutoScrollingView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WLAutoScrollingView'
  s.version          = '0.1.2'
  s.summary          = 'A simple Auto scrolling View'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Nomeqc/WLAutoScrollingView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'nomeqc@gmail.com' => 'xie5405@163.com' }
  s.source           = { :git => 'https://github.com/Nomeqc/WLAutoScrollingView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.source_files = 'WLAutoScrollingView/Classes/**/*'
  s.public_header_files = 'WLAutoScrollingView/Classes/**/*.h'
end
