#
#  Be sure to run `pod spec lint KYFreeOTP.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

# ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  These will help people to find your library, and whilst it
#  can feel like a chore to fill in it's definitely to your advantage. The
#  summary should be tweet-length, and the description more in depth.
#
s.name         = "KYFreeOTP"
s.version      = "0.0.5"
s.summary      = "KYFreeOTP 是一个免费的otp算法生成类库."

s.homepage     = "https://github.com/kingly09/KYFreeOTP"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author       = { "kingly" => "libintm@163.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/kingly09/KYFreeOTP.git", :tag => s.version.to_s }
s.social_media_url   = "https://github.com/kingly09"
s.source_files = 'KYFreeOTP/**/*'
s.requires_arc = true


end
