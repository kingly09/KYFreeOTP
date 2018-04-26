#
# Be sure to run `pod lib lint KYFreeOTP.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  
  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #
  s.name         = "KYFreeOTP"
  s.version      = "0.0.8"
  s.summary      = "KYFreeOTP 是一个免费的otp算法生成类库."
  
  s.homepage     = "https://github.com/kingly09/KYFreeOTP"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "kingly" => "libintm@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/kingly09/KYFreeOTP.git", :tag => s.version.to_s }
  s.social_media_url   = "https://github.com/kingly09"
  s.source_files = 'KYFreeOTP/Classes/**/*'
  s.module_map = 'KYFreeOTP/Modules/module.modulemap'
  
  s.requires_arc = true
  
  
end
