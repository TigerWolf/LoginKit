#
# Be sure to run `pod lib lint LoginKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LoginKit"
  s.version          = "0.1.0"
  s.summary          = "LoginKit is a framework to help with creating a login screen."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
  This library makes creating a login screen for your app simple by providing some helper methods and services
  that you can easily add into your next iOS app.
                       DESC

  s.homepage         = "https://github.com/TigerWolf/LoginKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Kieran Andrews" => "kieran.andrews@adelaide.edu.au" }
  s.source           = { :git => "https://github.com/TigerWolf/LoginKit.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  # s.source_files = 'Pod/Classes/**/*'
  # s.source_files = "LoginKit/*.swift"
  s.source_files = "LoginKit/**/*.{h,swift}"
  # s.resource_bundles = {
  #   'LoginKit' => ['LoginKit/LoginKit.bundle']
  # }
  s.resources = 'LoginKit/LoginKit.bundle'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'Alamofire', '~> 3.0'
  s.dependency 'SVProgressHUD'
  s.dependency 'KeychainAccess'
  s.dependency 'SwiftyJSON'
end
