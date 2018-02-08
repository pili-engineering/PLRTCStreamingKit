#
# Be sure to run `pod lib lint PLPlayerKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "PLRTCStreamingKit"
  s.version          = "3.1.0"
  s.summary          = "Pili iOS media streaming framework via RTMP."
  s.homepage         = "https://github.com/pili-engineering/PLRTCStreamingKit"
  s.license          = 'Apache License, Version 2.0'
  s.author           = { "pili" => "pili@qiniu.com" }
  s.source           = { :git => "https://github.com/pili-engineering/PLRTCStreamingKit.git", :tag => "v#{s.version}" }

  s.platform     = :ios
  s.ios.deployment_target = '8.0'

  s.requires_arc = true  
 
  s.frameworks = ['UIKit', 'AVFoundation', 'CoreGraphics', 'CFNetwork', 'AudioToolbox', 'CoreMedia', 'VideoToolbox']
  s.libraries = 'z', 'c++', 'icucore', 'sqlite3'
  
  s.subspec "iphoneos" do |ss1|
    ss1.vendored_framework = ['Pod/Library/PLRTCStreamingKit.framework', 'Pod/Library/HappyDNS.framework']
end

end
