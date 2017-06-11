#
# Be sure to run `pod lib lint MochaUtilities.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MochaUtilities'
  s.version          = '0.0.3'
  s.summary          = 'A framework designed to deal with some common iOS needs.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
MochaUtilities is designed to assist developers with common problems/needs that can be found during iOS programming.
                       DESC

  s.homepage         = 'https://github.com/gregorysholl/mocha-utilities'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gregory Sholl e Santos' => 'gregorysholl@gmail.com' }
  s.source           = { :git => 'https://github.com/gregorysholl/mocha-utilities.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MochaUtilities/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MochaUtilities' => ['MochaUtilities/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.default_subspecs = 'Core', 'Images', 'Network'

  s.subspec 'Basic' do |basic|
    basic.source_files = 'MochaUtilities/Classes/Basic/**/*'
  end

  s.subspec 'Brazil' do |brazil|
    brazil.dependency 'MochaUtilities/Core'
    brazil.source_files = 'MochaUtilities/Classes/Brazil/**/*'
  end

  s.subspec 'Core' do |core|
    core.dependency 'MochaUtilities/Basic'
    core.source_files = 'MochaUtilities/Classes/Core/**/*'
  end

  s.subspec 'Images' do |images|
    images.dependency 'MochaUtilities/Basic'
    images.source_files = 'MochaUtilities/Classes/Images/**/*'
  end

  s.subspec 'Network' do |network|
    network.dependency 'MochaUtilities/Basic'
    network.source_files = 'MochaUtilities/Classes/Network/**/*'
  end

end
