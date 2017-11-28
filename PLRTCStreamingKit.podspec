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
  s.version          = "3.0.0"
  s.summary          = "Pili iOS media streaming framework via RTMP."
  s.homepage         = "https://github.com/pili-engineering/PLRTCStreamingKit"
  s.license          = 'Apache License, Version 2.0'
  s.author           = { "pili" => "pili@qiniu.com" }
  s.source           = { :git => "https://github.com/pili-engineering/PLRTCStreamingKit.git", :tag => "v#{s.version}" }

  s.platform     = :ios
  s.ios.deployment_target = '7.0'

  s.requires_arc = true  
 
  s.dependency 'pili-librtmp', '1.0.7'
  s.dependency 'HappyDNS', '0.3.10'
  s.dependency 'QNNetDiag', '0.0.6'
  s.frameworks = ['UIKit', 'AVFoundation', 'CoreGraphics', 'CFNetwork', 'AudioToolbox', 'CoreMedia', 'VideoToolbox']
  s.libraries = 'z', 'c++', 'icucore', 'sqlite3'
  s.vendored_libraries = 'Pod/Library/*.a'

  s.subspec "PLCameraStreamingKit" do |ss1|
    ss1.public_header_files = 'Pod/Library/include/PLCameraStreamingKit/*.h'
    ss1.source_files = 'Pod/Library/include/PLCameraStreamingKit/*.h'
  end

  s.subspec "PLStreamingKit" do |ss2|
    ss2.public_header_files = 'Pod/Library/include/PLStreamingKit/*.h'
    ss2.source_files = 'Pod/Library/include/PLStreamingKit/*.h'
   end

  s.subspec "PLRTCStreamingKit" do |ss3|
    ss3.public_header_files = 'Pod/Library/include/PLRTCStreamingKit/*.h'
    ss3.source_files = 'Pod/Library/include/PLRTCStreamingKit/*.h'
  end

  s.subspec "PLMediaStreamingKit" do |ss4|
    ss4.public_header_files = 'Pod/Library/include/PLMediaStreamingKit/*.h'
    ss4.source_files = 'Pod/Library/include/PLMediaStreamingKit/*.h'
  end

  s.subspec "Common" do |ss5|
    ss5.public_header_files = 'Pod/Library/include/Common/*.h'
    ss5.source_files = 'Pod/Library/include/Common/*.h'
  end

  s.subspec "PLRTCKit" do |ss5|
    ss5.public_header_files = 'Pod/Library/include/PLRTCKit/*.h'
    ss5.source_files = 'Pod/Library/include/PLRTCKit/*.h'
  end
end
